 #!/bin/bash

 # Reset
RESET='\033[0m'       # Text Reset

# Regular Colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

WELCOME_MESSAGE="${CYAN}Welcome to the johnnyhuy/ubuntu-etheruem-miner installer${RESET}"

if [[ $EUID > 0 ]]; then
    echo -e $WELCOME_MESSAGE
    echo -e "${RED}Permission denied, please run this script in root/sudo${RESET}"
    exit 1
fi

echo $WELCOME_MESSAGE
echo "${YELLOW}Running this script in root/sudo"

echo "\nUpdating/Upgrading Ubunutu packages"
apt-get update
apt-get upgrade -y

echo "\nInstalling Ubuntu utilities (git, vim etc.)"
apt-get install git vim -y
