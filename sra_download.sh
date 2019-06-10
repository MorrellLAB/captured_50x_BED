#!/bin/bash
#PBS -l mem=12gb,nodes=1:ppn=8,walltime=03:00:00
#PBS -m abe
#PBS -M liux1299@umn.edu
#PBS -q mesabi
#PBS -N sra_download

# This script runs Tom's SRA_Fetch.sh script to download SRA data

# Dependencies
module load lftp_ML/4.8.4

# Input arguments
SCRIPT_DIR=/panfs/roc/groups/9/morrellp/liux1299/GitHub/captured_50x_BED
SRA_RUN_ID=ERR271706
OUT_DIR=/home/morrellp/liux1299/scratch/sra_downloads

# Run download script
"${SCRIPT_DIR}"/SRA_Fetch.sh -r "${SRA_RUN_ID}" -d "${OUT_DIR}"
