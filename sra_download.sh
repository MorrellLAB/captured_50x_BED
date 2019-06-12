#!/bin/bash
#PBS -l mem=22gb,nodes=1:ppn=6,walltime=24:00:00
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
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR271/ERR271706/ERR271706_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR271/ERR271706/ERR271706_2.fastq.gz
