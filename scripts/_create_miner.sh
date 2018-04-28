#!/bin/bash

# Config
MINER_INSTALLER_DIR=$1
MINER_GZIP=$2
MINER_DIR=$3

mkdir -p $MINER_DIR
tar xvzf "${MINER_INSTALLER_DIR}/miner/${MINER_GZIP}.gz" -C $MINER_DIR --strip-components 1
