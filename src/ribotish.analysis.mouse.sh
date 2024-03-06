#!/usr/bin/bash

module load anaconda3/2022
module load samtools
source activate /home/muhammad555/.conda/envs/ribotish

mouse_gtf=/home/muhammad555/data_folder/reference/mouse/gencode.vM30.annotation.gtf
length=20
accession=PRJNA552552

workdir=/home/cbi/projects/20230223_Bernett_riboseq_trial_data/irfan/${accession}/star_${length}
cat sra_list.txt | while read sample
do
	cd ${workdir}/${sample}
	bamFile=${sample}.${length}Aligned.sortedByCoord.out.bam
	samtools index ${bamFile}
	ribotish quality -p 16 -b ${bamFile} -g ${mouse_gtf} -v
done
