#!/usr/bin/bash

module load star

accession=PRJNA756018

gtf_file=/home/muhammad555/data_folder/STAR_Reference/gencode.v43.annotation.gtf
genome_dir=/home/muhammad555/data_folder/STAR_Reference/hg38_index/

working_dir=/home/muhammad555/data_folder/${accession}
cd ${working_dir}

length=20

folder_name=star_${length}
mkdir -p ${folder_name}

cat sra_list.txt | while read sample
do
    fastq=/home/cbi/projects/20230223_Bernett_riboseq_trial_data/irfan/${accession}/contaminant_${length}/${sample}.${length}.trimmed.nonribo.fq.gz
    
    cd /home/muhammad555/data_folder/${accession}/${folder_name}
    mkdir -p ${sample}
    cd ${sample}

    STAR --genomeDir $genome_dir \
             --sjdbGTFfile $gtf_file \
             --readFilesIn $fastq \
             --runThreadN 16 \
             --alignEndsType EndToEnd \
             --outSAMtype BAM SortedByCoordinate \
             --readFilesCommand zcat \
             --outFileNamePrefix ${sample}.${length} \
             --seedSearchStartLmax ${length} \
             --outSAMunmapped Within \
             --outFilterMismatchNoverLmax 0.05 \
             --outSAMattributes All 1>Test-STAR.o 2>Test-STAR.e

done

