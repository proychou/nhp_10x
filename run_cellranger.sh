#!/bin/bash

#Pavitra Roychoudhury
#Aug 2021

echo "Number of cores used: "$SLURM_CPUS_PER_TASK
# echo "Path: "$PATH

while getopts "i:d:s:" opt; do
	case $opt in
		i) id="$OPTARG"
		;;
		d) dname="$OPTARG"
		;;
		s) samp="$OPTARG"
		;;
		\?) echo "Invalid option -$OPTARG" >&2
    	;;
	esac
done

printf "Input arguments:\n\n"
echo $@

# cellranger count --id $id --fastqs $dname --sample $samp --transcriptome=/fh/fast/jerome_k/nhp_10X/Mmul_8.0.1 

#add hardtrim to R2 to improve transcriptome mapping
cellranger count --id=$id --fastqs=$dname --sample=$samp --transcriptome=/fh/fast/jerome_k/nhp_10X/Mmul_8.0.1 --r2-length=90 --localcores=$SLURM_CPUS_PER_TASK