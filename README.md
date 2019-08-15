# captured_50x_BED

This repository contains scripts that were used to make the `captured_50x_morex_v2_ref.bed` file.

The Morex reads were from the [Mascher et al. 2013 *The Plant Journal* paper](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4241023/). The SRA BioProject number for the reads is: **PRJEB1810**. The SRA number for the reads is: [**ERP002487**](https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?study=ERP002487).

In this case, we are using Morex sample: **ERR271706**

Link to EMBL-EBI is: https://www.ebi.ac.uk/ena/data/view/ERR271706

Scripts used to make the `captured_50x_partsRef.bed` file for Morex v1 are located in the `morex_v1` directory. Methods described below are for `morex_v2`.

---

### Methods for Morex v2

For steps that require [`sequence_handling`](https://github.com/MorrellLAB/sequence_handling), we are using: commit 063221f68a71321fbb129b35ef2bf690e6d73d30.

#### Step 0: Prepare files

The preparation steps only need to be run one time.

Download FASTQ files directly from FTP links:

```bash
qsub sra_download.sh
```

Do some quality checks using sequence_handling:

```bash
./sequence_handling Quality_Assessment /panfs/roc/groups/9/morrellp/liux1299/GitHub/captured_50x_BED/morex_v2/morex_v2_parts_ref_config
```

Trim adapters:

```bash
./sequence_handling Adapter_Trimming /panfs/roc/groups/9/morrellp/liux1299/GitHub/captured_50x_BED/morex_v2/morex_v2_parts_ref_config

# Run QA on trimmed samples
./sequence_handling Quality_Assessment /panfs/roc/groups/9/morrellp/liux1299/GitHub/captured_50x_BED/morex_v2/morex_v2_parts_ref_config
```

#### Step 1: Align reads to morex reference

Use sequence_handling for read mapping. Used read mapping parameters in Tom Kono's first deleterious mutations paper located in [this GitHub repository](https://github.com/MorrellLAB/Deleterious_Mutations/tree/master/Job_Scripts).

**Parts reference:**

```bash
# Read mapping
./sequence_handling Read_Mapping /panfs/roc/groups/9/morrellp/liux1299/GitHub/captured_50x_BED/morex_v2/morex_v2_parts_ref_config

# SAM Processing with Picard
./sequence_handling SAM_Processing /panfs/roc/groups/9/morrellp/liux1299/GitHub/captured_50x_BED/morex_v2/morex_v2_parts_ref_config
```

#### Step 2: Realign around indels

**Parts reference:**

Used `sequence_handling` to do indel realignment.

```bash
# Realigner Target Creator
./sequence_handling Realigner_Target_Creator /panfs/roc/groups/9/morrellp/liux1299/GitHub/captured_50x_BED/morex_v2/morex_v2_parts_ref_indel_realign_config

# Indel realignment
./sequence_handling Indel_Realigner /panfs/roc/groups/9/morrellp/liux1299/GitHub/captured_50x_BED/morex_v2/morex_v2_parts_ref_indel_realign_config
```

#### Step 3: Filter intervals

Then use bedtools genomecov and Tom's `refseq_capturedesign.py` script to filter intervals. The `refseq_capturedesign.py` script is called within the `morex_v2_50x_BED.sh` script, which also stores the user provided input arguments.

```bash
qsub morex_v2_parts_ref_50x_BED.sh
```

There should be 3 output files from the `morex_v2_parts_ref_50x_BED.sh` script:
1. `ERR271706_realigned_BED_Graph.txt`
2. `ERR271706_realigned_BED_Graph_filtered.txt`
3. `ERR271706_realigned_BED_Graph_captured_50x_partsRef.bed`

The `*.txt` files are intermediate files and do not need to be kept. The `.bed` file is the one we care about. We will rename it to something more meaningful and put it in the references directory:

```bash
cp ERR271706_realigned_BED_Graph_captured_50x_partsRef.bed /panfs/roc/groups/9/morrellp/shared/References/Reference_Sequences/Barley/Morex_v2/captured_50x_morex_v2_partsRef.bed
```

The `captured_50x_morex_v2_partsRef.bed` is also available in this GitHub repository under the directory `morex_v2`.

#### Pseudomolecules reference

Since we have already created a 50x bed file using the parts reference with the steps above, we will use an updated version of Tom's [`Barley_Parts_to_Pseudomolecules.py`](https://github.com/MorrellLAB/File_Conversions/blob/master/Barley_Parts_to_Pseudomolecules.py) script to convert the parts positions to pseudomolecules. Please see the `File_Conversions` GitHub repository for access to this script: https://github.com/MorrellLAB/File_Conversions/blob/master/Barley_Parts_to_Pseudomolecules.py.

```bash
# In dir: ~/GitHub/File_Conversions
# Convert parts to pseudomolecules
./Barley_Parts_to_Pseudomolecules.py --bed ~/GitHub/captured_50x_BED/morex_v2/captured_50x_morex_v2_partsRef.bed > ~/GitHub/captured_50x_BED/morex_v2/captured_50x_morex_v2_pseudomolecules.bed
```
