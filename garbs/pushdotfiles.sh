#!/bin/bash

git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" commit -a
git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" push

if [ -d "$HOME/.config/surf" ];then
    git  --git-dir="$HOME/.config/surf/.git" --work-tree="$HOME/.config/surf" add -A
    git --git-dir="$HOME/.config/surf/.git" --work-tree="$HOME/.config/surf" commit -a
    git  --git-dir="$HOME/.config/surf/.git" --work-tree="$HOME/.config/surf" push
fi

if [ -d "$HOME/.config/dwm" ];then
    git  --git-dir="$HOME/.config/dwm/.git" --work-tree="$HOME/.config/dwm" add -A
    git  --git-dir="$HOME/.config/dwm/.git" --work-tree="$HOME/.config/dwm" commit -a
    git  --git-dir="$HOME/.config/dwm/.git" --work-tree="$HOME/.config/dwm" push
fi

if [ -d "$HOME/.config/st" ];then
    git  --git-dir="$HOME/.config/st/.git" --work-tree="$HOME/.config/st" add -A
    git  --git-dir="$HOME/.config/st/.git" --work-tree="$HOME/.config/st" commit -a
    git  --git-dir="$HOME/.config/st/.git" --work-tree="$HOME/.config/st" push
fi

if [ -d "$HOME/.config/dmenu" ];then
    git  --git-dir="$HOME/.config/dmenu/.git" --work-tree="$HOME/.config/dmenu" add -A
    git  --git-dir="$HOME/.config/dmenu/.git" --work-tree="$HOME/.config/dmenu" commit -a
    git  --git-dir="$HOME/.config/dmenu/.git" --work-tree="$HOME/.config/dmenu" push
fi

if [ -d "$HOME/.scrips" ];then
    git  --git-dir="$HOME/.scrips/.git" --work-tree="$HOME/.scrips" add -A
    git  --git-dir="$HOME/.scrips/.git" --work-tree="$HOME/.scrips" commit -a
    git  --git-dir="$HOME/.scrips/.git" --work-tree="$HOME/.scrips" push
fi
if [ -d "$HOME/.password-store/" ];then
    pass git push
fi
