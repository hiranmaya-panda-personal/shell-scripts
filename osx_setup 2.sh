#!/usr/bin/env bash
# 
# Bootstrap script for setting up a new OSX machine
# 
# This should be idempotent so it can be run multiple times.
#
# Some apps don't have a cask and so still need to be installed by hand. 
#
# Notes:
#
# - If installing full Xcode, it's better to install that first from the app
#   store before running the bootstrap script. Otherwise, Homebrew can't access
#   the Xcode libraries as the agreement hasn't been accepted yet.

echo "------------------------------------"
echo "Starting ...."
echo "++++++++++++++++++++++++++++++++++++"

# Install Xcode command line tool
sudo xcode-select --install
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Update homebrew recipes
brew update

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils


PACKAGES=(
    carthage
    git
    handbrake
    ios-deploy
    ios-webkit-debug-proxy
    imagemagick
    node
    npm
    openjdk
    python3
    pypy
    svn
    tree
    vim
    wget
)

echo "++++++++++++++++++++++++++++++++++++"
echo "Installing packages..."
echo "++++++++++++++++++++++++++++++++++++"
brew install ${PACKAGES[@]}

echo "++++++++++++++++++++++++++++++++++++"
echo "Cleaning up..."
echo "++++++++++++++++++++++++++++++++++++"
brew cleanup

echo "++++++++++++++++++++++++++++++++++++"
echo "Tapping Cask..."
echo "++++++++++++++++++++++++++++++++++++"
brew tap homebrew/cask

CASKS=(
    archiver
    android-file-transfer
    android-platform-tools
    android-studio
    caffeine
    charles
    firefox
    flux
    github
    google-chrome
    google-drive-file-stream
    iterm2
    java
    lastpass
    shortcuts
    skype
    slack
    sourcetree
    sublime-text
    wireshark
    visual-studio-code
    vlc
)

echo "++++++++++++++++++++++++++++++++++++"
echo "Installing cask apps..."
echo "++++++++++++++++++++++++++++++++++++"
brew cask install ${CASKS[@]}

echo "++++++++++++++++++++++++++++++++++++"
echo "Upgrading pip...."
echo "++++++++++++++++++++++++++++++++++++"
pip3 install --upgrade setuptools
pip3 install --upgrade pip

echo "++++++++++++++++++++++++++++++++++++"
echo "Installing fonts..."
echo "++++++++++++++++++++++++++++++++++++"
brew tap homebrew/cask-fonts
FONTS=(
    font-roboto
    font-clear-sans
)
brew cask install ${FONTS[@]}


echo "++++++++++++++++++++++++++++++++++++"
echo "Installing Python packages..."
echo "++++++++++++++++++++++++++++++++++++"
PYTHON_PACKAGES=(
    ipython
    virtualenv
    virtualenvwrapper
)
sudo pip3 install ${PYTHON_PACKAGES[@]}

echo "++++++++++++++++++++++++++++++++++++"
echo "Installing Ruby gems"
echo "++++++++++++++++++++++++++++++++++++"
RUBY_GEMS=(
    bundler
    filewatcher
    cocoapods
)
sudo gem install ${RUBY_GEMS[@]}

echo "++++++++++++++++++++++++++++++++++++"
echo "Installing global npm packages..."
echo "++++++++++++++++++++++++++++++++++++"
npm install marked -g

echo "++++++++++++++++++++++++++++++++++++"
echo "Configuring Katalon Studio's pre-requisites..."
echo "++++++++++++++++++++++++++++++++++++"
npm install -g appium

brew install --HEAD usbmuxd
brew unlink usbmuxd
brew link usbmuxd

brew install --HEAD libimobiledevice
brew unlink libimobiledevice
brew link libimobiledevice

brew cask install katalon-studio

echo "++++++++++++++++++++++++++++++++++++"
echo "Configuring OSX..."
echo "++++++++++++++++++++++++++++++++++++"

# Set fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0

# Require password as soon as screensaver or sleep mode starts
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Disable "natural" scroll
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

echo "++++++++++++++++++++++++++++++++++++"
echo "... Completed"
echo "------------------------------------"
