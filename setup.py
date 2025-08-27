"""
Automates the initial system setup by creating directories, setting up symlinks,
configuring environment variables and cloning repositories.

The data for the aforementioned operations is expected in the form of a YAML file.
"""

from colorama import Fore, Style
from pathlib import Path
from typing import Callable, cast
import subprocess
import platform
import yaml
import re
from typing import TypeVar

T = TypeVar("T")

SETUP_DATA_FILE_NAME = "system_lock.yaml"
RAW_CONFIG_PATH = "~/.config"


def expand_path(raw_path: str) -> Path:
    path = Path(raw_path)
    return path.expanduser()


os_name = platform.system().lower()
config_path = expand_path(RAW_CONFIG_PATH)
data_path = config_path / SETUP_DATA_FILE_NAME

with open(data_path, "r") as file:
    data = cast(
        dict[
            str,
            list[str]  # directories
            | dict[str, list[str]]  # repositories
            | dict[str, dict[str, str]]  # symlinks
            | dict[str, str]  # environment_variables
            | dict[str, dict[str, dict[str, str]]],  # packages
        ],
        yaml.safe_load(file),
    )


class DisplayMessage:
    @staticmethod
    def _display(prefix: str, text: str):
        print(f"{prefix} {text}")

    @staticmethod
    def info(text: str):
        INFO_ICON = "ℹ️"
        DisplayMessage._display(INFO_ICON, text)

    @staticmethod
    def success(text: str):
        SUCCESS_ICON = "✅"
        DisplayMessage._display(SUCCESS_ICON, text)

    @staticmethod
    def error(text: str):
        ERROR_ICON = "❌"
        DisplayMessage._display(ERROR_ICON, text)

    class state:
        @staticmethod
        def _display(text: str):
            PREFIX = f"{Fore.MAGENTA}>>>"
            print(f"{PREFIX} {text}")

        @staticmethod
        def INITIALIZATION():
            DisplayMessage.state._display("Initializing system setup sequence...\n")

        @staticmethod
        def SUCCESS():
            DisplayMessage.state._display("System setup sequence finished")

        @staticmethod
        def EXEC_STOPPED():
            DisplayMessage.state._display("The user stopped execution")


def clean_output(text: str) -> str:
    def is_garbled(line: str) -> bool:
        line_length = len(line)
        if line_length <= 10:
            return False

        non_ascii_chars = [char for char in line if ord(char) > 127]
        non_ascii_ratio = len(non_ascii_chars) / line_length

        return non_ascii_ratio > 0.5

    def is_decorative_or_empty(line: str) -> bool:
        stripped_line = line.strip()

        if stripped_line == "" or re.fullmatch(r"[-\\/|]+", stripped_line):
            return True

        return False

    lines: list[str] = text.splitlines()
    cleaned: list[str] = []

    for line in lines:
        if is_garbled(line) or is_decorative_or_empty(line):
            continue

        cleaned.append(line)

    return "\n".join(cleaned).strip().lower()


def process_cmd(cmd: list[str] | str, cwd: Path | None = None):
    try:
        process_result = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True)
    except NotADirectoryError:
        DisplayMessage.error(f"Directory does not exist: {cwd}")
        return

    cmd_output = (
        process_result.stderr if process_result.stderr else process_result.stdout
    )

    cleaned_output = clean_output(cmd_output)

    if process_result.returncode == 0:
        DisplayMessage.success(cleaned_output)
        return

    INFO_KEYWORDS = [
        "already exists",
        "already installed",
        "already the current",
        "is not empty",
        "exists and is not an empty directory",
    ]

    is_info_case = any(kw in cleaned_output for kw in INFO_KEYWORDS)

    if is_info_case:
        DisplayMessage.info(cleaned_output)
        return

    DisplayMessage.error(cleaned_output)


def map_with_labels(
    label_base: str,
    items: list[str] | dict,
    fn: Callable[..., None],
    is_root=False,
):
    """
    Iterate over a list or dictionary of items, printing a formatted status label for each one
    and applying a user-provided function.

    This function is used throughout the script to display progress messages (with colored labels)
    while executing setup steps or other operations tied to items.

    Behavior:
        - If `items` is a list of strings:
            Each string is printed with the label format and passed as a single argument to `fn`
        - If `items` is a dict:
            Each key is used in the label, and both `(key, value)` are passed to `fn`

    """

    LABEL_FORMATS = {
        "root": {
            "colour": Fore.BLUE,
            "suffix": "",
        },
        "step": {"colour": Fore.CYAN, "suffix": "..."},
    }

    label_format_key = "root" if is_root else "step"
    label_format: dict[str, str] = LABEL_FORMATS.get(label_format_key)  # pyright: ignore[reportAssignmentType]
    label_colour, label_suffix = label_format.get("colour"), label_format.get("suffix")
    template = f"{label_colour}{label_base} {{label}}{label_suffix}{Style.RESET_ALL}"

    prepared: list[tuple[str, tuple[str] | tuple[str, str]]]
    if isinstance(items, list):
        prepared = [(template.format(label=item), (item,)) for item in items]
    else:
        prepared = [
            (template.format(label=key), (key, value)) for key, value in items.items()
        ]

    for i, (line, args) in enumerate(prepared):
        print(line)
        fn(*args)
        print()


def create_directories():
    directories: list[str] = data.get("directories")  # pyright: ignore[reportAssignmentType]

    def create_target_dir(dir_name: str):
        target_dir: Path = expand_path(dir_name)

        if target_dir.exists():
            DisplayMessage.info(f"{target_dir} already exists")
            return

        target_dir.mkdir(parents=True, exist_ok=True)
        DisplayMessage.success(f"Created {target_dir}")

    map_with_labels("Creating", directories, create_target_dir)


def install_packages():
    packages: dict[str, dict[str, dict[str, str]]] = data.get("packages")  # pyright: ignore[reportAssignmentType]

    PKG_MANAGERS = {
        "windows": {
            "name": "winget",
            "cmd": "winget install --id {id} --version {version}",
        }
    }

    if not (pkg_manager_info := PKG_MANAGERS.get(os_name)):
        DisplayMessage.error(f"No package manager data defined for {os_name}")
        return

    pkg_manager_name: str = pkg_manager_info.get("name")  # pyright: ignore[reportAssignmentType]
    pkg_manager_cmd: str = pkg_manager_info.get("cmd")  # pyright: ignore[reportAssignmentType]

    def run_pkg_mgr_install_cmd(_, pkg_data: dict):
        manager_data = pkg_data.get(pkg_manager_name)
        if not manager_data:
            DisplayMessage.error(
                f"The package can't be installed: no data defined for {pkg_manager_name}"
            )
            return

        pkg_id, pkg_version = manager_data.get("id"), manager_data.get("version")
        if not pkg_id or not pkg_version:
            DisplayMessage.error(f"Incomplete package info for {pkg_manager_name}")
            return

        pkg_install_cmd = pkg_manager_cmd.format(id=pkg_id, version=pkg_version)
        process_cmd(pkg_install_cmd)

    map_with_labels("Installing", packages, run_pkg_mgr_install_cmd)


def clone_repositories():
    USERNAME = "jeangiraldoo"
    base_url = f"https://github.com/{USERNAME}/"

    repositories: dict[str, list[str]] = data.get("repositories")  # pyright: ignore[reportAssignmentType]

    def run_clone_cmd(repo_name: str, base_dir: str):
        dir = expand_path(base_dir)
        repo_dest: Path | str
        if repo_name == "dotfiles":
            # Clone "dotfiles" directly into the base directory, not a nested subfolder
            repo_dest = "."
            cwd = dir
        else:
            repo_dest = dir / repo_name

            if repo_dest.exists():
                DisplayMessage.info(
                    f"'{repo_name}' is already cloned at {repo_dest} or the directory is not empty."
                )
                return

            cwd = None

        cmd = ["git", "clone", f"{base_url}{repo_name}", str(repo_dest)]
        process_cmd(cmd, cwd)
        # DisplayMessage.success(f"Cloned {repo}")

    for base_dir, repo_names in repositories.items():
        map_with_labels(
            "Cloning", repo_names, lambda name: run_clone_cmd(name, base_dir)
        )


def create_symlinks():
    all_symlinks: dict[str, dict[str, str]] = data.get("symlinks")  # pyright: ignore[reportAssignmentType]

    if not (symlinks := all_symlinks.get(os_name)):
        DisplayMessage.error(f"No symlink mappings are defined for {os_name}")
        return

    def link_pair(source_path: str, symlink_location: str):
        symlink_path: Path = expand_path(symlink_location)
        actual_file: Path = expand_path(source_path)

        if not actual_file.exists():
            DisplayMessage.error(f"Target file does not exist → {actual_file}")
            return

        if symlink_path.exists() and not symlink_path.is_symlink():
            DisplayMessage.error(f"{symlink_path} already exists and is not a symlink")
            return

        if symlink_path.is_symlink():
            try:
                file_symlink_points_to = symlink_path.resolve(strict=True)
            except FileNotFoundError:
                file_symlink_points_to = "(broken symlink)"

            if file_symlink_points_to == actual_file:
                DisplayMessage.info(
                    f"Symlink already exists and is correct: {symlink_path} → {actual_file}"
                )
                return

            DisplayMessage.error(
                f"Symlink mismatch at: {symlink_path}\n"
                f"  ↳ Currently points to: {file_symlink_points_to}\n"
                f"  ↳ Expected target:      {actual_file}"
            )
            return

        try:
            symlink_path.symlink_to(actual_file)
            DisplayMessage.success(f"Symlink created: {symlink_path} → {actual_file}")
        except OSError:
            DisplayMessage.error("Elevated privileges are required")

    map_with_labels("Linking", symlinks, link_pair)


def create_environment_variables():
    env_vars: dict[str, str] = data.get("environment_variables")  # pyright: ignore[reportAssignmentType]

    OS_CMDS = {
        "windows": {
            "set": [
                "powershell",
                "-Command",
                '[System.Environment]::SetEnvironmentVariable("{name}", "{value}", "User")',
            ],
            "get": [
                "powershell",
                "-Command",
                '[Environment]::GetEnvironmentVariable("{name}", "User")',
            ],
        }
    }

    cmds: dict[str, list[str]] | None = OS_CMDS.get(os_name)
    if cmds is None:
        DisplayMessage.error(f"No environment variable commands found for {os_name}")
        return

    def run_env_cmd(action: str, **kwargs: str) -> subprocess.CompletedProcess[str]:
        cmd_template: list[str] = cmds[action].copy()
        cmd_template[-1] = cmd_template[-1].format(**kwargs)
        return subprocess.run(
            cmd_template, capture_output=True, text=True, check=(action == "set")
        )

    def set_env(name: str, value: str) -> None:
        _ = run_env_cmd("set", name=name, value=value)

    def get_env(name: str) -> str:
        result = run_env_cmd("get", name=name)
        return result.stdout.strip()

    def set_env_var(name: str, original_value: str):
        value: Path | str = (
            expand_path(original_value)
            if original_value.startswith("~")
            else original_value
        )
        current_value: str = get_env(name)
        expected_value = str(value)

        if current_value:
            if current_value == expected_value:
                DisplayMessage.info(
                    f"{name} already exists and matches the expected value:\n→ {current_value}"
                )
                return

            msg = (
                f"{name} already exists but differs:\n"
                f"→ Current:  {current_value}\n"
                f"→ Expected: {expected_value}"
            )
            DisplayMessage.error(msg)
            return

        set_env(name, expected_value)
        DisplayMessage.success(f"{name} was successfully set to:\n→ {expected_value}")

    map_with_labels("Setting", env_vars, set_env_var)


if __name__ == "__main__":
    STEPS = {
        "Creating directories:\n": create_directories,
        "Installing packages:\n": install_packages,
        "Cloning repositories:\n": clone_repositories,
        "Creating symlinks:\n": create_symlinks,
        "Setting environment variables:\n": create_environment_variables,
    }

    DisplayMessage.state.INITIALIZATION()

    try:
        map_with_labels("-", STEPS, lambda _, step_runner: step_runner(), is_root=True)
        DisplayMessage.state.SUCCESS()
    except KeyboardInterrupt:
        DisplayMessage.state.EXEC_STOPPED()
