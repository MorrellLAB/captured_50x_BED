#!/bin/bash

#PBS -l mem=22gb,nodes=1:ppn=16,walltime=6:00:00
#PBS -m abe
#PBS -M liux1299@umn.edu
#PBS -q lab

set -e
set -u
set -o pipefail

#   Usage message:
#   Note: The following paths will need to be hardcoded \n\
    #   1. [PYTHON_SCRIPT] is Tom's refseq_capturedesign.py script
    #   2. [BAM_FILE] is the full path to the BAM file we are using
    #   3. [OUT_DIR] is the full path to where our output files go

#   Dependencies
module load bedtools
module load python # Script written in Python 2

#   Function to generate BED graph of coverage
function bedGraph() {
    local bam_file="$1"
    local out_dir="$2"
    #   Sample name
    sampleName=`basename "${bam_file}" .bam`
    #   Generate BED graph
    bedtools genomecov -bg -ibam ${bam_file} > ${out_dir}/${sampleName}_BED_Graph.txt
}

#   Export function
export -f bedGraph

#   Function to filter positions with a certain depth & filter intervals
function filterIntervals() {
    local bed_graph_file="$1" # This contains the full path to the file
    local out_dir="$2"
    local python_script="$3"
    #   Sample name
    sampleName=`basename "${bed_graph_file}" .txt`
    #   Filter positions with a certain depth (50x coverage in this case)
    awk '$4 >= 50 { print }' ${bed_graph_file} > ${out_dir}/${sampleName}_filtered.txt
    #   Call on python script written by Tom Kono to filter invervals
    ${python_script} "${out_dir}/${sampleName}_filtered.txt" > ${out_dir}/${sampleName}_captured_50x_partsRef.bed
}

#   Export function
export -f filterIntervals


#   Arguments provided by user

#   Where is Tom's refseq_capturedesign.py file located?
PYTHON_SCRIPT=${HOME}/GitHub/Barley_Inversions/scripts/captured_50x_BED/refseq_capturedesign.py
#   BAM file we are using
BAM_FILE=/panfs/roc/scratch/liux1299/morex_exome/seq_handling/SAM_Processing/Picard/Finished/morex_ERR271706_finished_realigned.bam
#   Where do our output files go?
OUT_DIR=/panfs/roc/scratch/liux1299/morex_exome/coverage

#   Use basename to find intermediate files
SAMPLE_NAME=`basename "${BAM_FILE}" .bam`

#   Run the program
bedGraph ${BAM_FILE} ${OUT_DIR}
filterIntervals "${OUT_DIR}/${SAMPLE_NAME}_BED_Graph.txt" ${OUT_DIR} ${PYTHON_SCRIPT}
