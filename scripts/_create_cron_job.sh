#!/bin/bash

# Config
MINER_COOLDOWN=$1
MINER_START_SCRIPT=$2
OVERCLOCK_COOLDOWN=$3
OVERCLOCK_START_SCRIPT=$4

crontab -l > ./temp_cron
echo -e "@reboot sleep ${MINER_COOLDOWN} && screen -dmS claymore bash ${MINER_START_SCRIPT}
@reboot sleep ${OVERCLOCK_COOLDOWN} && bash ${OVERCLOCK_START_SCRIPT}

0 */1 * * * reboot" > ./temp_cron
crontab ./temp_cron
rm ./temp_cron
