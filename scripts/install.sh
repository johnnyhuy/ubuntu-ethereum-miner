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
CLAYMORE_MINER_GZIP='claymore_11.7'
MINER_COOLDOWN=15
OVERCLOCK_COOLDOWN=30
WELCOME_MESSAGE="${CYAN}Welcome to the johnnyhuy/ubuntu-etheruem-miner installer${RESET}"

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

# Directories
USER_DIR=/home/$USERNAME
CLAYMORE_DIR=$USER_DIR/claymore
OVERCLOCK_START_SCRIPT=$USER_DIR/overclock.sh
MINER_INSTALLER_DIR=$USER_DIR/miner-installer
MINER_START_SCRIPT=$USER_DIR/miner.sh

echo -e "${GREEN}\nThis installation script will do the following:
${CYAN}1) ${YELLOW}Install Ubuntu utility packages: ${RESET}git vim screen openssh-server
${CYAN}2) ${YELLOW}Install Nvidia drivers: ${RESET}installs package nvidia-390
${CYAN}3) ${YELLOW}Create Nvidia overclock script: ${RESET}adds script at ./overclock.sh
${CYAN}4) ${YELLOW}Extract Claymore's Miner from ./miner-installer/miner and install at ~/claymore
${CYAN}5) ${YELLOW}Disable nouveau: ${RESET}adds config at /etc/modprobe.d/blacklist-nouveau.conf
${CYAN}6) ${YELLOW}Create miner start script: ${RESET}adds script at ./miner.sh
${CYAN}7) ${YELLOW}Create cron job: ${RESET}starts miner and overclock at reboot
${CYAN}8) ${YELLOW}Edit .bashrc: ${RESET} set xorg display to root\n"
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

echo -e "${CYAN}\n(3/8)${YELLOW} Creating Nvidia overclock script${RESET}"
bash "${MINER_INSTALLER_DIR}/scripts/_nvidia_overclock.sh" $OVERCLOCK_START_SCRIPT

echo -e "${CYAN}\n(4/8)${YELLOW} Disabling nouveau${RESET}"
bash "${MINER_INSTALLER_DIR}/scripts/_disable_nouveau.sh"

echo -e "${CYAN}\n(5/8)${YELLOW} Installing Claymore Miner to ${CLAYMORE_DIR}${RESET}"
bash "${MINER_INSTALLER_DIR}/scripts/_create_miner.sh" $MINER_INSTALLER_DIR $CLAYMORE_MINER_GZIP $CLAYMORE_DIR

echo -e "${CYAN}\n(6/8)${YELLOW} Copying template miner start script${RESET}"
echo -e "${RED}Change to appropriate miner settings after you run this script${RESET}"
echo -e "${RESET}Let's make that easy for you, run this: vim ~/miner.sh"
bash "${MINER_INSTALLER_DIR}/scripts/_create_miner_start.sh" $MINER_START_SCRIPT $CLAYMORE_DIR

echo -e "${CYAN}\n(7/8)${YELLOW} Creating crontab to start miner at boot${RESET}"
bash "${MINER_INSTALLER_DIR}/scripts/_create_cron_job.sh" $MINER_COOLDOWN $MINER_START_SCRIPT $OVERCLOCK_COOLDOWN $OVERCLOCK_START_SCRIPT

echo -e "${CYAN}\n(8/8)${YELLOW} Editing .bashrc file${RESET}"
bash "${MINER_INSTALLER_DIR}/scripts/_edit_bashrc.sh" $USER_DIR

echo -e "${GREEN}\nInstallation complete, restarting in 5 seconds (manual reboot if required)${RESET}"
chown -R $USERNAME:$USERNAME $OVERCLOCK_START_SCRIPT
chmod +x $OVERCLOCK_START_SCRIPT
chown -R $USERNAME:$USERNAME $MINER_START_SCRIPT
chmod +x $USERNAME $MINER_START_SCRIPT

sleep 5
reboot
