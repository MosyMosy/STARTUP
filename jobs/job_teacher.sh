#!/bin/bash
#SBATCH --mail-user=Moslem.Yazdanpanah@gmail.com
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE
#SBATCH --mail-type=ALL
#SBATCH --job-name=STARTUP_teacher
#SBATCH --output=%x-%j.out
#SBATCH --nodes=1
#SBATCH --gres=gpu:4
#SBATCH --ntasks-per-node=32
#SBATCH --mem=127000M
#SBATCH --time=1-12:00
#SBATCH --account=def-ebrahimi

nvidia-smi

source ~/ENV/bin/activate

cd $SLURM_TMPDIR

cp -r ~/scratch/STARTUP .
cd STARTUP

cd datasets
unzip ~/scratch/CD-FSL_Datasets/miniImagenet.zip

# mkdir ChestX-Ray8 EuroSAT ISIC2018 plant-disease

# cd EuroSAT
# unzip ~/scratch/CD-FSL_Datasets/EuroSAT.zip
# cd ..

# cd ChestX-Ray8
# unzip ~/scratch/CD-FSL_Datasets/ChestX-Ray8.zip
# mkdir images
# find . -type f -name '*.png' -print0 | xargs -0 mv -t images

# cd ..
# cd ISIC2018
# unzip ~/scratch/CD-FSL_Datasets/ISIC2018.zip
# unzip ~/scratch/CD-FSL_Datasets/ISIC2018_GroundTruth.zip

# cd ..
# cd plant-disease
# unzip ~/scratch/CD-FSL_Datasets/plant-disease.zip

cd $SLURM_TMPDIR

cd STARTUP

# cd teacher_miniImageNet_na
cd teacher_miniImageNet

bash run.sh
cd $SLURM_TMPDIR
cp -r $SLURM_TMPDIR/STARTUP/teacher_miniImageNet/ ~/scratch/STARTUP/
