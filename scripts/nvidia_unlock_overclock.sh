#!/bin/bash

# Config
WELCOME_MESSAGE="${CYAN}Welcome to the Nvidia overclock unlocker${RESET}"

# Colors
RESET='\033[0m'
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'

if [[ $EUID > 0 ]]; then
    echo -e $WELCOME_MESSAGE
    echo -e "${RED}Permission denied, please run this script in root/sudo${RESET}"
    exit 1
fi

echo -e $WELCOME_MESSAGE
echo -e "${YELLOW}Running this script in root/sudo"

echo -e "\nUnlocking"
nvidia-xconfig -a --cool-bits=28 --allow-empty-initial-configuration

echo -e "${GREEN}\nUnlock complete, restarting in 5 seconds (manual reboot if required)"

@sleep 5 reboot
