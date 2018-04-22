#!/bin/bash

MINER_START_SCRIPT=$1
CLAYMORE_DIR=$2

touch $MINER_START_SCRIPT
echo -e "#!/bin/bash\n
export GPU_FORCE_64BIT_PTR 0
export GPU_MAX_HEAP_SIZE 100
export GPU_USE_SYNC_OBJECTS 1
export GPU_MAX_ALLOC_PERCENT 100
export GPU_SINGLE_ALLOC_PERCENT 100
${CLAYMORE_DIR}/ethdcrminer64 -epool [POOL] -ewal [ETH WALLET ADDR].[WORKER NAME]/[EMAIL] -epsw x -mode 1 -ftime 10" > ${MINER_START_SCRIPT}