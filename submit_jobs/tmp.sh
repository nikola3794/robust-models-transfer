#!/bin/bash
#BSUB -o /cluster/work/cvl/specta/experiment_logs/robust-transfer/euler_logs/  # path to output file
#BSUB -W 47:59 # HH:MM runtime
#BSUB -n 8 # number of cpu cores
#BSUB -R "rusage[mem=4096]" # MB per CPU core
#BSUB -R "rusage[ngpus_excl_p=1]" # number of GPU cores
#BSUB -R "select[gpu_mtotal0>=20240]" # MB per GPU core
#BSUB -J "tmp"
#BSUB -R lca # workaround for the current wandb cluster bug

DATA_SET_DIR=fgvc-aircraft-2013b

# Activate python environment
source /cluster/project/cvl/specta/python_envs/robust-transfer/bin/activate

# Access to internet to download torch models
module load eth_proxy
# For parallel data unzipping
module load pigz

# Print number of GPU/CPU resources available
echo "CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES}"
echo "Number of CPU threads/core: $(nproc --all)"

# Transfer ImageNet to scratch
tar -I pigz -xf /cluster/work/cvl/specta/data/fgvc-aircraft-2013b.tar.gz -C ${TMPDIR}/
#echo "Number of train classes is $(ls ${TMPDIR}/${}/train | wc -l)"
#echo "Number of val classes is $(ls ${TMPDIR}/ILSVRC2012/val | wc -l)"

# Set project paths
PROJECT_ROOT_DIR=/cluster/project/cvl/specta/code/robust-models-transfer
export PYTHONPATH=${PYTHONPATH}:${PROJECT_ROOT_DIR}
cd ${PROJECT_ROOT_DIR}
pwd

# RND=$(( RANDOM % 999 ))
# MASTER_PORT=$((29000 + $RND))
# echo "Master port: ${MASTER_PORT}"

python src/main.py --arch resnet18 \
  --dataset aircraft \
  --data ${TMPDIR}/fgvc-aircraft-2013b \
  --out-dir /cluster/work/cvl/specta/experiment_logs/robust-transfer \
  --exp-name aircraft-vit-rnd \
  --epochs 150 \
  --lr 0.01 \
  --step-lr 50 \
  --batch-size 64 \
  --weight-decay 5e-4 \
  --adv-train 0 \
  --arch vit_deit_small_patch16_224 \
  --model-path /cluster/work/cvl/specta/experiment_logs/image_net/nikola/20211006-213406-vit_relu_rnd_per_dim_deit_small_patch16_224/model_best.pth.tar
  --freeze-level -1