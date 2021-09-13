#!/usr/bin/env bash

data_path="/data0/zhangguozhen/"

for para in $*
do
    if [[ $para == --data_path* ]]; then
        data_path=`echo ${para#*=}`
    fi
done

gpus=8
port=29111
currentDir=$(cd "$(dirname "$0")";pwd)

taskset -c 0-47 python -m torch.distributed.launch --nproc_per_node=$gpus --master_port=$port \
    ${currentDir}/../train.py  --validate --launcher pytorch \
    --gpu-ids 0 --data_root ${data_path} --work-dir ./result_8p > ${currentDir}/../tsm_8p.log 2>&1 &
