#!/bin/bash

# bash script to evaluate different representations. 
# finetune.py learns a linear classifier on the features extracted from the support set 
# compile_result.py computes the averages and the 96 confidence intervals from the results generated from finetune.py
# and evaluate on the query set
export CUDA_VISIBLE_DEVICES=0

##############################################################################################
# Evaluate Representations trained on miniImageNet
##############################################################################################

# Before running the commands, please take care of the TODO appropriately
for source in "miniImageNet"
do
    for target in "ChestX" "ISIC" "EuroSAT" "CropDisease"
    do
        # TODO: Please set the following argument appropriately 
        # --save_dir: directory to save the results from evaluation
        # --embedding_load_path: representation to be evaluated 
        # --embedding_load_path_version: either 0 or 1. This is 1 most of the times. Only set this to 0 when 
        #                                evaluating teacher model trained using teacher_miniImageNet/train.py
        # E.g. the following command evaluates the STARTUP representation on 600 tasks
        #      and save the results of the 600 tasks at results/STARTUP_miniImageNet/$source\_$target\_5way.csv
        python finetune.py \
        --image_size 224 \
        --n_way 5 \
        --n_shot 1 5 20 50\
        --n_episode 600 \
        --n_query 15 \
        --seed 1 \
        --freeze_backbone \
        --save_dir results/STARTUP_miniImageNet_na \
        --source_dataset $source \
        --target_dataset $target \
        --subset_split ../datasets/split_seed_1/$target\_labeled_80.csv \
        --model resnet10 \
        --embedding_load_path ../student_STARTUP_na/miniImageNet_source/$target\_unlabeled_20/checkpoint_best.pkl \
        --embedding_load_path_version 1

        # TODO: Please set --result_file appropriately. The prefix of the argument should be the same as 
        # the --save_dir from the previous command
        # E.g. the following command computes the mean and 95 CI from results/STARTUP_miniImageNet/$source\_$target\_5way.csv
        #       and saves them to results/STARTUP_miniImageNet/$source\_$target\_5way_compiled.csv
        python compile_result.py --result_file results/STARTUP_miniImageNet/$source\_$target\_5way.csv
    done
done


##############################################################################################
# Evaluate Representations trained on miniImageNet
##############################################################################################

# Before running the commands, please take care of the TODO appropriately
for source in "miniImageNet"
do
    for target in "ChestX" "ISIC" "EuroSAT" "CropDisease"
    do
        # TODO: Please set the following argument appropriately 
        # --save_dir: directory to save the results from evaluation
        # --embedding_load_path: representation to be evaluated 
        # --embedding_load_path_version: either 0 or 1. This is 1 most of the times. Only set this to 0 when 
        #                                evaluating teacher model trained using teacher_miniImageNet/train.py
        # E.g. the following command evaluates the STARTUP representation on 600 tasks
        #      and save the results of the 600 tasks at results/STARTUP_miniImageNet/$source\_$target\_5way.csv
        python finetune.py \
        --image_size 224 \
        --n_way 5 \
        --n_shot 1 5 20 50\
        --n_episode 600 \
        --n_query 15 \
        --seed 1 \
        --freeze_backbone \
        --save_dir results/STARTUP_miniImageNet_na_frozenteacher \
        --source_dataset $source \
        --target_dataset $target \
        --subset_split ../datasets/split_seed_1/$target\_labeled_80.csv \
        --model resnet10 \
        --embedding_load_path ../student_STARTUP_na/miniImageNet_source/$target\_unlabeled_20_frozenteacher/checkpoint_best.pkl \
        --embedding_load_path_version 1

        # TODO: Please set --result_file appropriately. The prefix of the argument should be the same as 
        # the --save_dir from the previous command
        # E.g. the following command computes the mean and 95 CI from results/STARTUP_miniImageNet/$source\_$target\_5way.csv
        #       and saves them to results/STARTUP_miniImageNet/$source\_$target\_5way_compiled.csv
        python compile_result.py --result_file results/STARTUP_miniImageNet/$source\_$target\_5way.csv
    done
done