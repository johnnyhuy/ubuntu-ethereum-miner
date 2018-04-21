#!/bin/bash

# Config
CLAYMORE_MINER_GZIP='claymore_11.6._quickfix'
CLAYMORE_DIR='~/claymore'
OVERCLOCK_START_SCRIPT='~/overclock.sh'
MINER_INSTALLER_DIR='~/miner-installer'
MINER_START_SCRIPT='~/miner.sh'
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

echo -e "${GREEN}\nThis installation script will do the following:"
echo -e "Install Ubuntu utility packages: git vim screen openssh-server"
echo -e "Disable nouveau: adds config at /etc/modprobe.d/blacklist-nouveau.conf"
echo -e "Install Nvidia drivers: installs package nvidia-390"
echo -e "Unlock Nvidia overclock settings: runs nvidia-xconfig"
echo -e "Create overclock script: added script at ~/overclock.sh"
echo -e "Create miner start script: added script at ~/miner.sh"
echo -e "Create cron job: starts miner and overclock at reboot\n${YELLOW}"
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

echo -e "${YELLOW}\nUpdating/Upgrading Ubuntu packages${RESET}"
add-apt-repository ppa:graphics-drivers/ppa -y
apt-get update
# apt-get upgrade -y

echo -e "${YELLOW}\nInstalling Ubuntu utilities (git, vim etc.)${RESET}"
apt-get install git vim screen openssh-server -y

echo -e "${YELLOW}\nDisabling nouveau${RESET}"
touch '/etc/modprobe.d/blacklist-nouveau.conf'
echo -e "blacklist nouveau\noptions nouveau modeset=0" > /etc/modprobe.d/blacklist-nouveau.conf

echo -e "${YELLOW}\nInstalling Nvidia drivers${RESET}"
apt-get install nvidia-390 -y

echo -e "${YELLOW}\nUnlocking Nvidia overclocking setting${RESET}"

bash "$MINER_INSTALLER_DIR/scripts/_nvidia_overclock.sh"

echo -e "${YELLOW}\nInstalling Claymore Miner to ${CLAYMORE_DIR}${RESET}"
mkdir "${MINER_INSTALLER_DIR}/claymore_extract"
tar xvzf "${MINER_INSTALLER_DIR}/${CLAYMORE_MINER_GZIP}.gz" -C claymore_extract --strip-components 1
mkdir $CLAYMORE_DIR
mv "${MINER_INSTALLER_DIR}/claymore_extract" $CLAYMORE_DIR

echo -e "${YELLOW}\nCopying template miner start script${RESET}"
echo -e "${BLUE}Change to appropriate miner settings after you run this script${RESET}"
touch $MINER_START_SCRIPT
echo -e "#!/bin/bash\n${CLAYMORE_DIR}/ethdcrminer64 -epool [POOL] -ewal [ETH WALLET ADDR].[WORKER NAME]/[EMAIL] -epsw x -mode 1 -ftime 10" >> ${MINER_START_SCRIPT}

echo -e "${YELLOW}\nCreating crontab to start miner at boot${RESET}"
crontab -l > ~/temp_cron
echo -e "@reboot nvidia-xconfig -a --cool-bits=28 --allow-empty-initial-configuration" >> ~/temp_cron
echo -e "@reboot sleep ${MINER_COOLDOWN} && screen -dmS claymore sh ${MINER_START_SCRIPT}" >> ~/temp_cron
echo -e "@reboot sleep ${OVERCLOCK_COOLDOWN} && sh ${OVERCLOCK_START_SCRIPT}" >> ~/temp_cron
crontab ~/temp_cron
rm ~/temp_cron

echo -e "${GREEN}\nInstallation complete, restarting in 5 seconds (manual reboot if required)${RESET}"

@sleep 5 reboot
