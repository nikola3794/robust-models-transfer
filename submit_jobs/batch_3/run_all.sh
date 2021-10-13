#!/bin/bash

# Set project paths
PROJECT_ROOT_DIR=/cluster/project/cvl/specta/code/robust-models-transfer
export PYTHONPATH=${PYTHONPATH}:${PROJECT_ROOT_DIR}
cd ${PROJECT_ROOT_DIR}
pwd

bsub < submit_jobs/batch_3/aircraft_rnd_rnd.sh
bsub < submit_jobs/batch_3/birds_rnd_rnd.sh
bsub < submit_jobs/batch_3/caltech101_rnd_rnd.sh
bsub < submit_jobs/batch_3/caltech256_rnd_rnd.sh
bsub < submit_jobs/batch_3/cifar10_rnd_rnd.sh
bsub < submit_jobs/batch_3/cifar100_rnd_rnd.sh
bsub < submit_jobs/batch_3/dtd_rnd_rnd.sh
bsub < submit_jobs/batch_3/flowers_rnd_rnd.sh
bsub < submit_jobs/batch_3/food_rnd_rnd.sh
bsub < submit_jobs/batch_3/pets_rnd_rnd.sh
bsub < submit_jobs/batch_3/stanford_cars_rnd_rnd.sh
bsub < submit_jobs/batch_3/SUN397_rnd_rnd.sh