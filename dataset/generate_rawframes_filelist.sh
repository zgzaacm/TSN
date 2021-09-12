#!/usr/bin/env bash


PYTHONPATH=. python  ~/TSN/dataset/build_file_list.py ucf101 /data0/zhangguozhen/ucf101/rawframes/ --level 2 --format rawframes --shuffle
echo "Filelist for rawframes generated."

