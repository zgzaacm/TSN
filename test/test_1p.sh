#!/usr/bin/env bash

data_path="/data0/zhangguozhen/"
ckpt="./result_1p/epoch_75.pth"
for para in $*
do
    if [[ $para == --data_path* ]]; then
        data_path=`echo ${para#*=}`
    elif [[ $para == --checkpoint* ]]; then
        ckpt=`echo ${para#*=}`
    fi
done

currentDir=$(cd "$(dirname "$0")";pwd)

python -u ${currentDir}/../test.py --data_root ${data_path} \
        --checkpoint ${ckpt} > ${currentDir}/../test_1p.log 2>&1 &
