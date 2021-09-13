#!/usr/bin/env bash

data_path="/data0/zhangguozhen/"
gpu_ids="0"

for para in $*
do
    if [[ $para == --data_path* ]]; then
        data_path=`echo ${para#*=}`
    elif [[ $para == --gpu_ids* ]]; then
        gpu_ids=`echo ${para#*=}`
    fi
done

currentDir=$(cd "$(dirname "$0")";pwd)

python -u ${currentDir}/../train.py --data_root ${data_path} --cfg-options evaluation.interval=2 \
optimizer.lr=0.00016 --validate --gpu-ids ${gpu_ids} --work-dir ./result_1p > ${currentDir}/../tsn_1p.log 2>&1 &
