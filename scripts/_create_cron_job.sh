#!/bin/bash

# Config
MINER_COOLDOWN=$1
MINER_START_SCRIPT=$2
OVERCLOCK_COOLDOWN=$3
OVERCLOCK_START_SCRIPT=$4

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

crontab -l > ./temp_cron
echo -e "@reboot nvidia-xconfig -a --cool-bits=28 --allow-empty-initial-configuration
@reboot sleep ${MINER_COOLDOWN} && screen -dmS claymore sh ${MINER_START_SCRIPT}
@reboot sleep ${OVERCLOCK_COOLDOWN} && sh ${OVERCLOCK_START_SCRIPT}" > ./temp_cron
crontab ./temp_cron
rm ./temp_cron
