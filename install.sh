#!/bin/sh

[[ -e ~/.dotfiles ]] || git clone https://github.com/noboru-i/.dotfiles.git ~/.dotfiles
pushd ~/.dotfiles

for i in `ls -a`
do
  [ $i = "." ] && continue
  [ $i = ".." ] && continue
  [ $i = ".git" ] && continue
  [ $i = ".gitignore" ] && continue
  [ $i = "docs" ] && continue
  [ $i = "README.md" ] && continue
  ! [[ -e ~/$i ]] || mv ~/$i ~/$i.back.`date +%s`
  ln -s ~/.dotfiles/$i ~/
done

## applications
brew bundle

## asdf
for plugin in $(cat .tool-versions | sed s/' .*$'//); do
  asdf plugin-list | grep $plugin > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    asdf plugin-add $plugin
  fi
done
asdf install

## Flutter
flutter doctor

popd
