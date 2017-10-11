# captured_50x_BED

This repository contains scripts that were used to make the `captured_50x_partsRef.bed` file.

The Morex reads were from the [Mascher et al. 2013 *The Plant Journal* paper](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4241023/). The SRA BioProject number for the reads is: **PRJEB1810**. The SRA number for the reads is: [**ERP002487**](https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?study=ERP002487).

Accessions were downloaded by feeding an accession list to Fernanda's [`SRA_download.sh`](https://github.com/fervet01/Utilities/blob/master/SRA_download.sh) script.

---

### Methods

To regenerate this file, I used Morex sample: ERR271706

1. Take high coverage BAM of Morex reads mapped against parts reference (reads from links above). Used read mapping parameters in Tom Kono's first deleterious mutations paper located in [this GitHub repository](https://github.com/MorrellLAB/Deleterious_Mutations/tree/master/Job_Scripts).
   - Used [`sequence_handling`](https://github.com/MorrellLAB/sequence_handling) for read mapping with parameters stored in `morex_ExCap_config`
   - Indexed BAM files using `index_bam_morex.sh`
   - Then I did indel realignment with: `GATK_RTC-morex.job` and `GATK_IndelRealigner-morex.job`
3. Then use bedtools genomecov and Tom's `refseq_capturedesign.py` script to filter intervals
   - This script is called on within the `morex_50x_BED.sh` script.
