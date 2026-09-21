# Code and demo data

This repository contains scripts, reduced demo data, and reference outputs for three analyses:

1. identification of ARG and MGE genes located on the same contig and within 5 kb
2. known ARG abundance and composition analysis
3. BMRG abundance, composition, group comparison, and ARG correlation analysis

## Requirements

- Bash and standard Unix `awk` and `sort` commands
- R
- R packages: `rio`, `tidyverse`, `ggplot2`, `ggthemes`, `forcats`, `ggpubr`, and `knitr`

The code was tested with Bash 3.2.57, R 4.2.0, `rio` 1.2.3, `tidyverse` 2.0.0, `ggplot2` 3.5.1, `ggthemes` 5.1.0, `forcats` 1.0.0, `ggpubr` 0.6.0, and `knitr` 1.39. These are tested versions rather than strict requirements.

No special hardware or GPU is required. Install missing R packages before running the R workflows.

## Demo

### ARG–MGE co-localization within 5 kb

The script reads coordinates from Prodigal-format protein FASTA headers and reports ARG–MGE pairs located on the same contig with a distance of no more than 5 kb.

Run the following command from the repository root:

```
mkdir -p demo_run/arg_mge_5kb
cd demo_run/arg_mge_5kb
bash ../../scripts/arg_mge_5kb/find_5k_mges_args_from_faa.sh \
  ../../demo_data/arg_mge_5kb/mges.faa \
  ../../demo_data/arg_mge_5kb/args.faa
cd ../..
```

Expected runtime: a few seconds.

### Known ARG abundance and composition

Demo inputs are in `demo_data/known_ARG_abundance_and_composition/`. Four SVG files are written to `demo_run/known_ARG_abundance_and_composition/`.

Expected runtime: a few seconds.

### BMRG abundance and correlation

Demo inputs are in `demo_data/BMRG_abundance_and_correlation/`. Five SVG files are written to `demo_run/BMRG_abundance_and_correlation/`.

Expected runtime: a few seconds.

## Input formats

### ARG–MGE analysis

Both FASTA files must use Prodigal-style headers:

```
>protein_id # start # end # strand # ...
```

### Known ARG analysis

- `known_ARG_abundance.tsv`: `gene` followed by sample abundance columns
- `SARG_structure.tsv`: reduced SARG database structure file including `SARG.Seq.ID` and `Type`
- `rank_I_ARGs.tsv`: reduced Rank I ARG database file including `Variant`

### BMRG analysis

- `BMRG_abundance.tsv`: `level1` followed by sample abundance columns
- `BacMet_structure.tsv`: reduced BacMet2 database mapping file including `BacMet_ID`, `Gene_name`, and `Compound`
- `known_ARG_abundance.tsv`: known ARG abundance table used for correlations
- `SARG_structure.tsv`: reduced SARG database structure file used to classify known ARGs
- `rank_I_ARGs.tsv`: reduced Rank I ARG database file used to identify Rank I ARGs

Sample abundance columns must follow this naming pattern:

```
<city>-<method>-DNA-<pool>-<month>-<year>.reads.qc
```

To analyze other data, retain the demonstrated column names and file structure, then replace the files in the corresponding `demo_data` directory.

## License

The source code is licensed under the MIT License. See `LICENSE`.
