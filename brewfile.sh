brew tap phinze/homebrew-cask || true
brew tap homebrew/versions|| true
brew tap homebrew/binary || true
brew tap peco/peco || true
brew update
brew upgrade

brew install brew-cask || true
brew install git || true
brew install tig || true
brew install tree || true
brew install zsh || true
brew install vim || true
brew install gradle || true
brew install wireshark --with-x || true
brew install pyenv-virtualenv || true
brew install go || true
brew install plenv || true
brew install perl-build || true
brew install jq || true

brew install peco || true

brew cask install skype || true
brew cask install skitch || true
brew cask install evernote || true

brew cask install alfred || true
brew cask install dash || true

brew cask install cyberduck || true
brew cask install imageoptim || true
brew cask install speedlimit || true
brew cask install google-japanese-ime || true

brew cask install google-chrome-beta || true
brew cask install google-chrome-canary || true
brew cask install firefox || true

brew cask install virtualbox || true
brew cask install vagrant || true

brew cask install atom || true
brew cask install iterm2 || true

brew cask install android-studio || true
brew cask install genymotion || true

brew tap caskroom/homebrew-versions
brew cask install sublime-text3 || true

brew tap josegonzalez/homebrew-php || true
brew install phplint

brew cleanup
brew cask cleanup

