#!/usr/bin/env python3
"""
VS Code Extension Manager

Manages VS Code extensions by updating the extensions list file or
installing extensions from the file.
"""

import argparse
import subprocess
import sys
from pathlib import Path
from typing import List, Set


class VSCodeExtensionManager:
    """Manages VS Code extensions via command line."""
    
    def __init__(self, extensions_file: Path = None):
        """Initialize the extension manager."""
        self.script_dir = Path(__file__).parent
        self.extensions_file = extensions_file or self.script_dir / "vscode-extensions.txt"
    
    def get_installed_extensions(self) -> Set[str]:
        """Get list of currently installed extensions."""
        try:
            result = subprocess.run(
                ["code", "--list-extensions"],
                capture_output=True,
                text=True,
                check=True
            )
            return set(result.stdout.strip().split('\n')) if result.stdout.strip() else set()
        except subprocess.CalledProcessError as e:
            print(f"Error getting installed extensions: {e}")
            return set()
        except FileNotFoundError:
            print("Error: VS Code CLI not found. Make sure 'code' command is in PATH.")
            return set()
    
    def get_extensions_from_file(self) -> Set[str]:
        """Get extensions from the extensions file."""
        if not self.extensions_file.exists():
            print(f"Extensions file not found: {self.extensions_file}")
            return set()
        
        try:
            with open(self.extensions_file, 'r') as f:
                extensions = set(line.strip() for line in f if line.strip())
            return extensions
        except Exception as e:
            print(f"Error reading extensions file: {e}")
            return set()
    
    def update_extensions_file(self) -> bool:
        """Update extensions file with currently installed extensions."""
        print("Updating extensions file...")
        
        installed = self.get_installed_extensions()
        if not installed:
            print("No extensions found or error occurred.")
            return False
        
        try:
            with open(self.extensions_file, 'w') as f:
                for extension in sorted(installed):
                    f.write(f"{extension}\n")
            
            print(f"Updated {self.extensions_file} with {len(installed)} extensions.")
            return True
        except Exception as e:
            print(f"Error writing extensions file: {e}")
            return False
    
    def install_extensions(self, dry_run: bool = False) -> bool:
        """Install extensions from the extensions file."""
        print("Installing extensions from file...")
        
        file_extensions = self.get_extensions_from_file()
        if not file_extensions:
            print("No extensions to install.")
            return False
        
        installed = self.get_installed_extensions()
        to_install = file_extensions - installed
        
        if not to_install:
            print("All extensions are already installed.")
            return True
        
        print(f"Installing {len(to_install)} extensions...")
        
        success_count = 0
        for extension in sorted(to_install):
            if dry_run:
                print(f"Would install: {extension}")
                success_count += 1
            else:
                try:
                    print(f"Installing {extension}...")
                    subprocess.run(
                        ["code", "--install-extension", extension],
                        check=True,
                        capture_output=True
                    )
                    success_count += 1
                    print(f"✓ Installed {extension}")
                except subprocess.CalledProcessError as e:
                    print(f"✗ Failed to install {extension}: {e}")
        
        print(f"Successfully installed {success_count}/{len(to_install)} extensions.")
        return success_count == len(to_install)
    
    def show_status(self) -> None:
        """Show current status of extensions."""
        print("VS Code Extension Status")
        print("=" * 30)
        
        installed = self.get_installed_extensions()
        file_extensions = self.get_extensions_from_file()
        
        print(f"Installed extensions: {len(installed)}")
        print(f"Extensions in file: {len(file_extensions)}")
        
        if file_extensions:
            only_installed = installed - file_extensions
            only_in_file = file_extensions - installed
            
            if only_installed:
                print(f"\nInstalled but not in file ({len(only_installed)}):")
                for ext in sorted(only_installed):
                    print(f"  + {ext}")
            
            if only_in_file:
                print(f"\nIn file but not installed ({len(only_in_file)}):")
                for ext in sorted(only_in_file):
                    print(f"  - {ext}")
            
            if not only_installed and not only_in_file:
                print("\n✓ File and installed extensions are in sync.")
        else:
            print(f"\nExtensions file doesn't exist or is empty.")


def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(
        description="Manage VS Code extensions",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s update          # Update vscode-extensions.txt with currently installed extensions
  %(prog)s install         # Install extensions from vscode-extensions.txt
  %(prog)s install --dry-run  # Show what would be installed without doing it
  %(prog)s status          # Show current status
        """
    )
    
    parser.add_argument(
        "action",
        choices=["update", "install", "status"],
        help="Action to perform"
    )
    
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be done without actually doing it (install only)"
    )
    
    parser.add_argument(
        "--file",
        type=Path,
        help="Path to extensions file (default: vscode-extensions.txt in script directory)"
    )
    
    args = parser.parse_args()
    
    manager = VSCodeExtensionManager(args.file)
    
    if args.action == "update":
        success = manager.update_extensions_file()
        sys.exit(0 if success else 1)
    
    elif args.action == "install":
        success = manager.install_extensions(dry_run=args.dry_run)
        sys.exit(0 if success else 1)
    
    elif args.action == "status":
        manager.show_status()
        sys.exit(0)


if __name__ == "__main__":
    main()