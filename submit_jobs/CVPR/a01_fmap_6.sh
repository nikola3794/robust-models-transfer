#!/bin/bash
#BSUB -o /cluster/work/cvl/specta/experiment_logs/robust-transfer/_euler_logs/  # path to output file
#BSUB -W 47:59 # HH:MM runtime
#BSUB -n 8 # number of cpu cores
#BSUB -R "rusage[mem=4096]" # MB per CPU core
#BSUB -R "rusage[ngpus_excl_p=1]" # number of GPU cores
#BSUB -R "select[gpu_mtotal0>=8240]" # MB per GPU core
#BSUB -J "rnd_dtd"
#BSUB -R lca # workaround for the current wandb cluster bug

DATA_SET=dtd

if [ "$DATA_SET" = "aircraft" ]; then
  ZIP_FILE_NAME=fgvc-aircraft-2013b.tar.gz
  DATA_SET_DIR=fgvc-aircraft-2013b
elif [ "$DATA_SET" = "birds" ]; then
  ZIP_FILE_NAME=birdsnap.tar
  DATA_SET_DIR=birdsnap
elif [ "$DATA_SET" = "caltech101" ]; then
  ZIP_FILE_NAME=caltech101.tar
  DATA_SET_DIR=caltech101
elif [ "$DATA_SET" = "caltech256" ]; then
  ZIP_FILE_NAME=caltech256.tar
  DATA_SET_DIR=caltech256
elif [ "$DATA_SET" = "cifar10" ]; then
  ZIP_FILE_NAME=todo # TODO
  DATA_SET_DIR=todo # TODO
elif [ "$DATA_SET" = "cifar100" ]; then
  ZIP_FILE_NAME=todo #TODO
  DATA_SET_DIR=todo # TODO
elif [ "$DATA_SET" = "dtd" ]; then
  ZIP_FILE_NAME=dtd.tar
  DATA_SET_DIR=dtd
elif [ "$DATA_SET" = "flowers" ]; then
  ZIP_FILE_NAME=flowers.tar
  DATA_SET_DIR=flowers_new
elif [ "$DATA_SET" = "food" ]; then
  ZIP_FILE_NAME=food.tar
  DATA_SET_DIR=food-101
elif [ "$DATA_SET" = "pets" ]; then
  ZIP_FILE_NAME=pets.tar
  DATA_SET_DIR=pets
elif [ "$DATA_SET" = "stanford_cars" ]; then
  ZIP_FILE_NAME=stanford_cars.tar
  DATA_SET_DIR=cars_new
elif [ "$DATA_SET" = "SUN397" ]; then
  ZIP_FILE_NAME=SUN397.tar
  DATA_SET_DIR=SUN397/splits_01
fi
echo "Zip file name: ${ZIP_FILE_NAME}"
echo "Data set dir: ${DATA_SET_DIR}"

# Activate python environment
source /cluster/project/cvl/specta/python_envs/robust-transfer/bin/activate

# Access to internet to download torch models
module load eth_proxy
# For parallel data unzipping
module load pigz

# Print number of GPU/CPU resources available
echo "CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES}"
echo "Number of CPU threads/core: $(nproc --all)"

# Transfer dataset to scratch
if [ "$DATA_SET" = "aircraft" ]; then
  tar -I pigz -xf /cluster/work/cvl/specta/data/${ZIP_FILE_NAME} -C ${TMPDIR}/
  echo "Unzipped dataset"
elif [ "$DATA_SET" != "cifar"* ]; then
  tar -xf /cluster/work/cvl/specta/data/${ZIP_FILE_NAME} -C ${TMPDIR}/
  echo "Unzipped dataset"
fi

# Set project paths
PROJECT_ROOT_DIR=/cluster/project/cvl/specta/code/robust-models-transfer
export PYTHONPATH=${PYTHONPATH}:${PROJECT_ROOT_DIR}
cd ${PROJECT_ROOT_DIR}
pwd

MODEL_PATH=/cluster/work/cvl/specta/experiment_logs/image_net/rnd_relu/a090_110_20211101-135847-vit_relu_rnd_per_dim_deit_small_patch16_224/last.pth.tar
ARCH=vit_rnd_per_dim_fmap_i_deit_small_patch16_224
MIN_SLOPE=0.9
MAX_SLOPE=1.1
RND_TYPE=uniform
FMAP_I=6

RND=$(( RANDOM % 999 ))

FREEZE_LEVEL_ALL=("-2" "-1")
for FREEZE_LEVEL in ${FREEZE_LEVEL_ALL[*]}; do

  if [ "$FREEZE_LEVEL" = "-2" ]; then
    ADDITIONAL_HIDDEN=2
    LR=0.0001
    WD=0.0
    EPOCHS=100
  else
    ADDITIONAL_HIDDEN=0
    LR=0.00001
    WD=0.05
    EPOCHS=100
  fi

  FMAP_WHERE_ALL=("before_act" "after_act")
  for FMAP_WHERE in ${FMAP_WHERE_ALL[*]}; do

    EXP_NAME=${DATA_SET}-${ARCH}-slope-${MIN_SLOPE}-${MAX_SLOPE}-${RND_TYPE}-fmap-${FMAP_I}-${FMAP_WHERE}-freeze_level-${FREEZE_LEVEL}-add_hidden-${ADDITIONAL_HIDDEN}-${RND}
    
    python src/main_new.py \
      --config ${PROJECT_ROOT_DIR}/submit_jobs/CVPR/default_config.yaml \
      --exp-name $EXP_NAME \
      --out-dir /cluster/work/cvl/specta/experiment_logs/image_net/transfer-learning/ \
      --dataset $DATA_SET \
      --data ${TMPDIR}/${DATA_SET_DIR} \
      --arch $ARCH \
      --model-path $MODEL_PATH \
      --act-min-slope $MIN_SLOPE \
      --act-max-slope $MAX_SLOPE \
      --act-randomness-type $RND_TYPE \
      --fmap-i $FMAP_I \
      --fmap-where $FMAP_WHERE \
      --freeze-level $FREEZE_LEVEL \
      --additional-hidden $ADDITIONAL_HIDDEN \
      --lr $LR \
      --weight-decay $WD \
      --epochs $EPOCHS 
  done
done