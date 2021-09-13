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

gpus=8
port=29111
currentDir=$(cd "$(dirname "$0")";pwd)

python -u ${currentDir}/../test.py --data_root ${data_path} > ${currentDir}/../test_1p.log 2>&1 &

taskset -c 0-47 python -m torch.distributed.launch --nproc_per_node=$gpus --master_port=$port \
    ${currentDir}/../test.py  --validate --launcher pytorch --checkpoint result/best_top1_acc_epoch_72.pth\
    --data_root ${data_path} --checkpoint ${ckpt} > ${currentDir}/../test_8p.log 2>&1 &
