#!/bin/sh

# Install applications by Homebrew
brew bundle

# setup dotfiles
chezmoi init https://github.com/noboru-i/.dotfiles.git
chezmoi apply

# Setup gh
gh alias set browse 'repo view -w'

## asdf
for plugin in $(cat .tool-versions | sed s/' .*$'//); do
  asdf plugin-list | grep $plugin > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    asdf plugin-add $plugin
  fi
done
asdf install
