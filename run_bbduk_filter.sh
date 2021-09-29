#!/bin/bash
echo "Number of cores used: "$SLURM_CPUS_PER_TASK
# echo "Path: "$PATH

while getopts "1:2:s:" opt; do
	case $opt in
		1) r1="$OPTARG"
		;;
		2) r2="$OPTARG"
		;;
		s) samp="$OPTARG"
		;;
		\?) echo "Invalid option -$OPTARG" >&2
    	;;
	esac
done

printf "Input arguments:\n\n"
echo $@

t2=`basename $r2 | sed s/_R2_001/_R2_001_trimmed/`
uf=`basename $r2 | sed s/_R2_001/_R2_001_unmatched/`
mf=`basename $r2 | sed s/_R2_001/_R2_001_matched/`
statf=`basename ${r1%%_R1_001.fastq*}`

printf "Files to be generated:\n\n"
echo $t2
echo $uf
echo $mf
echo $statf

mkdir -p './trimmed_reads/'$samp
mkdir -p './filtered_reads/'$samp
mkdir -p './mapped_reads/'$samp

bbduk.sh in=$r2 out='./trimmed_reads/'$samp'/'$t2 stats='./trimmed_reads/'$samp'/'$statf'_stats.txt' overwrite=TRUE t=$SLURM_CPUS_PER_TASK k=27 hdist=1 edist=0 mink=4 ktrim=r ref=adapters,artifacts,phix qtrim=rl trimq=20 minlength=50 entropy=0.1 entropywindow=50 entropyk=5 qin=33

bbduk.sh in='./trimmed_reads/'$samp'/'$t2 out='./filtered_reads/'$samp'/'$uf  outm='./filtered_reads/'$samp'/'$mf ref='./gfp_ref.fa' k=31 hdist=2 stats='./filtered_reads/'$samp'/'$statf'_stats.txt' overwrite=TRUE t=$SLURM_CPUS_PER_TASK

#remove unmatched reads to save space
rm './filtered_reads/'$samp'/'$uf1 './filtered_reads/'$samp'/'$uf2

#map to gfp ref
bbmap.sh in='./trimmed_reads/'$samp'/'$t2 outm='./mapped_reads/'$statf'_mapped_to_gfp.bam' ref=./gfp_ref.fa overwrite=TRUE t=24