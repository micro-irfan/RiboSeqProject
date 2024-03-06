#!/usr/bin/bash
module load samtools gmap

date=20240117
accession=PRJNA544411
length=10
workDir=/home/muhammad555/data_folder/${accession}/${date}_gsnap_mapping.${length}

mkdir -p ${workDir}

cat sra_list.adjusted.txt | while read sample
do
	cd ${workDir} 
	mkdir -p ${sample}

	output=${workDir}/${sample}/
	input=/home/muhammad555/data_folder/${accession}/contaminant_${length}/${sample}.20.trimmed.nonribo.fq.gz
	
	cd /home/muhammad555/data_folder/reference/human

	gsnap -D ./ -d GRCh38_gmap_index --gunzip -A sam --failed-input=${output}/${sample}.failed.sam -t 16 ${input} > ${output}/${sample}_output.sam
	
	cd ${output}
	samtools view -@ 16 -F 4 -S -b ${sample}_output.sam > ${sample}_output.bam
	samtools sort ${sample}_output.bam -o ${sample}_sorted_output.bam -@ 16
	samtools index ${sample}_sorted_output.bam
	rm ${sample}_output.bam
done 
