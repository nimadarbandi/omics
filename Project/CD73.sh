#!/bin/bash
#SBATCH --job-name=kallisto_cd73
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=20gb
#SBATCH --time=12:00:00
#SBATCH --mail-user=darbandi@uga.edu
#SBATCH --mail-type=END,FAIL

# Load required modules
module purge
module load SRA-Toolkit/3.0.1-centos_linux64
module load kallisto/0.48.0-gompi-2022a


OUTDIR=/work/md40040/project
THREADS=6
mkdir -p $OUTDIR


SRA_IDS=(
  SRR23421854
  SRR23421855
  SRR23421856
  SRR23421857
  SRR23421858
  SRR23421859
  SRR23421860
  SRR23421861
)

# ---------------------------------------
# Download and convert SRA to FASTQ
# ---------------------------------------
for SRA in "${SRA_IDS[@]}"; do
  # echo "Downloading $SRA..."
  # prefetch -O $OUTDIR $SRA

  # echo "Converting $SRA to FASTQ..."
  # fasterq-dump $OUTDIR/${SRA}/${SRA}.sra -O $OUTDIR -e $THREADS --split-files

  echo "Compressing FASTQ..."
  gzip $OUTDIR/${SRA}_1.fastq
  gzip $OUTDIR/${SRA}_2.fastq  
done

# 
# Download transcriptome and build Kallisto index
cd $OUTDIR
curl -s https://ftp.ensembl.org/pub/release-110/fasta/mus_musculus/cdna/Mus_musculus.GRCm39.cdna.all.fa.gz | gunzip -c > transcripts.fa
kallisto index -i transcripts.idx transcripts.fa


SRA_IDS=(
  SRR23421854
  SRR23421855
  SRR23421860
  SRR23421861
)

for SAMPLE in "${SRA_IDS[@]}"; do
  echo "Running Kallisto quant for $SAMPLE..."
  kallisto quant -i $OUTDIR/transcripts.idx \
    -o $OUTDIR/${SAMPLE} \
    -t $THREADS -b 100 \
    $OUTDIR/${SAMPLE}_1.fastq.gz $OUTDIR/${SAMPLE}_2.fastq.gz
done


CONDA_BASE=$(conda info --base)
source ${CONDA_BASE}/etc/profile.d/conda.sh
conda activate sleuth
R --no-save < $OUTDIR/sleuth_cd73.R