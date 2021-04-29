#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=22gb
#SBATCH --tmp=12gb
#SBATCH -t 08:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=liux1299@umn.edu
#SBATCH -p small,ram256g,ram1t
#SBATCH -o %j.out
#SBATCH -e %j.err

set -e
set -o pipefail

#   Usage message:
#   Note: The following paths will need to be hardcoded \n\
    #   1. [PYTHON_SCRIPT] is Tom's refseq_capturedesign.py script
    #   2. [BAM_FILE] is the full path to the BAM file we are using
    #   3. [OUT_DIR] is the full path to where our output files go

#   Dependencies
module load bedtools_ML/2.28.0
module load python2/2.7.15_anaconda # Script written in Python 2

#   User provided input arguments
#   Where is Tom's refseq_capturedesign.py file located?
PYTHON_SCRIPT=/panfs/roc/groups/9/morrellp/liux1299/GitHub/captured_50x_BED/refseq_capturedesign.py
#   BAM file we are using
BAM_FILE=/scratch.global/liux1299/captured_50x_morex_v3/Indel_Realigner/ERR271706_realigned.bam
#   Where do our output files go?
OUT_DIR=/scratch.global/liux1299/captured_50x_morex_v3/parts_ref

#-----------------
# Check if out dir exists, if not make it
mkdir -p ${OUT_DIR}

#   Function to generate BED graph of coverage
function bedGraph() {
    local bam_file="$1"
    local out_dir="$2"
    #   Sample name
    sampleName=`basename "${bam_file}" .bam`
    #   Generate BED graph
    bedtools genomecov -bg -ibam ${bam_file} > ${out_dir}/${sampleName}_BED_Graph.txt
}

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

export -f filterIntervals

#   Use basename to find intermediate files
SAMPLE_NAME=`basename "${BAM_FILE}" .bam`

#   Run the program
# Generate BED graph of coverage
bedGraph ${BAM_FILE} ${OUT_DIR}
# Filter positions with a certain depth and filter intervals
filterIntervals "${OUT_DIR}/${SAMPLE_NAME}_BED_Graph.txt" ${OUT_DIR} ${PYTHON_SCRIPT}
