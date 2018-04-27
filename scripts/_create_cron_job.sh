#!/bin/bash

# Config
MINER_COOLDOWN=$1
MINER_START_SCRIPT=$2
OVERCLOCK_COOLDOWN=$3
OVERCLOCK_START_SCRIPT=$4

crontab -l > ./temp_cron
echo -e "@reboot nvidia-xconfig -a --cool-bits=28 --allow-empty-initial-configuration
@reboot sleep ${MINER_COOLDOWN} && screen -dmS claymore sh ${MINER_START_SCRIPT}
@reboot sleep ${OVERCLOCK_COOLDOWN} && sh ${OVERCLOCK_START_SCRIPT}

0 */1 * * * reboot" > ./temp_cron
crontab ./temp_cron
rm ./temp_cron
