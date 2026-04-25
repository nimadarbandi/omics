# CD73 KO vs WT RNA-seq Analysis (Kallisto + Sleuth)

This repository contains a reproducible RNA-seq workflow for comparing **CD73 knockout (KO)** and **wild-type (WT)** mouse samples, inspired by the paper:

**"Knock-out of CD73 delays the onset of HR-negative breast cancer by reprogramming lipid metabolism and is associated with increased tumor mutational burden"**  
https://www.sciencedirect.com/science/article/pii/S2212877824001662

## Why This Project Is Important

- CD73 has a potential regulatory role in lipid metabolism and tumor biology.
- Reproducing this analysis helps validate published findings in an independent workflow.
- Differential expression outputs can guide downstream pathway enrichment and mechanistic follow-up.

## Data Source

- SRA BioProject: `PRJNA933922`  
  https://www.ncbi.nlm.nih.gov/sra/?term=PRJNA933922

Example run accession used in planning:  
https://www.ncbi.nlm.nih.gov/sra/SRX27730892[accn]

## Repository Layout

- `Project/Project Plan.md`: Project scope, phases, paper/data links.
- `Project/CD73.sh`: SLURM batch script for download, indexing, quantification, and R invocation.
- `Project/sleuth_cd73.R`: Sleuth differential expression script (LRT; `qval <= 0.05`).
- `Project/KO_vs_WT_sleuth_q_0.05.csv`: Example significant transcript results.
- `Project/SleuthResults-2.pdf`: Example bootstrap plot output.

## Workflow Summary

1. Download SRA runs (`prefetch` + `fasterq-dump`) and compress FASTQ.
2. Download Ensembl cDNA reference (`Mus musculus GRCm39`) and build a Kallisto index.
3. Run `kallisto quant` for each sample with bootstrap estimates.
4. Run Sleuth (LRT: `~1` vs `~condition`) in R.
5. Export significant transcripts and create PDF plots for top targets.

## Requirements

HPC/cluster assumptions in current scripts:

- SLURM scheduler
- Environment modules
- SRA Toolkit `3.0.1`
- Kallisto `0.48.0`
- Conda environment named `sleuth`
- R packages:
  - `sleuth`
  - `dplyr`

## How To Run

1. Adjust paths and sample metadata in:
   - `Project/CD73.sh`
   - `Project/sleuth_cd73.R`
2. Ensure scripts are available in your work directory (`/work/md40040/project` in current version).
3. Submit the job:

```bash
sbatch Project/CD73.sh
```

## Expected Outputs

From the current scripts, expected outputs include:

- `wt_vs_KO_sleuth_q_0.05.csv` (from `sleuth_cd73.R`)
- `SleuthResults.pdf` (from `sleuth_cd73.R`)

Provided sample outputs in this repo currently include:

- `Project/KO_vs_WT_sleuth_q_0.05.csv`
- `Project/SleuthResults-2.pdf`

## Notes / Current Caveats

- `Project/CD73.sh` currently defines 8 SRA IDs initially, but only quantifies 4 IDs later in the script.
- `Project/sleuth_cd73.R` expects 8 samples in `sample` and `condition`; make sure this matches quantification outputs.
- Output filenames in script and existing files differ (`wt_vs_KO...` vs `KO_vs_WT...`, `SleuthResults.pdf` vs `SleuthResults-2.pdf`).
- Several download lines in `CD73.sh` are commented out; uncomment if raw data download is required.