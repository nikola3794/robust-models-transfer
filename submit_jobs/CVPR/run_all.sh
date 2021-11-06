#!/bin/bash

# Set project paths
PROJECT_ROOT_DIR=/cluster/project/cvl/specta/code/robust-models-transfer
cd ${PROJECT_ROOT_DIR}
pwd

SCRIPT_DIR=submit_jobs/CVPR
cd ${SCRIPT_DIR}
pwd

bsub < a01_fmap_i.sh
bsub < a01.sh
bsub < a05_fmap_i.sh
bsub < a05.sh
bsub < a10_fmap_i.sh
bsub < a10.sh