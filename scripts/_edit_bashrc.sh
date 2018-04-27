#!/bin/bash

# Config
USER_DIR=$1

if grep -Fxq "export DISPLAY=:0" $USER_DIR/.bashrc
then
    echo -e "\nexport DISPLAY=:0\nxhost + SI:localuser:root" >> $USER_DIR/.bashrc
fi
