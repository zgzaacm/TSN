#!/usr/bin/env bash

git clone -b v1.3.9 https://github.com/open-mmlab/mmcv.git
mv mmcv/ mmcv-master/
mv mmcv-master/mmcv ./
rm -rf mmcv-master/

/bin/cp -f mmcv_need/base_runner.py mmcv/runner/base_runner.py
/bin/cp -f mmcv_need/builder.py mmcv/runner/optimizer/builder.py
/bin/cp -f mmcv_need/checkpoint.py mmcv/runner/hooks/checkpoint.py
/bin/cp -f mmcv_need/data_parallel.py mmcv/parallel/data_parallel.py
/bin/cp -f mmcv_need/dist_utils.py mmcv/runner/dist_utils.py
/bin/cp -f mmcv_need/distributed.py mmcv/parallel/distributed.py
/bin/cp -f mmcv_need/epoch_based_runner.py mmcv/runner/epoch_based_runner.py
/bin/cp -f mmcv_need/iter_timer.py mmcv/runner/hooks/iter_timer.py
/bin/cp -f mmcv_need/optimizer.py mmcv/runner/hooks/optimizer.py
/bin/cp -f mmcv_need/test.py mmcv/engine/test.py
/bin/cp -f mmcv_need/transformer.py mmcv/cnn/bricks/transformer.py