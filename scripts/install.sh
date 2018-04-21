#!/bin/bash

# Config
CLAYMORE_MINER_GZIP='claymore_11.6_quickfix'
CLAYMORE_DIR=./claymore
OVERCLOCK_START_SCRIPT=./overclock.sh
MINER_INSTALLER_DIR=./miner-installer
MINER_START_SCRIPT=./miner.sh
MINER_COOLDOWN=15
MINER_COOLDOWN=30
WELCOME_MESSAGE="${CYAN}Welcome to the johnnyhuy/ubuntu-etheruem-miner installer${RESET}"

# Colors
RESET='\033[0m'
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

if [[ $EUID > 0 ]]; then
    echo -e $WELCOME_MESSAGE
    echo -e "${RED}Permission denied, please run this script in root/sudo${RESET}"
    exit 1
fi

echo -e $WELCOME_MESSAGE
echo -e "${YELLOW}Running this script in root/sudo${RESET}"

echo -e "${GREEN}\nThis installation script will do the following:
Install Ubuntu utility packages: git vim screen openssh-server
Disable nouveau: adds config at /etc/modprobe.d/blacklist-nouveau.conf
Install Nvidia drivers: installs package nvidia-390
Unlock Nvidia overclock settings: runs nvidia-xconfig
Create overclock script: added script at ./overclock.sh
Create miner start script: added script at ./miner.sh
Create cron job: starts miner and overclock at reboot\n${RESET}"
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
echo -e "${YELLOW}\nUpdating/Upgrading Ubuntu packages${RESET}"
add-apt-repository ppa:graphics-drivers/ppa -y
apt-get update
# apt-get upgrade -y

echo -e "${YELLOW}\nInstalling Ubuntu utilities (git, vim etc.)${RESET}"
apt-get install git vim screen openssh-server -y

echo -e "${YELLOW}\nInstalling Nvidia drivers${RESET}"
apt-get install nvidia-390 -y

echo -e "${YELLOW}\nDisabling nouveau${RESET}"
bash "${MINER_INSTALLER_DIR}/scripts/_disable_nouveau.sh"

echo -e "${YELLOW}\nCopying overclock template to ${OVERCLOCK_START_SCRIPT}${RESET}"
bash "${MINER_INSTALLER_DIR}/scripts/_create_cron_job.sh" $MINER_COOLDOWN $MINER_START_SCRIPT $OVERCLOCK_COOLDOWN $OVERCLOCK_START_SCRIPT

echo -e "${YELLOW}\nInstalling Claymore Miner to ${CLAYMORE_DIR}${RESET}"
bash "${MINER_INSTALLER_DIR}/scripts/_create_miner.sh" $MINER_INSTALLER_DIR $CLAYMORE_MINER_GZIP $CLAYMORE_DIR

echo -e "${YELLOW}\nCopying template miner start script${RESET}"
echo -e "${BLUE}Change to appropriate miner settings after you run this script${RESET}"
touch $MINER_START_SCRIPT
echo -e "#!/bin/bash\n${CLAYMORE_DIR}/ethdcrminer64 -epool [POOL] -ewal [ETH WALLET ADDR].[WORKER NAME]/[EMAIL] -epsw x -mode 1 -ftime 10" >> ${MINER_START_SCRIPT}

echo -e "${YELLOW}\nCreating crontab to start miner at boot${RESET}"
bash "${MINER_INSTALLER_DIR}/scripts/_create_cron_job.sh"

echo -e "${GREEN}\nInstallation complete, restarting in 5 seconds (manual reboot if required)${RESET}"

@sleep 5 reboot
