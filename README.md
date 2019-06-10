# captured_50x_BED

This repository contains scripts that were used to make the `captured_50x_partsRef.bed` file.

The Morex reads were from the [Mascher et al. 2013 *The Plant Journal* paper](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4241023/). The SRA BioProject number for the reads is: **PRJEB1810**. The SRA number for the reads is: [**ERP002487**](https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?study=ERP002487).

In this case, we are using Morex sample: **ERR271706**

Scripts used to make the `captured_50x_partsRef.bed` file for Morex v1 are located in the `morex_v1` directory. Methods described below are for `morex_v2`.

---

### Methods for Morex v2

For steps that require [`sequence_handling`](https://github.com/MorrellLAB/sequence_handling), we are using: commit 063221f68a71321fbb129b35ef2bf690e6d73d30.

#### Step 0: Prepare files

Download SRA file:

```bash
qsub sra_download.sh
```

Convert SRA to FASTQ:

```bash

```

Do some quality checks using


#### Step 1: Aligm reads to morex reference

Use sequence_handling for read mapping. Used read mapping parameters in Tom Kono's first deleterious mutations paper located in [this GitHub repository](https://github.com/MorrellLAB/Deleterious_Mutations/tree/master/Job_Scripts).

**Parts reference:**

```bash
./sequence_handling
```

**Pseudomolecules reference:**


