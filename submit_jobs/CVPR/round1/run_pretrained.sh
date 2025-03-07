#!/bin/bash

# Set project paths
PROJECT_ROOT_DIR=/cluster/project/cvl/specta/code/robust-models-transfer
cd ${PROJECT_ROOT_DIR}
pwd

SCRIPT_DIR=submit_jobs/CVPR
cd ${SCRIPT_DIR}
pwd

bsub < pretrained_fmap_6.sh
bsub < pretrained_fmap_8.sh
bsub < pretrained_fmap_10.sh
bsub < pretrained_fmap_12.sh