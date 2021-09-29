#10x script
#Pavitra Roychoudhury
#adapted from Aug 2018 HSV scripts

#first grabnode 

## 0. this time for macaques so first need to make the ref 
cd /fh/fast/jerome_k/nhp_10X
module load CellRanger/6.0.1
# module load FastQC/0.11.9-Java-11

#From https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/using/tutorial_mr#macaque_6.0.0 (waiting for Dan to confirm if this one we need)

##downloaded and unzipped ref fasta and gtf
wget ftp://ftp.ensembl.org/pub/release-97/fasta/macaca_mulatta/dna/Macaca_mulatta.Mmul_8.0.1.dna.toplevel.fa.gz
gunzip Macaca_mulatta.Mmul_8.0.1.dna.toplevel.fa.gz
wget ftp://ftp.ensembl.org/pub/release-97/gtf/macaca_mulatta/Macaca_mulatta.Mmul_8.0.1.97.gtf.gz
gunzip Macaca_mulatta.Mmul_8.0.1.97.gtf.gz

cellranger mkgtf Macaca_mulatta.Mmul_8.0.1.97.gtf Macaca_mulatta.Mmul_8.0.1.97.filtered.gtf --attribute=gene_biotype:protein_coding  --attribute=gene_biotype:lincRNA  --attribute=gene_biotype:antisense  --attribute=gene_biotype:IG_LV_gene  --attribute=gene_biotype:IG_V_gene  --attribute=gene_biotype:IG_V_pseudogene  --attribute=gene_biotype:IG_D_gene  --attribute=gene_biotype:IG_J_gene  --attribute=gene_biotype:IG_J_pseudogene  --attribute=gene_biotype:IG_C_gene  --attribute=gene_biotype:IG_C_pseudogene  --attribute=gene_biotype:TR_V_gene  --attribute=gene_biotype:TR_V_pseudogene  --attribute=gene_biotype:TR_D_gene  --attribute=gene_biotype:TR_J_gene  --attribute=gene_biotype:TR_J_pseudogene  --attribute=gene_biotype:TR_C_gene


#Run mkref
cellranger mkref --genome=Mmul_8.0.1 --fasta=Macaca_mulatta.Mmul_8.0.1.dna.toplevel.fa --genes=Macaca_mulatta.Mmul_8.0.1.97.filtered.gtf --ref-version=1.0.0


#successfully created. 
#You can now specify this reference on the command line:
#cellranger --transcriptome=/fh/fast/jerome_k/nhp_10X/Mmul_8.0.1 

#4 samples
# /shared/ngs/illumina/dstrongi/210608_A00613_0282_AHFWV7DRXY/Unaligned/Project_dstrongi/A19109_GEX
# /shared/ngs/illumina/dstrongi/210608_A00613_0282_AHFWV7DRXY/Unaligned/Project_dstrongi/A19108_GEX
# /shared/ngs/illumina/dstrongi/210608_A00613_0282_AHFWV7DRXY/Unaligned/Project_dstrongi/A18094_GEX
# /shared/ngs/illumina/dstrongi/210608_A00613_0282_AHFWV7DRXY/Unaligned/Project_dstrongi/A18093_GEX

#1. Using sbatch: A19109
lib_dir='/shared/ngs/illumina/dstrongi/210608_A00613_0282_AHFWV7DRXY/Unaligned/Project_dstrongi/A19109_GEX'

sbatch -t 2-0 -c 24 --mem=480000 -p campus-new run_cellranger.sh -i A19109 -d $lib_dir -s A19109_GEX

#fastqc /shared/ngs/illumina/dstrongi/210608_A00613_0282_AHFWV7DRXY/Unaligned/Project_dstrongi/A19109_GEX/A19109_GEX_S4_L002_R1_001.fastq.gz -o ./ -t 24


#2. Using sbatch: A19108
lib_dir='/shared/ngs/illumina/dstrongi/210608_A00613_0282_AHFWV7DRXY/Unaligned/Project_dstrongi/A19108_GEX'
sbatch -t 2-0 -c 24 --mem=480000 -p campus-new run_cellranger.sh -i A19108 -d $lib_dir -s A19108_GEX


#3. Using sbatch: A18094
lib_dir='/shared/ngs/illumina/dstrongi/210608_A00613_0282_AHFWV7DRXY/Unaligned/Project_dstrongi/A18094_GEX'
sbatch -t 2-0 -c 24 --mem=480000 -p campus-new run_cellranger.sh -i A18094 -d $lib_dir -s A18094_GEX


#4. Using sbatch: A18093
lib_dir='/shared/ngs/illumina/dstrongi/210608_A00613_0282_AHFWV7DRXY/Unaligned/Project_dstrongi/A18093_GEX'
sbatch -t 2-0 -c 24 --mem=480000 -p campus-new run_cellranger.sh -i A18093 -d $lib_dir -s A18093_GEX


#########################################################################################
### Part II. mapping reads to GFP
cd /fh/fast/jerome_k/nhp_10X
module load BBMap/38.91-GCC-10.2.0

#1. A19109
lib_dir='/shared/ngs/illumina/dstrongi/210608_A00613_0282_AHFWV7DRXY/Unaligned/Project_dstrongi/A19109_GEX'
for f2 in `ls $lib_dir/*_R2_001.fastq.gz`; do

f1=`echo $f2| sed s/_R2/_R1/`; 
sbatch -t 2-0 -c 24 --mem=480000 -p campus-new run_bbduk_filter.sh -1 $f1 -2 $f2 -s 'A19109_GEX'

done



#2. A19108
lib_dir='/shared/ngs/illumina/dstrongi/210608_A00613_0282_AHFWV7DRXY/Unaligned/Project_dstrongi/A19108_GEX'
for f2 in `ls $lib_dir/*_R2_001.fastq.gz`; do

f1=`echo $f2| sed s/_R2/_R1/`; 
sbatch -t 2-0 -c 24 --mem=480000 -p campus-new run_bbduk_filter.sh -1 $f1 -2 $f2 -s 'A19108_GEX'

done



#3. A18094
lib_dir='/shared/ngs/illumina/dstrongi/210608_A00613_0282_AHFWV7DRXY/Unaligned/Project_dstrongi/A18094_GEX'
for f2 in `ls $lib_dir/*_R2_001.fastq.gz`; do

f1=`echo $f2| sed s/_R2/_R1/`; 
sbatch -t 2-0 -c 24 --mem=480000 -p campus-new run_bbduk_filter.sh -1 $f1 -2 $f2 -s 'A18094_GEX'

done



#4. A18093
lib_dir='/shared/ngs/illumina/dstrongi/210608_A00613_0282_AHFWV7DRXY/Unaligned/Project_dstrongi/A18093_GEX'
for f2 in `ls $lib_dir/*_R2_001.fastq.gz`; do

f1=`echo $f2| sed s/_R2/_R1/`; 
sbatch -t 2-0 -c 24 --mem=480000 -p campus-new run_bbduk_filter.sh -1 $f1 -2 $f2 -s 'A18093_GEX'

done




#########################################################################################
### Part III. Run aggregator to merge libraries
cd /fh/fast/jerome_k/nhp_10X
module load CellRanger/6.0.1

cellranger aggr --id=nhp10x_agg \
                  --csv='./nhp10x_libraries.csv' \
                  --normalize=mapped
                  
                  






