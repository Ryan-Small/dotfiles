#!/usr/bin/env bash
#
# Idempotent; safe to re-run.
# To verify a setting:  defaults read <domain> <key>
#

set -euo pipefail

#----------------------------------------------------------------------
# Keyboard / Input
#----------------------------------------------------------------------
# Disable press-and-hold (true key repeat — required for Vim hjkl scrolling)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Fast key repeat (UI minimums; defaults can go lower)
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain KeyRepeat -int 2

# Disable autocorrect / smart quotes / smart dashes / capitalization (mangles code)
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

#----------------------------------------------------------------------
# Finder
#----------------------------------------------------------------------
defaults write com.apple.finder AppleShowAllFiles -bool true                  # show dotfiles
defaults write NSGlobalDomain AppleShowAllExtensions -bool true               # show file extensions
defaults write com.apple.finder ShowPathbar -bool true                        # path bar
defaults write com.apple.finder ShowStatusBar -bool true                      # status bar
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true            # full POSIX path in window title
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"           # search current folder by default
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false    # no warning when changing extension
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true  # no .DS_Store on network volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true      # no .DS_Store on USB

#----------------------------------------------------------------------
# Dock (auto-hide; stay out of the way — important for AeroSpace)
#----------------------------------------------------------------------
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0           # no hover delay
defaults write com.apple.dock autohide-time-modifier -float 0.2 # quicker animation
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock no-bouncing -bool true
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock tilesize -int 40

#----------------------------------------------------------------------
# Mission Control / Spaces (required for AeroSpace stability)
#----------------------------------------------------------------------
# Don't reorder Spaces by recent use — AeroSpace assumes stable workspace numbers
defaults write com.apple.dock mru-spaces -bool false

# Don't group windows by app in Mission Control
defaults write com.apple.dock expose-group-apps -bool false

# Faster Mission Control animation
defaults write com.apple.dock expose-animation-duration -float 0.15

#----------------------------------------------------------------------
# Trackpad
#----------------------------------------------------------------------
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true

#----------------------------------------------------------------------
# UI / animation speed
#----------------------------------------------------------------------
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true   # expand save panel
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true      # expand print panel
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001                 # near-instant window resize

#----------------------------------------------------------------------
# Apply changes
#----------------------------------------------------------------------
echo "Restarting Finder, Dock, SystemUIServer..."
killall Finder         2>/dev/null || true
killall Dock           2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

echo "macOS defaults applied. Some settings (e.g. keyboard repeat) take effect on next login."
