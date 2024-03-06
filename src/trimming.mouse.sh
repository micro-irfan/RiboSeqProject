#!/bin/bash

module load trimgalore/0.6.7

accession=PRJNA812862
workdir=/home/muhammad555/data_folder/${accession}/
cd /home/muhammad555/data_folder/${accession}/

mkdir -p /home/muhammad555/data_folder/${accession}/trimmed_20

cat sra_list.txt | while read sample
do
  trim_galore --length 20 --trim-n -o trimmed_20/ -j 8 --fastqc ${workdir}/raw_data/${sample}.fastq.gz
done

module load anaconda3
source activate /home/muhammad555/.conda/envs/bbmap

mkdir -p /home/muhammad555/data_folder/${accession}/contaminant_20
cat sra_list.txt | while read sample
do
	bbduk.sh in=/home/muhammad555/data_folder/${accession}/trimmed_20/${sample}_trimmed.fq.gz \
         	 outm=/home/muhammad555/data_folder/${accession}/contaminant_20/${sample}.contaminants.fq \
	 	 out=/home/muhammad555/data_folder/${accession}/contaminant_20/${sample}.20.trimmed.nonribo.fq \
	 	 stats=/home/muhammad555/data_folder/${accession}/contaminant_20/${sample}.ribo.stats \
         	 ref=/home/muhammad555/data_folder/contaminants_reference/mouse_contaminants.fa -Xmx64g

done

cd /home/muhammad555/data_folder/${accession}/contaminant_20
gzip *.fq &
