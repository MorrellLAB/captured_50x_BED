#!/bin/bash
#PBS -l mem=12gb,nodes=1:ppn=8,walltime=06:00:00
#PBS -m abe
#PBS -M liux1299@umn.edu
#PBS -q mesabi
#PBS -N sra_download


# Input arguments
OUT_DIR=/home/morrellp/liux1299/scratch/sra_downloads

# Check if out dir exists, if not make it
mkdir -p ${OUT_DIR}

# Download files via FTP link
cd ${OUT_DIR}
wget ftp://ftp.sra.ebi.ac.uk/vol1/err/ERR271/ERR271706
