#!/bin/bash

# Config
OVERCLOCK_START_SCRIPT=$1

touch $OVERCLOCK_START_SCRIPT
echo -e "#!/bin/bash

if [[ \$EUID > 0 ]]; then
    echo -e \"\\033[0;31mPermission denied, please run this script in root/sudo\\033[0m\"
    exit 1
fi

export DISPLAY=:0
export XAUTHORITY=/var/run/lightdm/root/:0

# Memory clock
# This setting is optional if you want to keep all your overclock settings the same
MEMORY_OFFSET=\"300\"

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
nvidia-settings -a [gpu:0]/GPUMemoryTransferRateOffset[2]=\$MEMORY_OFFSET" > $OVERCLOCK_START_SCRIPT
