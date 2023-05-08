#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=22gb
#SBATCH --tmp=18gb
#SBATCH -t 24:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=liux1299@umn.edu
#SBATCH -p small,ram256g,ram1t
#SBATCH -o %j.out
#SBATCH -e %j.err

set -e
set -o pipefail

# Dependencies
export PATH=$PATH:/panfs/roc/groups/9/morrellp/shared/Software/mosdepth

# User provided input arguments
BAM=""
OUT_PREFIX="morex_quantized"
OUT_DIR="/scratch.global/liux1299/captured_XX_BED"

#-----------------
# Check the out dir and scratch dir exist, if not make them
mkdir -p ${OUT_DIR}

# By setting these ENV vars, we can control the output labels (4th column)
export MOSDEPTH_Q0=NO_COVERAGE   # 0 -- defined by the arguments to --quantize
export MOSDEPTH_Q1=LOW_COVERAGE  # 1..4
export MOSDEPTH_Q2=CALLABLE      # 5..149
export MOSDEPTH_Q3=HIGH_COVERAGE # 150 ...
# Run mosdepth
mosdepth --threads 4 \
    --fast-mode \
    --no-per-base \
    --quantize 0:1:5:150: \
    ${OUT_PREFIX} \
    ${BAM}
