#!/bin/bash

# Config
WELCOME_MESSAGE="${CYAN}Welcome to the reset script${RESET}"

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
echo -e "${YELLOW}Running this script in root/sudo\n${RESET}"

read -e -p "Enter your username: " USERNAME
while :
do
    read -e -n 1 -r -p "Confirm username is: ${USERNAME} [y/N] " INPUT
    case $INPUT in
        [yY])
        break
        ;;
        [nN]|"")
        echo -e "${RED}Installation aborted!${RESET}"
        exit 1
        ;;
        *)
        echo -e "${RED}Please choose y or n.${RESET}"
        ;;
    esac
done

echo -e "${GREEN}\nThis reset script will remove the following:
/etc/modprobe.d/blacklist-nouveau.conf
~/claymore/
~/miner.sh
~/overclock.sh\n${RESET}"
while :
do
    read -e -n 1 -r -p "Confirm [y/N] " INPUT
    case $INPUT in
        [yY])
        break
        ;;
        [nN]|"")
        echo -e "${RED}Installation aborted!${RESET}"
        exit 1
        ;;
        *)
        echo -e "${RED}Please choose y or n.${RESET}"
        ;;
    esac
done

rm -rdf /etc/modprobe.d/blacklist-nouveau.conf /home/$USERNAME/ethminer/ /home/$USERNAME/miner.sh /home/$USERNAME/overclock.sh
