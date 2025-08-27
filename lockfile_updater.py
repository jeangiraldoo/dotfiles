import os
import platform
import subprocess
import re
import yaml
from pathlib import Path
from enum import Enum
from collections import namedtuple
from colorama import Fore, Style

# --- Configuration ---
os_name = platform.system()
lockfile_path = os.environ.get("LOCKFILE")
default_pkg_manager = "winget"
home = Path.home()

PKG_MANAGER_CMDS = {
    "Windows": {
        "default": "winget",
        "winget": {
            "read_latest": "winget show --id {id}",
            "update": "winget update --id {id}",
        },
    }
}

system_pkg_managers_data = PKG_MANAGER_CMDS.get(os_name)
default_pkg_manager = system_pkg_managers_data.get("default")
manager_data = system_pkg_managers_data.get(default_pkg_manager)


# --- Feedback Icons ---
class FEEDBACK(Enum):
    SUCCESS = "✅"
    ERROR = "❌"
    INFO = "ℹ️"


def get_formatted_status_msg(msg: str, state: FEEDBACK) -> str:
    return f"{state.value} {msg}"


# --- Output Cleanup ---
def clean_output(text: str) -> str:
    def is_garbled(line):
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


# --- Package Updater Logic ---
class PackageUpdater:
    BASE_MSG = f"{Fore.MAGENTA}>>> "

    @staticmethod
    def initialize_updater():
        PackageUpdater.display_initialization_message()
        PackageUpdater.display_system_summary()

        packages = PackageUpdater.get_lockfile_packages()

        if not (default_pkgs := PackageUpdater.get_default_pkg_manager_pkgs(packages)):
            msg = "No packages available for update using {default_pkg_manager}"
            print(get_formatted_status_msg(msg, FEEDBACK.INFO))
            return

        PackageUpdater.display_package_list(
            default_pkgs, "The following packages were detected:", False
        )
        # PackageUpdater.display_supported_packages(default_pkgs)

        if not (outdated := PackageUpdater.get_outdated_pkgs(default_pkgs)):
            msg = "All packages are up to date"
            print(get_formatted_status_msg(msg, FEEDBACK.SUCCESS))
            return

        PackageUpdater.display_package_list(
            outdated, f"{len(outdated)} outdated packages detected:", True
        )
        # PackageUpdater.display_outdated_packages(outdated)

        if PackageUpdater.ask_to_proceed_with_update():
            PackageUpdater.update_outdated_packages(outdated)

    @staticmethod
    def display_initialization_message():
        msg = f"{PackageUpdater.BASE_MSG}Initializing Package Updater sequence...{Style.RESET_ALL}\n"
        print(msg)

    def display_system_summary():
        def format_summary(label, value):
            return f"{Fore.RED}{label}:{Style.RESET_ALL} {value}"

        msg = "\n".join(
            [
                format_summary("OS", os_name),
                format_summary("Package manager", default_pkg_manager),
            ]
        )

        print(msg, end="\n\n")

    @staticmethod
    def get_lockfile_packages():
        with open(lockfile_path, "r", encoding="utf-8") as lockfile:
            loaded = yaml.safe_load(lockfile)
            return loaded.get("packages", {})

    @staticmethod
    def get_default_pkg_manager_pkgs(pkgs: dict) -> list:
        Package = namedtuple("Package", ["name", "id", "version", "latest_version"])
        supported = []

        for name, data in pkgs.items():
            pm_data = data.get(default_pkg_manager)
            if pm_data is None:
                continue

            pkg = Package(
                name=name,
                id=pm_data["id"],
                version=str(pm_data["version"]),
                latest_version=str(pm_data["version"]),
            )
            supported.append(pkg)

        return supported

    @staticmethod
    def fetch_latest_version(pkg_id: str) -> str | None:
        cmd = manager_data["read_latest"].format(id=pkg_id)
        result = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8")
        output = result.stderr if result.stderr else result.stdout
        return PackageUpdater.extract_version_number(output)

    @staticmethod
    def extract_version_number(text: str) -> str | None:
        match = re.search(r"Version:\s*(\d+(?:\.\d+)*)", text)
        return match.group(1) if match else None

    @staticmethod
    def get_outdated_pkgs(pkgs: list) -> list[namedtuple]:
        return [
            pkg._replace(latest_version=latest)
            for pkg in pkgs
            if (latest := PackageUpdater.fetch_latest_version(pkg.id))
            and pkg.version != str(latest)
        ]

    @staticmethod
    def display_packages(pkgs, add_latest_version):
        SURROUNDING_SPACES = 2

        def get_lbl(lbl, left_wrapper=" ", right_wrapper=" "):
            left = left_wrapper * SURROUNDING_SPACES
            right = right_wrapper * SURROUNDING_SPACES
            return f"{left}{lbl}{right}"

        max_name_len = max(len(pkg.name) for pkg in pkgs)
        max_id_len = max(len(pkg.id) for pkg in pkgs)

        # Estimate width of the "Version" column
        if add_latest_version:
            # Example: "v2.49.0 -> v2.50.1" (max ~17 chars)
            max_version_len = max(
                len(f"v{pkg.version} -> v{pkg.latest_version}") for pkg in pkgs
            )
        else:
            max_version_len = max(len(f"v{pkg.version}") for pkg in pkgs)

        name_lbl = get_lbl("Name".center(max_name_len))
        id_lbl = get_lbl("ID".center(max_id_len))
        version_lbl = get_lbl("Version".center(max_version_len))
        table_header = f"{Fore.RED}{name_lbl}|{id_lbl}|{version_lbl}"

        name_sep = get_lbl("-" * max_name_len, right_wrapper="-")
        id_sep = get_lbl("-" * max_id_len, left_wrapper="-", right_wrapper="-")
        version_sep = get_lbl("-" * max_version_len, left_wrapper="-")
        table_gap = f"{name_sep}|{id_sep}|{version_sep}{Style.RESET_ALL}"

        print(table_header)
        print(table_gap)

        for pkg in pkgs:
            name = pkg.name.ljust(max_name_len)
            pkg_id = pkg.id.center(max_id_len)
            version_str = f"v{pkg.version}"
            if add_latest_version:
                version_str += f" -> v{pkg.latest_version}"

            print(f"{get_lbl(name)}|{get_lbl(pkg_id)}|{get_lbl(version_str)}")

    @staticmethod
    def display_package_list(pkgs, title_msg: str, show_latest_version: bool):
        title = f"{Fore.CYAN}{title_msg}{Style.RESET_ALL}\n"
        formatted_title = get_formatted_status_msg(title, FEEDBACK.INFO)
        print(formatted_title)

        PackageUpdater.display_packages(pkgs, show_latest_version)
        print()

    @staticmethod
    def ask_to_proceed_with_update() -> bool:
        decision = input("Update packages? y/n: ")
        return decision.strip().lower() == "y"

    @staticmethod
    def update_outdated_packages(pkgs: list):
        for pkg in pkgs:
            PackageUpdater.update_package(pkg.name, pkg.id)

    @staticmethod
    def update_package(name: str, pkg_id: str):
        print(get_formatted_status_msg(f"Updating {name}...", FEEDBACK.INFO))

        cmd = manager_data["update"].format(id=pkg_id)
        result = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8")
        output = clean_output(result.stderr if result.stderr else result.stdout).strip()
        output_lower = output.lower()

        is_success_case = "installed" in output_lower

        if result.returncode == 0:
            feedback = FEEDBACK.SUCCESS
        elif is_success_case:
            feedback = FEEDBACK.INFO
        else:
            feedback = FEEDBACK.ERROR

        print(get_formatted_status_msg(output, feedback))

    @staticmethod
    def display_exit_message(feedback):
        if feedback.value == FEEDBACK.SUCCESS.value:
            exit_msg = "System setup sequence finished"
        else:
            exit_msg = "The user stopped execution"

        formatted_exit_msg = f"{PackageUpdater.BASE_MSG}{exit_msg}"
        print(formatted_exit_msg)


# --- Entrypoint ---
if __name__ == "__main__":
    try:
        PackageUpdater.initialize_updater()
        feedback = FEEDBACK.SUCCESS
    except KeyboardInterrupt:
        feedback = FEEDBACK.ERROR
    PackageUpdater.display_exit_message(feedback)
