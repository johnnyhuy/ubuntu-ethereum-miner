#!/bin/bash

# Colors
RESET='\033[0m'
RED='\033[0;31m'

# Config
USER_DIR=$1

if grep -Fxq "export DISPLAY=:0" $USER_DIR/.bashrc
then
    echo -e "${RED}Display env already copied.${RESET}"
else
    echo -e "\nexport DISPLAY=:0\nxhost + SI:localuser:root" >> $USER_DIR/.bashrc
fi
