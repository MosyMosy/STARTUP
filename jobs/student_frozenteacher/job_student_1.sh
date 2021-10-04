#!/bin/bash
#SBATCH --mail-user=Moslem.Yazdanpanah@gmail.com
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE
#SBATCH --mail-type=ALL
#SBATCH --job-name=STARTUP_Student_1_ft
#SBATCH --output=%x-%j.out
#SBATCH --nodes=1
#SBATCH --gres=gpu:4
#SBATCH --ntasks-per-node=32
#SBATCH --mem=127000M
#SBATCH --time=0-08:00
#SBATCH --account=def-ebrahimi

nvidia-smi

source ~/ENV/bin/activate

cd $SLURM_TMPDIR

cp -r ~/scratch/STARTUP .
cd STARTUP

cd datasets
unzip ~/scratch/CD-FSL_Datasets/miniImagenet.zip

mkdir ChestX-Ray8 EuroSAT ISIC2018 plant-disease

cd EuroSAT
unzip ~/scratch/CD-FSL_Datasets/EuroSAT.zip
cd ..

cd ChestX-Ray8
unzip ~/scratch/CD-FSL_Datasets/ChestX-Ray8.zip
mkdir images
find . -type f -name '*.png' -print0 | xargs -0 mv -t images

cd ..
cd ISIC2018
unzip ~/scratch/CD-FSL_Datasets/ISIC2018.zip
unzip ~/scratch/CD-FSL_Datasets/ISIC2018_GroundTruth.zip

cd ..
cd plant-disease
unzip ~/scratch/CD-FSL_Datasets/plant-disease.zip

cd $SLURM_TMPDIR
cd STARTUP
cd student_STARTUP

for target_testset in "EuroSAT"; do
    # TODO: Please set the following argument appropriately
    # --teacher_path: filename for the teacher model
    # --base_path: path to find base dataset
    # --dir: directory to save the student representation.
    # E.g. the following commands trains a STARTUP representation based on the teacher specified at
    #      ../teacher_miniImageNet/logs_deterministic/checkpoints/miniImageNet/ResNet10_baseline_256_aug/399.tar
    #      The student representation is saved at miniImageNet_source/$target_testset\_unlabeled_20/checkpoint_best.pkl
    python STARTUP.py \
    --dir miniImageNet_source/$target_testset\_unlabeled_20_frozenteacher \
    --target_dataset $target_testset \
    --image_size 224 \
    --target_subset_split ../datasets/split_seed_1/$target_testset\_unlabeled_20.csv \
    --bsize 256 \
    --epochs 1000 \
    --save_freq 50 \
    --print_freq 10 \
    --seed 1 \
    --wd 1e-4 \
    --num_workers 4 \
    --model resnet10 \
    --teacher_path ../teacher_miniImageNet_na/logs_deterministic/checkpoints/miniImageNet/ResNet10_baseline_256_aug/399.tar \
    --teacher_path_version 0 \
    --base_dataset miniImageNet \
    --base_path ../datasets/miniImagenet
    --base_no_color_jitter \
    --base_val_ratio 0.05 \
    --eval_freq 2 \
    --batch_validate \
    --resume_latest

done

echo finish
cd $SLURM_TMPDIR
zip -r ~/scratch/student_STARTUP_$target_testset\_frozenteacher.zip $SLURM_TMPDIR/STARTUP/student_STARTUP/
