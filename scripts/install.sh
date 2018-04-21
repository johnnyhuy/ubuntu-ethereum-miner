#!/bin/bash

# Config
CLAYMORE_MINER_GZIP='claymore_11.6._quickfix'
CLAYMORE_DIR=~/claymore
OVERCLOCK_START_SCRIPT=~/overclock.sh
MINER_INSTALLER_DIR=~/miner-installer
MINER_START_SCRIPT=~/miner.sh
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
echo -e "${YELLOW}Running this script in root/sudo"

echo -e "${YELLOW}\nUpdating/Upgrading Ubuntu packages"
add-apt-repository ppa:graphics-drivers/ppa -y
apt-get update
# apt-get upgrade -y

echo -e "${YELLOW}\nInstalling Ubuntu utilities (git, vim etc.)"
apt-get install git vim screen openssh-server -y

echo -e "${YELLOW}\nDisabling nouveau"
touch '/etc/modprobe.d/blacklist-nouveau.conf'
echo -e "blacklist nouveau\noptions nouveau modeset=0" >> /etc/modprobe.d/blacklist-nouveau.conf

echo -e "${YELLOW}\nInstalling Nvidia drivers"
apt-get install nvidia-390

echo -e "${YELLOW}\nUnlocking Nvidia overclocking setting"
nvidia-xconfig -a --cool-bits=28 --allow-empty-initial-configuration

echo -e "\nCopying overclock template to ${OVERCLOCK_START_SCRIPT}"
touch $OVERCLOCK_START_SCRIPT

echo "#!/bin/bash" >> $OVERCLOCK_START_SCRIPT

echo -e "\nexport DISPLAY=0" >> $OVERCLOCK_START_SCRIPT
echo -e "export XAUTHORITY=/var/run/lightdm/root/:0" >> $OVERCLOCK_START_SCRIPT

echo -e "\n# Memory clock" >> $OVERCLOCK_START_SCRIPT
echo -e "# This setting is optional if you want to keep all your overclock settings the same" >> $OVERCLOCK_START_SCRIPT
echo -e "MEMORY_OFFSET=\"300\"" >> $OVERCLOCK_START_SCRIPT

echo -e "\n# Enable persistent on device" >> $OVERCLOCK_START_SCRIPT
echo -e "# To add another GPU, append the ID with a common on the same line" >> $OVERCLOCK_START_SCRIPT
echo -e "# nvidia-smi -pm [XORG DEVICE # (e.g. 1,2,3)]" >> $OVERCLOCK_START_SCRIPT
echo -e "nvidia-smi -pm 1" >> $OVERCLOCK_START_SCRIPT

echo -e "\n# Power limit" >> $OVERCLOCK_START_SCRIPT
echo -e "# To add another GPU, append the ID with a common on the same line" >> $OVERCLOCK_START_SCRIPT
echo -e "# nvidia-smi -i [XORG DEVICE # (e.g. 1,2,3)] [POWER LIMIT (watt != percent)]" >> $OVERCLOCK_START_SCRIPT
echo -e "nvidia-smi -i 0 -pl 80" >> $OVERCLOCK_START_SCRIPT

echo -e "\n# Apply overclocking settings to each GPU" >> $OVERCLOCK_START_SCRIPT
echo -e "# To add another GPU, duplicate the two active lines and set the Xorg device ID accordingly" >> $OVERCLOCK_START_SCRIPT
echo -e "# nvidia-settings -a [gpu:[XORG DEVICE # (e.g. 1,2,3)]]/GpuPowerMizerMode=1" >> $OVERCLOCK_START_SCRIPT
echo -e "# nvidia-settings -a [gpu:[XORG DEVICE # (e.g. 1,2,3)]]/GPUMemoryTransferRateOffset[2]=$MEMORY_OFFSET" >> $OVERCLOCK_START_SCRIPT
echo -e "nvidia-settings -a [gpu:0]/GpuPowerMizerMode=1" >> $OVERCLOCK_START_SCRIPT
echo -e "nvidia-settings -a [gpu:0]/GPUMemoryTransferRateOffset[2]=$MEMORY_OFFSET" >> $OVERCLOCK_START_SCRIPT

echo -e "${YELLOW}\nInstalling Claymore Miner to ${CLAYMORE_DIR}"
mkdir "${MINER_INSTALLER_DIR}/claymore_extract"
tar xvzf "${MINER_INSTALLER_DIR}/${CLAYMORE_MINER_GZIP}.gz" -C claymore_extract --strip-components 1
mkdir $CLAYMORE_DIR
mv "${MINER_INSTALLER_DIR}/claymore_extract" $CLAYMORE_DIR

echo -e "${YELLOW}\nCopying template miner start script"
echo -e "${WHITE}WARNING: Change to appropriate miner settings after you run this script${YELLOW}"
touch $MINER_START_SCRIPT
echo -e "#!/bin/bash\n${CLAYMORE_DIR}/ethdcrminer64 -epool [POOL] -ewal [ETH WALLET ADDR].[WORKER NAME]/[EMAIL] -epsw x -mode 1 -ftime 10" >> ${MINER_START_SCRIPT}

echo -e "${YELLOW}\nCreating crontab to start miner at boot"
crontab -l ~/temp_cron
echo -e "@reboot sleep ${MINER_COOLDOWN} && screen -dmS claymore sh ${MINER_START_SCRIPT}" >> ~/temp_cron
echo -e "@reboot sleep ${OVERCLOCK_COOLDOWN} && sh ${OVERCLOCK_START_SCRIPT}" >> ~/temp_cron
crontab ~/temp_cron
rm ~/temp_cron

echo -e "${GREEN}\nInstallation complete, restarting in 5 seconds (manual reboot if required)"

@sleep 5 reboot
