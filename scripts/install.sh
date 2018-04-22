#!/bin/bash

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

# Config
CLAYMORE_MINER_GZIP='claymore_11.6_quickfix'
CLAYMORE_DIR=./claymore
OVERCLOCK_START_SCRIPT=./overclock.sh
MINER_INSTALLER_DIR=./miner-installer
MINER_START_SCRIPT=./miner.sh
MINER_COOLDOWN=15
OVERCLOCK_COOLDOWN=30
WELCOME_MESSAGE="${CYAN}Welcome to the johnnyhuy/ubuntu-etheruem-miner installer${RESET}"

if [[ $EUID > 0 ]]; then
    echo -e $WELCOME_MESSAGE
    echo -e "${RED}Permission denied, please run this script in root/sudo${RESET}"
    exit 1
fi

echo -e $WELCOME_MESSAGE
echo -e "${YELLOW}Running this script in root/sudo${RESET}"

echo -e "${GREEN}\nThis installation script will do the following:
1. Install Ubuntu utility packages: git vim screen openssh-server
2. Install Nvidia drivers: installs package nvidia-390
3. Unlock Nvidia overclock settings: runs nvidia-xconfig
4. Extract Claymore's Miner from ./miner-installer/miner and install at ~/claymore
5. Disable nouveau: adds config at /etc/modprobe.d/blacklist-nouveau.conf
6. Create overclock script: added script at ./overclock.sh
7. Create miner start script: added script at ./miner.sh
8. Create cron job: starts miner and overclock at reboot\n${RESET}"
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
echo -e "${YELLOW}Updating/Upgrading Ubuntu packages${RESET}"
add-apt-repository ppa:graphics-drivers/ppa -y
apt-get update
# apt-get upgrade -y

echo -e "${CYAN}\n(1/8)${YELLOW} Installing Ubuntu utilities (git, vim etc.)${RESET}"
apt-get install git vim screen openssh-server -y

echo -e "${CYAN}\n(2/8)${YELLOW} Installing Nvidia drivers${RESET}"
apt-get install nvidia-390 -y

echo -e "${CYAN}\n(3/8)${YELLOW} Unlocking Nvidia overclock setting${RESET}"
nvidia-xconfig -a --cool-bits=28 --allow-empty-initial-configuration

echo -e "${CYAN}\n(4/8)${YELLOW} Disabling nouveau${RESET}"
bash "${MINER_INSTALLER_DIR}/scripts/_disable_nouveau.sh"

echo -e "${CYAN}\n(5/8)${YELLOW} Copying overclock template to ${OVERCLOCK_START_SCRIPT}${RESET}"
bash "${MINER_INSTALLER_DIR}/scripts/_nvidia_overclock.sh" $OVERCLOCK_START_SCRIPT

echo -e "${CYAN}\n(6/8)${YELLOW} Installing Claymore Miner to ${CLAYMORE_DIR}${RESET}"
bash "${MINER_INSTALLER_DIR}/scripts/_create_miner.sh" $MINER_INSTALLER_DIR $CLAYMORE_MINER_GZIP $CLAYMORE_DIR

echo -e "${CYAN}\n(7/8)${YELLOW} Copying template miner start script${RESET}"
echo -e "${RED}Change to appropriate miner settings after you run this script${RESET}"
echo -e "${RESET}Let's make that easy for you, run this: vim ~/miner.sh"
touch $MINER_START_SCRIPT
echo -e "#!/bin/bash\n${CLAYMORE_DIR}/ethdcrminer64 -epool [POOL] -ewal [ETH WALLET ADDR].[WORKER NAME]/[EMAIL] -epsw x -mode 1 -ftime 10" >> ${MINER_START_SCRIPT}

echo -e "${CYAN}\n(8/8)${YELLOW} Creating crontab to start miner at boot${RESET}"
bash "${MINER_INSTALLER_DIR}/scripts/_create_cron_job.sh" $MINER_COOLDOWN $MINER_START_SCRIPT $OVERCLOCK_COOLDOWN $OVERCLOCK_START_SCRIPT

echo -e "${GREEN}\nInstallation complete, restarting in 5 seconds (manual reboot if required)${RESET}"

@sleep 5 reboot
