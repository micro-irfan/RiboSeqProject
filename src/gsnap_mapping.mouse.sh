#!/usr/bin/bash
module load samtools gmap

date=20240203
accession=PRJNA552552
length=20
workDir=/home/muhammad555/data_folder/${accession}/${date}_gsnap_mapping.${length}

mkdir -p ${workDir}

cat sra_list.adjusted.txt | while read sample
do
	cd ${workDir} 
	mkdir -p ${sample}

	output=${workDir}/${sample}/
	input=/home/muhammad555/data_folder/${accession}/contaminant_${length}/${sample}.${length}.trimmed.nonribo.fq.gz
	
	cd /home/muhammad555/data_folder/reference/mouse

	gsnap -D ./ -d GRCm39_gmap_index --gunzip -A sam --failed-input=${output}/${sample}.failed.fastq -t 16 ${input} > ${output}/${sample}_output.sam
	
	cd ${output}
	
	samtools view -@ 16 -F 4 -S -b ${sample}_output.sam > ${sample}_output.bam
	samtools sort ${sample}_output.bam -o ${sample}_sorted_output.bam -@ 16
	samtools index ${sample}_sorted_output.bam
	
	rm ${sample}_output.bam
	rm -f ${sample}_output.sam
    rm -f ${sample}.failed.fastq.1
    rm -f ${sample}.failed.fastq.2

	bamFile=${output}/${sample}_sorted_output.bam
	
	module load anaconda3
    source activate /home/muhammad555/.conda/envs/rseqc
    bam_stat.py -i ${bamFile} > ${sample}.${length}.gsnap.passed.stats.txt &
    read_distribution.py -i ${bamFile} -r ${referenceBed} > ${sample}.${folder_number}.gsnap.readdist.txt 
    conda deactivate 

done 
