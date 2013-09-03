#!/usr/bin/env bash

# Time-stamp: <2013-08-12 22:45:55 Monday by oa>

# @version 1.0
# @author dorayo

BASEDIR=$HOME/emacs.dorayo

if [ -f $HOME/.emacs ]; then
    mv $HOME/.emacs $HOME/.emacs.bak4dorayo
fi

if [[ $# = 1 && $1 = "simple" ]]; then
    ln -s $BASEDIR/.emacs_simple $HOME/.emacs
else
    ln -s $BASEDIR/.emacs_default $HOME/.emacs
fi

echo 'Finish.'
