#!/bin/bash

# Set project paths
PROJECT_ROOT_DIR=/cluster/project/cvl/specta/code/robust-models-transfer
export PYTHONPATH=${PYTHONPATH}:${PROJECT_ROOT_DIR}
cd ${PROJECT_ROOT_DIR}
pwd

bsub < submit_jobs/batch_2/regular.sh
bsub < submit_jobs/batch_2/rnd_mean.sh
bsub < submit_jobs/batch_2/rnd_param.sh