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
```

