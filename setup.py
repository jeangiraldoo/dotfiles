from collections import namedtuple
from colorama import Fore, Style
from pathlib import Path
from enum import Enum
import subprocess
import platform
import yaml
import re

os_name = platform.system()
home = Path.home()
config_path = home / ".config"


class FEEDBACK(Enum):
    SUCCESS = "✅"
    ERROR = "❌"
    INFO = "ℹ️"


class Utils:
    @staticmethod
    def get_formatted_status_msg(msg: str, state: FEEDBACK) -> str:
        emoji = state.value

        return f"{emoji} {msg}"

    @staticmethod
    def process_cmd(cmd: list[str], cwd=None):
        result = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True)
        output = clean_output(result.stderr if result.stderr else result.stdout)

        output_lower = output.lower()
        is_info_case = any(
            kw in output_lower
            for kw in [
                "already exists",
                "already installed",
                "already the current",
                "is not empty",
                "exists and is not an empty directory",
            ]
        )

        if result.returncode == 0:
            feedback = FEEDBACK.SUCCESS
        elif is_info_case:
            feedback = FEEDBACK.INFO
        else:
            feedback = FEEDBACK.ERROR

        msg = Utils.get_formatted_status_msg(output, feedback)
        print(msg)

    @staticmethod
    def map_with_labels(label_base: str, items: list | dict, fn, is_root=False):
        class LabelTemplates(Enum):
            ROOT = ("blue", "")
            STEP = ("cyan", "...")

            def __new__(cls, color: str, suffix: str):
                obj = object.__new__(cls)
                color_value = getattr(Fore, color.upper())
                obj._value_ = (
                    f"{color_value}{label_base} {{label}}{suffix}{Style.RESET_ALL}"
                )
                return obj

        template = (LabelTemplates.ROOT if is_root else LabelTemplates.STEP).value

        if isinstance(items, list):
            prepared = [(template.format(label=item), (item,)) for item in items]
        else:
            prepared = [
                (template.format(label=key), (key, value))
                for key, value in items.items()
            ]

        for i, (line, args) in enumerate(prepared):
            print(line)
            fn(*args)
            print()


def clean_output(text):
    def is_garbled(line):
        # If most of the line is non-ASCII, it's likely a broken progress bar
        non_ascii = sum(1 for c in line if ord(c) > 127)
        return len(line) > 10 and (non_ascii / len(line)) > 0.5

    def is_decorative_or_empty(line):
        stripped = line.strip()
        return stripped in {"", "-", "\\", "|", "/"} or re.fullmatch(
            r"[-\\/|]+", stripped
        )

    lines = text.splitlines()
    cleaned = []

    skipping = True
    for line in lines:
        if skipping and is_decorative_or_empty(line):
            continue
        skipping = False

        if is_garbled(line) or is_decorative_or_empty(line):
            continue

        cleaned.append(line)

    return "\n".join(cleaned).strip()


class Setup:
    BASE_MSG = f"{Fore.MAGENTA}>>> "

    def display_initialization_message():
        INITIALIZATION_MSG = "Initializing system setup sequence...\n"
        formatted_initialization_msg = f"{Setup.BASE_MSG}{INITIALIZATION_MSG}"

        print(formatted_initialization_msg)

    @staticmethod
    def display_exit_message(feedback):
        if feedback.value == FEEDBACK.SUCCESS.value:
            exit_msg = "System setup sequence finished"
        else:
            exit_msg = "The user stopped execution"

        formatted_exit_msg = f"{Setup.BASE_MSG}{exit_msg}"
        print(formatted_exit_msg)

    @staticmethod
    def create_dirs():
        TARGET_DIRECTORIES = [
            ".config",
            ".code/personal",
            ".code/university",
            ".config_test",
        ]

        def create_target_dir(dir_name):
            target_dir: Path = home / dir_name

            if not target_dir.exists():
                target_dir.mkdir(parents=True, exist_ok=True)
                msg = Utils.get_formatted_status_msg(
                    f"Created {target_dir}", FEEDBACK.SUCCESS
                )
            else:
                msg = Utils.get_formatted_status_msg(
                    f"{target_dir} already exists", FEEDBACK.INFO
                )
            print(msg)

        Utils.map_with_labels("Creating", TARGET_DIRECTORIES, create_target_dir)

    @staticmethod
    def install_packages_from_lockfile():
        LOCKFILE_NAME = "lockfile.yaml"
        lockfile_path = Path(__file__).parent / LOCKFILE_NAME

        PkgManagerOpts = namedtuple("PkgManager", ["name", "cmd"])
        PKG_MANAGERS = {
            "Windows": PkgManagerOpts(
                name="winget",
                cmd="winget install --id {id} --version {version}",
            )
        }

        if not (pkg_manager_info := PKG_MANAGERS.get(os_name)):
            error_msg = f"No package manager data defined for {os_name}"
            print(Utils.get_formatted_status_msg(error_msg, FEEDBACK.ERROR))
            return

        pkg_manager_name, pkg_manager_cmd = pkg_manager_info.name, pkg_manager_info.cmd

        def run_pkg_mgr_install_cmd(_, pkg_data: dict):
            manager_data = pkg_data.get(pkg_manager_name)
            if not manager_data:
                error_msg = f"The package can't be installed: no data defined for {pkg_manager_name}"
                print(Utils.get_formatted_status_msg(error_msg, FEEDBACK.INFO))
                return

            pkg_id = manager_data.get("id")
            pkg_version = manager_data.get("version")
            if not pkg_id or not pkg_version:
                msg = f"Incomplete package info for {pkg_manager_name}"
                print(Utils.get_formatted_status_msg(msg, FEEDBACK.ERROR))
                return

            cmd = pkg_manager_cmd.format(id=pkg_id, version=pkg_version)
            Utils.process_cmd(cmd)

        with open(lockfile_path, "r") as file:
            loaded_file = yaml.safe_load(file)

            if not (packages := loaded_file.get("packages")):
                msg = f"No 'packages' key found in {LOCKFILE_NAME}"
                print(Utils.get_formatted_status_msg(msg, FEEDBACK.ERROR))
                return
            Utils.map_with_labels("Installing", packages, run_pkg_mgr_install_cmd)

    @staticmethod
    def clone_repos():
        USERNAME = "jeangiraldoo"
        base_url = f"https://github.com/{USERNAME}/"

        TARGETS = {
            home / ".code/university": [
                "scripts",
                "codedocs.nvim",
                "flowizi",
                USERNAME,
                f"{USERNAME}.github.io",
                "tomura",
            ],
            home / ".config_test": ["dotfiles"],
        }

        def run_clone_cmd(repo_name: str, base_dir: Path):
            if repo_name == "dotfiles":
                # Clone "dotfiles" directly into the base directory, not a nested subfolder
                repo_dest: Path | str = "."
                cwd = base_dir
            else:
                repo_dest: Path | str = base_dir / repo_name

                if repo_dest.exists():
                    msg = f"'{repo_name}' is already cloned at {repo_dest} or the directory is not empty."
                    print(Utils.get_formatted_status_msg(msg, FEEDBACK.INFO))
                    return

                cwd = None

            cmd = ["git", "clone", f"{base_url}{repo_name}", str(repo_dest)]
            Utils.process_cmd(cmd, cwd)

        for base_dir, repo_names in TARGETS.items():
            Utils.map_with_labels(
                "Cloning", repo_names, lambda name: run_clone_cmd(name, base_dir)
            )

    @staticmethod
    def create_symlinks():
        TARGET_DIRECTORIES = {
            "Windows": {
                ".config/nvim": "AppData/Local/nvim",
                ".config/.gitconfig": ".gitconfig",
            }
        }

        if (symlinks := TARGET_DIRECTORIES.get(os_name)) is None:
            error_msg = f"No symlink mappings are defined for {os_name}"
            print(Setup.get_formatted_status_msg(error_msg, FEEDBACK.ERROR))
            return

        def link_pair(source_path, symlink_location):
            symlink_path: Path = home / symlink_location
            actual_file: Path = home / source_path

            if not actual_file.exists():
                error_msg = f"Target file does not exist → {actual_file}"
                print(Utils.get_formatted_status_msg(error_msg, FEEDBACK.ERROR))
                return

            if symlink_path.exists() and not symlink_path.is_symlink():
                error_msg = f"{symlink_path} already exists and is not a symlink"
                print(Utils.get_formatted_status_msg(error_msg, FEEDBACK.ERROR))
                return

            if symlink_path.is_symlink():
                try:
                    file_symlink_points_to = symlink_path.resolve(strict=True)
                except FileNotFoundError:
                    file_symlink_points_to = None

                if file_symlink_points_to == actual_file:
                    info_msg = f"Symlink already exists and is correct: {symlink_path} → {actual_file}"
                    print(Utils.get_formatted_status_msg(info_msg, FEEDBACK.INFO))
                    return
                else:
                    error_msg = (
                        f"Symlink mismatch at: {symlink_path}\n"
                        f"  ↳ Currently points to: {file_symlink_points_to}\n"
                        f"  ↳ Expected target:      {actual_file}"
                    )
                    print(Utils.get_formatted_status_msg(error_msg, FEEDBACK.ERROR))
                    return

            try:
                symlink_path.symlink_to(actual_file)
                msg = f"Symlink created: {symlink_path} → {actual_file}"
                feedback = FEEDBACK.SUCCESS
            except OSError:
                msg = "Elevated privileges are required"
                feedback = FEEDBACK.ERROR

            print(Utils.get_formatted_status_msg(msg, feedback))

        Utils.map_with_labels("Linking", symlinks, link_pair)

    @staticmethod
    def create_persistent_env_vars():
        env_vars = {
            "LOCKFILE": config_path / "lockfile.yaml",
            "EDITOR": "nvim",
            "YAZI_CONFIG_HOME": config_path / "yazi/",
            "GIT_CONFIG_GLOBAL": config_path / ".gitconfig",
        }

        EnvOps = namedtuple("EnvOps", ["set_env", "get_env"])
        ENV_VAR_CMDS = {
            "Windows": EnvOps(
                set_env=lambda name, value: subprocess.run(
                    [
                        "powershell",
                        "-Command",
                        f'[System.Environment]::SetEnvironmentVariable("{name}", "{value}", "User")',
                    ],
                    check=True,
                ),
                get_env=lambda name: subprocess.run(
                    [
                        "powershell",
                        "-Command",
                        f'[Environment]::GetEnvironmentVariable("{name}", "User")',
                    ],
                    capture_output=True,
                    text=True,
                ),
            )
        }

        if (os_env_operations := ENV_VAR_CMDS.get(os_name)) is None:
            msg = f"There's no environment-variable operations to use on {os_name}"
            print(Utils.get_formatted_status_msg(msg, FEEDBACK.INFO))
            return

        def set_env_var(name, value):
            result = os_env_operations.get_env(name)
            current_value: str = result.stdout.strip()
            expected_value = str(value)

            if current_value:
                if current_value == expected_value:
                    msg = f"{name} already exists and matches the expected value:\n→ {current_value}"
                    feedback = FEEDBACK.INFO
                else:
                    msg = (
                        f"{name} already exists but differs:\n"
                        f"→ Current:  {current_value}\n"
                        f"→ Expected: {expected_value}"
                    )
                    feedback = FEEDBACK.ERROR
            else:
                try:
                    os_env_operations.set_env(name, expected_value)
                    msg = f"{name} was successfully set to:\n→ {expected_value}"
                    feedback = FEEDBACK.SUCCESS
                except Exception as e:
                    msg = f"{name} could not be set due to an exception:\n→ {e}"
                    feedback = FEEDBACK.ERROR

            print(Utils.get_formatted_status_msg(msg, feedback))

        Utils.map_with_labels("Setting", env_vars, set_env_var)


if __name__ == "__main__":
    STEPS = {
        # "Creating directories:\n": Setup.create_dirs,
        # "Installing packages:\n": Setup.install_packages_from_lockfile,
        # "Cloning repositories:\n": Setup.clone_repos,
        # "Creating symlinks:\n": Setup.create_symlinks,
        "Setting environment variables:\n": Setup.create_persistent_env_vars,
    }

    Setup.display_initialization_message()

    try:
        Utils.map_with_labels("-", STEPS, lambda _, fn: fn(), is_root=True)
        feedback = FEEDBACK.SUCCESS
    except KeyboardInterrupt:
        feedback = FEEDBACK.ERROR

    Setup.display_exit_message(feedback)
