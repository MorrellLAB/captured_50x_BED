## Morex v3 regions file

Sample details are described in the main readme file: https://github.com/MorrellLAB/captured_50x_BED.

---

### Methods for Morex v3

Since we have previously (for Morex v2) downloaded the sample ERR271706 and run adapter trimming, we will download the trimmed sample from Tier2 storage and use that.

### Step 1: Align reads to morex reference

Use sequence_handling for read mapping. Used read mapping parameters in Tom Kono's first deleterious mutations paper located in [this GitHub repository](https://github.com/MorrellLAB/Deleterious_Mutations/tree/master/Job_Scripts).

**Parts reference:**

```bash
# Read mapping
./sequence_handling Read_Mapping ~/GitHub/captured_50x_BED/morex_v3/Config_morex_v3_parts_ref

# SAM Processing with Picard
./sequence_handling SAM_Processing ~/GitHub/captured_50x_BED/morex_v3/Config_morex_v3_parts_ref
```

### Step 2: Realign around indels

**Parts reference:**

Used `sequence_handling` to do indel realignment.

```bash
# Realigner Target Creator
./sequence_handling Realigner_Target_Creator ~/GitHub/captured_50x_BED/morex_v3/Config_Indel_Realign_morex_v3_parts_ref

# Indel realignment
./sequence_handling Indel_Realigner ~/GitHub/captured_50x_BED/morex_v3/Config_Indel_Realign_morex_v3_parts_ref
```

### Step 3: Filter intervals

Then use bedtools genomecov and Tom's `refseq_capturedesign.py` script to filter intervals. The `refseq_capturedesign.py` script is called within the `morex_v3_parts_ref_50x_BED.sh` script, which also stores the user provided input arguments.

```bash
# In dir: ~/GitHub/captured_50x_BED/morex_v3
sbatch morex_v3_parts_ref_50x_BED.sh
```

There should be 3 output files from the `morex_v3_parts_ref_50x_BED.sh` script:
1. `ERR271706_realigned_BED_Graph_captured_50x_partsRef.bed`
2. `ERR271706_realigned_BED_Graph_filtered.txt`
3. `ERR271706_realigned_BED_Graph.txt`

The `*.txt` files are intermediate files and do not need to be kept. The `.bed` file is the one we care about.

We will do some renaming and cleaning up long seqIDs.

```bash
# In dir: ~/scratch/captured_50x_morex_v3/parts_ref
cp ERR271706_realigned_BED_Graph_captured_50x_partsRef.bed /panfs/roc/groups/9/morrellp/shared/References/Reference_Sequences/Barley/Morex_v3/captured_50x_morex_v3_partsRef_longSeqID.bed

# Shorten chromosome names
sed -e 's/::/\t/' ERR271706_realigned_BED_Graph_captured_50x_partsRef.bed | cut -f 1,3,4 > /panfs/roc/groups/9/morrellp/shared/References/Reference_Sequences/Barley/Morex_v3/captured_50x_morex_v3_partsRef.bed
```

Visually check that 50x regions look as expected using IGV.

When running GATK variant calling, A `.intervals` or `.list` format for regions to call variants in works best. We'll create a `.intervals` format for the `.bed` file.

```bash
# In dir: /panfs/roc/groups/9/morrellp/shared/References/Reference_Sequences/Barley/Morex_v3
sed -e "s/\t/:/" -e "s/\t/-/" captured_50x_morex_v3_partsRef.bed > captured_50x_morex_v3_partsRef.intervals
```
