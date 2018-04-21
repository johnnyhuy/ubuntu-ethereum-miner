#!/bin/bash

# Config
MINER_INSTALLER_DIR=$1
CLAYMORE_MINER_GZIP=$2
CLAYMORE_DIR=$3

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

mkdir -p "${MINER_INSTALLER_DIR}"
tar xvzf "${MINER_INSTALLER_DIR}/miner/${CLAYMORE_MINER_GZIP}.gz" -C claymore_extract --strip-components 1
mkdir -p $CLAYMORE_DIR
mv "${MINER_INSTALLER_DIR}/claymore_extract" $CLAYMORE_DIR
