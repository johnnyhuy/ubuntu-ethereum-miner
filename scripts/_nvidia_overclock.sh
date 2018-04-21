#!/bin/bash

# Config
OVERCLOCK_START_SCRIPT=$1

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

rm -f $OVERCLOCK_START_SCRIPT
touch $OVERCLOCK_START_SCRIPT
echo -e"#!/bin/bash
\nexport DISPLAY=0
export XAUTHORITY=/var/run/lightdm/root/:0
\n# Memory clock
# This setting is optional if you want to keep all your overclock settings the same
MEMORY_OFFSET=\"300\"
\n# Enable persistent on device
# To add another GPU, append the ID with a common on the same line
# nvidia-smi -pm [XORG DEVICE # (e.g. 1,2,3)]
nvidia-smi -pm 1
\n# Power limit
# To add another GPU, append the ID with a common on the same line
# nvidia-smi -i [XORG DEVICE # (e.g. 1,2,3)] [POWER LIMIT (watt != percent)]
nvidia-smi -i 0 -pl 80
\n# Apply overclocking settings to each GPU
# To add another GPU, duplicate the two active lines and set the Xorg device ID accordingly
# nvidia-settings -a [gpu:[XORG DEVICE # (e.g. 1,2,3)]]/GpuPowerMizerMode=1
# nvidia-settings -a [gpu:[XORG DEVICE # (e.g. 1,2,3)]]/GPUMemoryTransferRateOffset[2]=$MEMORY_OFFSET
nvidia-settings -a [gpu:0]/GpuPowerMizerMode=1
nvidia-settings -a [gpu:0]/GPUMemoryTransferRateOffset[2]=\$MEMORY_OFFSET" > $OVERCLOCK_START_SCRIPT
