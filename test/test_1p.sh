#!/usr/bin/env bash

data_path="/data0/zhangguozhen/"

for para in $*
do
    if [[ $para == --data_path* ]]; then
        data_path=`echo ${para#*=}`
    fi
done

currentDir=$(cd "$(dirname "$0")";pwd)

python -u ${currentDir}/../test.py --data_root ${data_path} > ${currentDir}/../test_1p.log 2>&1 &
