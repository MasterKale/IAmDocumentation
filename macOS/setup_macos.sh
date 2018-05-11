#!/bin/bash
echo [Setting up OSX]
# Install Homebrew first since a bunch of stuff below needs it
echo Installing Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo ✅ Done
###
#
# OS Settings
#
###
# Switch to Dark mode for menu bar and dock
echo Setting menubar and dock to dark mode
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
echo ✅ Done
# Change where screenhots are saved
echo Setting up screenshots to save to ~/Screenshots
mkdir ~/Screenshots
defaults write com.apple.screencapture location ~/Screenshots
echo ✅ Done
# Remove shadows from full-screen screenshots
echo Disabling shadows on full-screen screenshots
defaults write com.apple.screencapture disable-shadow -bool true
echo ✅ Done
# Show Status Bar in Finder
echo Showing status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true
echo ✅ Done
# Always show dotfiles
echo Setting dotfiles to always appear in Finder
defaults write com.apple.finder AppleShowAllFiles YES
echo ✅ Done
# Show file extensions
echo Showing file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
echo ✅ Done
# Restart finder to reload settings
echo Restarting Finder
killall Finder
echo ✅ Done
# Enhance Finder's spacebar-preview functionality
echo Adding additional filetype support to Finder\'s preview
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv qlimagesize webpquicklook suspicious-package qlvideo
echo ✅Done
# Set up Mission Control hotcorner (top-left)
echo Setting up top-left hot corner to activate Mission Control
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0
killall Dock
echo ✅ Done
# Set Terminal's default color scheme to the darker Homebrew
echo Setting Terminal to default to Homebrew
defaults write com.apple.Terminal "Default Window Settings" -string Homebrew
defaults write com.apple.Terminal "Startup Window Settings" -string Homebrew
echo ✅ Done
# Create a Repos folder
echo Creating ~/Repos folder
mkdir ~/Repos
echo ✅ Done
###
#
# Applications
#
###
# Install Python 3
echo Installing Python 3
brew install python
echo ✅ Done
# Install rbenv
echo Installing rbenv + ruby-build
brew install rbenv
echo ✅ Done
# Install NVM
echo Installing nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
echo ✅ Done
# Install Fish Shell
echo Installing Fish Shell
brew install fish
# https://fishshell.com/docs/current/faq.html#faq-default
echo - Adding Fish to /etc/shells
echo /usr/local/bin/fish | sudo tee -a /etc/shells
echo - Changing default system shell to fish
chsh -s /usr/local/bin/fish
echo ✅ Done
# Install Oh My Fish plugin manager for Fish
echo Installing Oh My Fish
curl -L https://get.oh-my.fish | fish
echo ✅ Done
# Install NVM support in Fish
echo Setting up NVM for Fish
omf install nvm
echo ✅ Done
# Install KDIFF3
echo Installing KDiff3
brew cask install kdiff3
echo ✅ Done
###
#
# Config Files
#
###
# Write Fish config file
echo Writing Fish Shell config file
echo $'status --is-interactive; and source (rbenv init -|psub)

# Disable the "(venv)" that gets prepended to the prompt when activating a
# Python virtual environment
set -x VIRTUAL_ENV_DISABLE_PROMPT 1

# Android SDK
# set -x ANDROID_HOME "/Users/mmiller/android-sdk"

# Command Aliases
alias ping="ping -c 4"
alias flushdns="sudo killall -HUP mDNSResponder"
alias findtext="grep -rnw ./ -e"
alias dc="docker-compose"
' > ~/.config/fish/config.fish
echo ✅ Done
# Write some downloads to ~/Desktop/Downloads.txt
echo Writing a list of additional manual steps to ~/Desktop/NextSteps.txt
echo $'Configuration:
[ ] Finder (Finder > Preferences)
  [ ] Under General, set "New Finder windows show" to "mmiller" (~/)
  [ ] Under Sidebar > Favorites, only CHECK the following:
    [ ] iCloud Drive
    [ ] Applications
    [ ] Desktop
    [ ] Documents
    [ ] Downloads
    [ ] mmiller (~/)
  [ ] Under Advanced, check "Keep folder on top when sorting by name"
[ ] Dock
  [ ] Set Download folder to sort by "Date Added"
  [ ] Set Download folder to display as "Folder"
  [ ] Set Download folder to view content as "Grid"
[ ] Terminal (After installing Bobthefish theme below)
  [ ] Set Homebrew theme\'s font to "Roboto Mono Light for Powerline" (12pt)
  [ ] Check "Use bright colors for bold text"
[ ] Keyboard (Preferences > Keyboard > Input Sources)
  [ ] Set up Japanese IME
    [ ] Uncheck all Input Modes except for default Hiragana
[ ] Mission Control (Preferences > Keyboard > Mission Control)
  [ ] Uncheck "Automatically rearrange Spaces based on most recent use"
  [ ] Check "Group windows by application"
  [ ] Set "Dashboard" to Off
[ ] Internet Accounts (Preferences > Internet Accounts)
  [ ] Activate "Contacts" and "Calendars" for any inactive Google accounts
[ ] Users & Groups (Preferences > Users & Groups)
  [ ] Under "Login Options", uncheck "Show fast user switching menu as..."

Mac App Store:
- Airmail
- Pixelmator Pro
- GIF Brewery
- Termius
- Xcode

Downloads:
- Firefox: https://www.mozilla.org/en-US/firefox/new/
- Fish Shell Bobthefish Theme: https://github.com/oh-my-fish/theme-bobthefish
  - Roboto Mono Light for Powerline font: https://github.com/powerline/fonts/tree/master/RobotoMono
- VS Code: https://code.visualstudio.com/docs/\?dv=osx
  - Install Settings Sync to grab settings from your "cloudSettings" gist
- iStat Menus: https://bjango.com/mac/istatmenus/
  - Preferences > Date & Time > Clock > Uncheck "Show date and time in menu bar"
- BetterTouchTool: https://folivora.ai/downloads
  - Basic Settings
    - Check "Launch BetterTouchTool on startup"
    - Check "Enable window snapping"
- Rambox: http://rambox.pro/\#download
- Clementine: https://www.clementine-player.org/downloads
  - Preferences > User interface > Configure Shortcuts
    - Set Next Track to Ctrl+Alt+X
    - Set Play to Ctrl+Alt+A
    - Set Play/Pause to Ctrl+Alt+S
    - Set Previous Track to Ctrl+Alt+Z
    - Set Stop to Ctrl+Alt+D
- Docker: https://store.docker.com/editions/community/docker-ce-desktop-mac

Arrangement:

- The DOCK\'s pinned applications are typically arranged as such (left-to-right):
  - Finder, Firefox, Chrome, VS Code, <git client>, <chat clients>, Airmail, Clementine
- The FINDER\'s sidebar Favorites section is typically arranged as such (top-to-bottom):
  - iCloud Drive, Desktop, mmiller (~/), Applications, Repos, Screenshots, Downloads, Documents
- The MENU BAR\'s bits are typically arranged as such (left-to-right):
  - BetterTouchTool, 1Password, IME, Volume, Wifi, VPN, Bluetooth, iStat Menu Weather, iStat Menu CPU, MacOS Battery, iStat Menu Clock
'> ~/Desktop/NextSteps.txt
echo ✅ Done

echo SETUP COMPLETE\! PLEASE REBOOT YOUR MACHINE BEFORE GETTING BACK TO WORK\!
