#!/bin/bash
#SBATCH --mail-user=Moslem.Yazdanpanah@gmail.com
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE
#SBATCH --mail-type=ALL
#SBATCH --job-name=student
#SBATCH --output=%x-%j.out
#SBATCH --nodes=1
#SBATCH --gres=gpu:2
#SBATCH --ntasks-per-node=32
#SBATCH --mem=127000M
#SBATCH --time=00:15:00
nvidia-smi

source ~/STARTUP_ENV/bin/activate

cd $SLURM_TMPDIR
mkdir STARTUP
cd STARTUP
unzip ~/scratch/STARTUP.zip

mkdir dataset
cd dataset
unzip ~/scratch/CD-FSL_Datasets/miniImagenet.zip

mkdir ChestX-Ray8 EuroSAT ISIC2018 plant-disease

cd EuroSAT
unzip ~/scratch/CD-FSL_Datasets/EuroSAT.zip
cd ..
cd ChestX-Ray8
unzip ~/scratch/CD-FSL_Datasets/ChestX-Ray8.zip
cd ..
cd ISIC2018
unzip ~/scratch/CD-FSL_Datasets/ISIC2018.zip
cd ..
cd plant-disease
unzip ~/scratch/CD-FSL_Datasets/plant-disease.zip

cd $SLURM_TMPDIR
cd STARTUP
cd student_STARTUP
bash run.sh

cd $SLURM_TMPDIR
zip -r ~/scratch/student_models.zip $SLURM_TMPDIR/STARTUP/student_STARTUP/