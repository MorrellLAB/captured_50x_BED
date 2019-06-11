#!/bin/bash
#PBS -l mem=12gb,nodes=1:ppn=8,walltime=03:00:00
#PBS -m abe
#PBS -M liux1299@umn.edu
#PBS -q mesabi
#PBS -N sra_download

# This script runs Tom's SRA_Fetch.sh script to download SRA data

# Dependencies
module load sratoolkit_ML/2.9.6

# Input arguments
SRA_RUN_ID_LIST=/panfs/roc/groups/9/morrellp/liux1299/GitHub/captured_50x_BED/sra_run_acc_list.txt
OUT_DIR=/home/morrellp/liux1299/scratch/sra_downloads

# Check if out dir exists, if not make it
mkdir -p ${OUT_DIR}

# Use NCBI SRA Toolkit to download sra data
cd ${OUT_DIR}
prefetch --option-file ${SRA_RUN_ID_LIST} --max-size 40GB
