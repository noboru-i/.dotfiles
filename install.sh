#!/bin/sh

[[ -e ~/.dotfiles ]] || git clone https://github.com/noboru-i/.dotfiles.git ~/.dotfiles
pushd ~/.dotfiles

git submodule init
git submodule update
for i in `ls -a`
do
  [ $i = "." ] && continue
  [ $i = ".." ] && continue
  [ $i = ".git" ] && continue
  [ $i = ".gitignore" ] && continue
  [ $i = ".gitmodules" ] && continue
  [ $i = "README.md" ] && continue
  ! [[ -e ~/$i ]] || mv ~/$i ~/$i.back.`date +%s`
  ln -s ~/.dotfiles/$i ~/
done
vim -c ':BundleInstall!' -c ':q!' -c ':q!'

popd
