#!/usr/bin/env python3
"""
Stow-based dotfiles manager.

This script uses GNU Stow to manage dotfile symlinks.
"""

import argparse
import logging
import subprocess
import sys
from pathlib import Path
from typing import List, Set

# Setup logging
logging.basicConfig(level=logging.INFO, format="%(message)s")
logger = logging.getLogger(__name__)


# ANSI color codes
class Colors:
    GREEN = "\033[0;32m"
    YELLOW = "\033[1;33m"
    RED = "\033[0;31m"
    BLUE = "\033[0;34m"
    RESET = "\033[0m"


class StowManager:
    """Manages dotfiles using GNU Stow."""

    # Define packages that should be stowed
    PACKAGES = [
        "zsh",
        "git",
        "jetbrains",
        "nvim",
        "tmux",
        "claude",
        "vscode",
        "aerospace",
    ]

    # Packages where the target application writes runtime state into the same
    # directory tree as curated config (caches, sessions, cookies, etc.).
    # These MUST use stow --no-folding so each curated file is symlinked
    # individually, and intermediate directories are real — that way the app's
    # runtime writes land in the real directory, not inside the dotfiles repo.
    NO_FOLD_PACKAGES = {"claude", "vscode"}

    def __init__(self, dotfiles_dir: Path, target_dir: Path = None):
        """
        Initialize the StowManager.

        Args:
            dotfiles_dir: Path to the dotfiles directory
            target_dir: Target directory (default: home directory)
        """
        self.dotfiles_dir = dotfiles_dir.resolve()
        self.target_dir = (target_dir or Path.home()).resolve()

    def check_stow_installed(self) -> bool:
        """Check if stow is installed."""
        try:
            subprocess.run(["stow", "--version"], capture_output=True, check=True)
            return True
        except (subprocess.CalledProcessError, FileNotFoundError):
            return False

    def get_available_packages(self) -> List[str]:
        """Get list of available packages (directories) in dotfiles."""
        packages = []
        for item in self.dotfiles_dir.iterdir():
            if item.is_dir() and not item.name.startswith("."):
                packages.append(item.name)
        return sorted(packages)

    def get_stowed_packages(self) -> Set[str]:
        """Get list of currently stowed packages."""
        stowed = set()
        for package in self.get_available_packages():
            package_dir = self.dotfiles_dir / package
            for file_path in package_dir.rglob("*"):
                if file_path.is_file():
                    relative = file_path.relative_to(package_dir)
                    target = self.target_dir / relative

                    # resolve(strict=True) follows the full symlink chain.
                    # This catches both direct file symlinks and stow's
                    # tree-folded form (where an ancestor directory is the
                    # symlink and individual files aren't).
                    try:
                        if target.resolve(strict=True) == file_path.resolve():
                            stowed.add(package)
                            break
                    except (OSError, RuntimeError):
                        continue
        return stowed

    def stow_package(
        self, package: str, restow: bool = False, adopt: bool = False
    ) -> bool:
        """
        Stow a package.

        Args:
            package: Package name to stow
            restow: Whether to restow (unlink then relink)
            adopt: Whether to adopt existing files into dotfiles

        Returns:
            True if successful, False otherwise
        """
        package_dir = self.dotfiles_dir / package
        if not package_dir.exists():
            logger.error(f"{Colors.RED}✗ Package '{package}' not found{Colors.RESET}")
            return False

        try:
            cmd = [
                "stow",
                "-v",
                "-d",
                str(self.dotfiles_dir),
                "-t",
                str(self.target_dir),
            ]

            if restow:
                cmd.append("-R")

            if adopt:
                cmd.append("--adopt")

            if package in self.NO_FOLD_PACKAGES:
                cmd.append("--no-folding")

            cmd.append(package)

            result = subprocess.run(cmd, capture_output=True, text=True)

            if result.returncode == 0:
                action = "Restowed" if restow else "Stowed"
                logger.info(f"{Colors.GREEN}✓ {action} {package}{Colors.RESET}")
                if result.stdout:
                    for line in result.stdout.strip().split("\n"):
                        logger.info(f"  {Colors.BLUE}{line}{Colors.RESET}")
                return True
            else:
                logger.error(f"{Colors.RED}✗ Failed to stow {package}{Colors.RESET}")
                if result.stderr:
                    logger.error(f"  {result.stderr.strip()}")
                return False

        except Exception as e:
            logger.error(f"{Colors.RED}✗ Error stowing {package}: {e}{Colors.RESET}")
            return False

    def unstow_package(self, package: str) -> bool:
        """
        Unstow a package.

        Args:
            package: Package name to unstow

        Returns:
            True if successful, False otherwise
        """
        try:
            cmd = [
                "stow",
                "-v",
                "-D",
                "-d",
                str(self.dotfiles_dir),
                "-t",
                str(self.target_dir),
                package,
            ]

            result = subprocess.run(cmd, capture_output=True, text=True)

            if result.returncode == 0:
                logger.info(f"{Colors.GREEN}✓ Unstowed {package}{Colors.RESET}")
                if result.stdout:
                    for line in result.stdout.strip().split("\n"):
                        logger.info(f"  {Colors.BLUE}{line}{Colors.RESET}")
                return True
            else:
                logger.error(f"{Colors.RED}✗ Failed to unstow {package}{Colors.RESET}")
                if result.stderr:
                    logger.error(f"  {result.stderr.strip()}")
                return False

        except Exception as e:
            logger.error(f"{Colors.RED}✗ Error unstowing {package}: {e}{Colors.RESET}")
            return False

    def list_packages(self):
        """List all packages and their status."""
        available = self.get_available_packages()
        stowed = self.get_stowed_packages()

        logger.info(f"\n{Colors.YELLOW}Available packages:{Colors.RESET}")
        for package in available:
            status = (
                f"{Colors.GREEN}[stowed]{Colors.RESET}" if package in stowed else ""
            )
            recommended = (
                f"{Colors.BLUE}[recommended]{Colors.RESET}"
                if package in self.PACKAGES
                else ""
            )
            logger.info(f"  {package} {status} {recommended}".strip())


def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(
        description="Manage dotfiles using GNU Stow",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s                    # Stow all recommended packages
  %(prog)s -l                 # List all packages
  %(prog)s zsh git           # Stow specific packages
  %(prog)s -r zsh            # Restow zsh package
  %(prog)s -u tmux           # Unstow tmux package
        """,
    )

    parser.add_argument(
        "packages",
        nargs="*",
        help="Specific packages to stow (default: recommended packages)",
    )

    parser.add_argument(
        "-l", "--list", action="store_true", help="List all available packages"
    )

    parser.add_argument(
        "-r",
        "--restow",
        action="store_true",
        help="Restow packages (unlink then relink)",
    )

    parser.add_argument("-u", "--unstow", action="store_true", help="Unstow packages")

    parser.add_argument(
        "-a", "--all", action="store_true", help="Apply to all available packages"
    )

    parser.add_argument(
        "--adopt",
        action="store_true",
        help="Adopt existing files into dotfiles (move them and create symlinks)",
    )

    parser.add_argument(
        "-d",
        "--dotfiles",
        type=Path,
        default=Path.home() / ".dotfiles",
        help="Path to dotfiles directory (default: ~/.dotfiles)",
    )

    args = parser.parse_args()

    # Initialize manager
    manager = StowManager(args.dotfiles)

    # Check if stow is installed
    if not manager.check_stow_installed():
        logger.error(f"{Colors.RED}Error: GNU Stow is not installed{Colors.RESET}")
        logger.info("Install it with: brew install stow")
        sys.exit(1)

    # Handle list command
    if args.list:
        manager.list_packages()
        sys.exit(0)

    # Determine which packages to process
    if args.packages:
        packages = args.packages
    elif args.all:
        packages = manager.get_available_packages()
    else:
        packages = manager.PACKAGES

    # Process packages
    logger.info(f"{Colors.YELLOW}Processing packages...{Colors.RESET}\n")

    failed = 0
    for package in packages:
        if args.unstow:
            if not manager.unstow_package(package):
                failed += 1
        else:
            if not manager.stow_package(package, restow=args.restow, adopt=args.adopt):
                failed += 1

    # Summary
    if failed > 0:
        logger.error(f"\n{Colors.RED}Completed with {failed} errors{Colors.RESET}")
        sys.exit(1)
    else:
        logger.info(f"\n{Colors.GREEN}All done!{Colors.RESET}")


if __name__ == "__main__":
    main()
