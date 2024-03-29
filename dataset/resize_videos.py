# Copyright 2020 Huawei Technologies Co., Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============================================================================

import argparse
import glob
import os
import os.path as osp
import sys
from multiprocessing import Pool


def resize_videos(vid_item):
    """Generate resized video cache.

    Args:
        vid_item (list): Video item containing video full path,
            video relative path.

    Returns:
        bool: Whether generate video cache successfully.
    """
    full_path, vid_path = vid_item
    out_full_path = osp.join(args.out_dir, vid_path)
    dir_name = osp.dirname(vid_path)
    out_dir = osp.join(args.out_dir, dir_name)
    if not osp.exists(out_dir):
        os.makedirs(out_dir)
    result = os.popen(
        f'ffprobe -hide_banner -loglevel error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 {full_path}'  # noqa:E501
    )
    w, h = [int(d) for d in result.readline().rstrip().split(',')]
    if w > h:
        cmd = (f'ffmpeg -hide_banner -loglevel error -i {full_path} '
               f'-vf {"mpdecimate," if args.remove_dup else ""}'
               f'scale=-2:{args.scale} '
               f'{"-vsync vfr" if args.remove_dup else ""} '
               f'-c:v libx264 {"-g 16" if args.dense else ""} '
               f'-an {out_full_path} -y')
    else:
        cmd = (f'ffmpeg -hide_banner -loglevel error -i {full_path} '
               f'-vf {"mpdecimate," if args.remove_dup else ""}'
               f'scale={args.scale}:-2 '
               f'{"-vsync vfr" if args.remove_dup else ""} '
               f'-c:v libx264 {"-g 16" if args.dense else ""} '
               f'-an {out_full_path} -y')
    os.popen(cmd)
    print(f'{vid_path} done')
    sys.stdout.flush()
    return True


def parse_args():
    parser = argparse.ArgumentParser(
        description='Generate the resized cache of original videos')
    parser.add_argument('src_dir', type=str, help='source video directory')
    parser.add_argument('out_dir', type=str, help='output video directory')
    parser.add_argument(
        '--dense',
        action='store_true',
        help='whether to generate a faster cache')
    parser.add_argument(
        '--level',
        type=int,
        choices=[1, 2],
        default=2,
        help='directory level of data')
    parser.add_argument(
        '--remove-dup',
        action='store_true',
        help='whether to remove duplicated frames')
    parser.add_argument(
        '--ext',
        type=str,
        default='mp4',
        choices=['avi', 'mp4', 'webm', 'mkv'],
        help='video file extensions')
    parser.add_argument(
        '--scale',
        type=int,
        default=256,
        help='resize image short side length keeping ratio')
    parser.add_argument(
        '--num-worker', type=int, default=8, help='number of workers')
    args = parser.parse_args()

    return args


if __name__ == '__main__':
    args = parse_args()

    if not osp.isdir(args.out_dir):
        print(f'Creating folder: {args.out_dir}')
        os.makedirs(args.out_dir)

    print('Reading videos from folder: ', args.src_dir)
    print('Extension of videos: ', args.ext)
    fullpath_list = glob.glob(args.src_dir + '/*' * args.level + '.' +
                              args.ext)
    done_fullpath_list = glob.glob(args.out_dir + '/*' * args.level + args.ext)
    print('Total number of videos found: ', len(fullpath_list))
    print('Total number of videos transfer finished: ',
          len(done_fullpath_list))
    if args.level == 2:
        vid_list = list(
            map(
                lambda p: osp.join(
                    osp.basename(osp.dirname(p)), osp.basename(p)),
                fullpath_list))
    elif args.level == 1:
        vid_list = list(map(osp.basename, fullpath_list))
    pool = Pool(args.num_worker)
    pool.map(resize_videos, zip(fullpath_list, vid_list))
