#!/bin/bash

# Set project paths
PROJECT_ROOT_DIR=/cluster/project/cvl/specta/code/robust-models-transfer
cd ${PROJECT_ROOT_DIR}
pwd

SCRIPT_DIR=submit_jobs/CVPR/round4
cd ${SCRIPT_DIR}
pwd


bsub < aa_05.sh
bsub < aa_10.sh
bsub < ba_05.sh
bsub < ba_10.sh
