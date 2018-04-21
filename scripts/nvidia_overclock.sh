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

echo -e "\nCopying overclock template to ~/overclock.sh"
touch ~/overclock.sh
~/overclock.sh << __EOF__
#!/bin/bash

export DISPLAY=0
export XAUTHORITY=/var/run/lightdm/root/:0

# Memory clock
# This setting is optional if you want to keep all your overclock settings the same
MEMORY_OFFSET="300"

# Enable persistent on device
# To add another GPU, append the ID with a common on the same line
# nvidia-smi -pm [XORG DEVICE # (e.g. 1,2,3)]
nvidia-smi -pm 1

# Power limit
# To add another GPU, append the ID with a common on the same line
# nvidia-smi -i [XORG DEVICE # (e.g. 1,2,3)] [POWER LIMIT (watt != percent)]
nvidia-smi -i 0 -pl 80

# Apply overclocking settings to each GPU
# To add another GPU, duplicate the two active lines and set the Xorg device ID accordingly
# nvidia-settings -a [gpu:[XORG DEVICE # (e.g. 1,2,3)]]/GpuPowerMizerMode=1
# nvidia-settings -a [gpu:[XORG DEVICE # (e.g. 1,2,3)]]/GPUMemoryTransferRateOffset[2]=$MEMORY_OFFSET
nvidia-settings -a [gpu:0]/GpuPowerMizerMode=1
nvidia-settings -a [gpu:0]/GPUMemoryTransferRateOffset[2]=$MEMORY_OFFSET

__EOF__

echo -e "${GREEN}\nOverclock transfer complete, please re-configure script at ~/overclock.sh to reflect your GPU configuration"
