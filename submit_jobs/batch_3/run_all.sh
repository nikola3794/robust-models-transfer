#!/bin/bash

# Set project paths
PROJECT_ROOT_DIR=/cluster/project/cvl/specta/code/robust-models-transfer
export PYTHONPATH=${PYTHONPATH}:${PROJECT_ROOT_DIR}
cd ${PROJECT_ROOT_DIR}
pwd

bsub < submit_jobs/batch_2/aircraft_rnd_rnd.sh
bsub < submit_jobs/batch_2/birds_rnd_rnd.sh
bsub < submit_jobs/batch_2/caltech101_rnd_rnd.sh
bsub < submit_jobs/batch_2/caltech256_rnd_rnd.sh
bsub < submit_jobs/batch_2/cifar10_rnd_rnd.sh
bsub < submit_jobs/batch_2/cifar100_rnd_rnd.sh
bsub < submit_jobs/batch_2/dtd_rnd_rnd.sh
bsub < submit_jobs/batch_2/flowers_rnd_rnd.sh
bsub < submit_jobs/batch_2/food_rnd_rnd.sh
bsub < submit_jobs/batch_2/pets_rnd_rnd.sh
bsub < submit_jobs/batch_2/stanford_cars_rnd_rnd.sh
bsub < submit_jobs/batch_2/SUN397_rnd_rnd.sh