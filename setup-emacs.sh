#! /bin/bash

if ! hash emacs 2> /dev/null
then
    sudo apt update
    sudo apt install emacs
    mkdir -p $HOME/.emacs.d/
else
    echo "emacs installed"
fi

ln -sf $(pwd)/init.el $HOME/.emacs.d/init.el 
