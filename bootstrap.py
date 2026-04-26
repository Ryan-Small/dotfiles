#!/usr/bin/env python3
"""Bootstrap a fresh macOS machine from this dotfiles repo.

Idempotent — safe to re-run. Prerequisites: Homebrew installed, repo cloned to
~/.dotfiles.
"""

import logging
import shutil
import subprocess
import sys
from pathlib import Path

logging.basicConfig(level=logging.INFO, format="%(message)s")
logger = logging.getLogger(__name__)


class Colors:
    GREEN = "\033[0;32m"
    YELLOW = "\033[1;33m"
    RED = "\033[0;31m"
    BLUE = "\033[0;34m"
    RESET = "\033[0m"


def step(msg: str) -> None:
    logger.info(f"\n{Colors.BLUE}==>{Colors.RESET} {msg}")


def ok(msg: str) -> None:
    logger.info(f"{Colors.GREEN}✓{Colors.RESET} {msg}")


def warn(msg: str) -> None:
    logger.info(f"{Colors.YELLOW}!{Colors.RESET} {msg}")


def fail(msg: str) -> None:
    logger.error(f"{Colors.RED}✗{Colors.RESET} {msg}")
    sys.exit(1)


def run(cmd: list[str]) -> None:
    subprocess.run(cmd, check=True)


def verify_homebrew() -> None:
    step("Verifying Homebrew")
    brew = shutil.which("brew")
    if not brew:
        fail("Homebrew not installed. See https://brew.sh")
    ok(f"brew at {brew}")


def install_brewfile(path: Path) -> None:
    step("Installing Brewfile packages")
    run(["brew", "bundle", f"--file={path}"])
    ok("Brewfile packages installed")


def install_brewfile_extras(path: Path) -> None:
    if not path.exists():
        return
    step("Brewfile.extras (extras for personal machines)")
    reply = input("Install Brewfile.extras? [y/N] ").strip().lower()
    if reply == "y":
        run(["brew", "bundle", f"--file={path}"])
        ok("Extras installed")
    else:
        warn("Skipped extras")


def stow_packages(dotfiles: Path) -> None:
    step("Stowing dotfile packages")
    run(["python3", str(dotfiles / "stow.py")])
    ok("Packages stowed")


def setup_node() -> None:
    step("Setting up Node via fnm")
    if not shutil.which("fnm"):
        fail("fnm missing — Brewfile install must have failed")
    # fnm env exports FNM_DIR / PATH adjustments that the install/default
    # commands need. Eval through bash so the env propagates to fnm's children.
    run([
        "bash", "-c",
        'eval "$(fnm env --use-on-cd --shell bash)" '
        '&& fnm install --lts '
        '&& fnm default lts-latest',
    ])
    ok("Node installed (lts-latest)")


def install_vscode_extensions(script: Path) -> None:
    step("VSCode extensions")
    if shutil.which("code"):
        run(["python3", str(script), "install"])
        ok("VSCode extensions installed")
    else:
        warn(
            "'code' CLI missing — open VSCode → ⌘⇧P → "
            "'Shell Command: Install code in PATH', then re-run this script"
        )


def apply_macos_defaults(script: Path) -> None:
    step("Applying macOS defaults")
    run([str(script)])
    ok("macOS defaults applied")


def print_manual_steps(dotfiles: Path) -> None:
    step("Manual steps remaining")
    logger.info(
        f"""\
The following are not automated — handle once per machine:

  iTerm color preset:
    iTerm → Preferences → Profiles → Colors → Color Presets → Import
    File: {dotfiles}/macos/ht.itermcolors

  Machine-specific overrides:
    ~/.gitconfig.local   — [user] block with name + email
    ~/.zshrc.local       — any per-machine shell config (gitignored)

  Restart your terminal for fnm changes to take effect.
"""
    )


def main() -> None:
    dotfiles = Path(__file__).parent.resolve()
    verify_homebrew()
    install_brewfile(dotfiles / "Brewfile")
    install_brewfile_extras(dotfiles / "Brewfile.extras")
    stow_packages(dotfiles)
    setup_node()
    install_vscode_extensions(dotfiles / "vscode" / "vscode-manage-extensions.py")
    apply_macos_defaults(dotfiles / "macos" / "defaults.sh")
    print_manual_steps(dotfiles)
    ok("Bootstrap complete")


if __name__ == "__main__":
    try:
        main()
    except subprocess.CalledProcessError as e:
        fail(f"command failed (exit {e.returncode}): {' '.join(map(str, e.cmd))}")
    except KeyboardInterrupt:
        fail("interrupted")
