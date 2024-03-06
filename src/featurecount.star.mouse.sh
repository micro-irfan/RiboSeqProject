#!/bin/bash

module load samtools
module load anaconda3/2022

accession=PRJNA552552
working_dir=/home/muhammad555/data_folder/${accession}
cd ${working_dir}

length=20
star_file=star_20_Realigned_Retest
folder_name=featurecount_unique_star_analysis_${length}

annotationFileExon=/home/muhammad555/data_folder/reference/mouse/gencode.vM30.annotation.gtf
annotationFileCDS=/home/muhammad555/data_folder/reference/mouse/Mus_musculus.GRCm39.111.no_overlap.gtf
method=star

cat ${working_dir}/sra_list.txt | while read sample
do
    cd ${working_dir}/${folder_name}
    mkdir -p ${sample}
    cd ${sample}

    bamFileOG=${working_dir}/${star_file}/${sample}/${sample}.${length}Aligned.sortedByCoord.out.bam

    # Remove Unmapped, Secondary Reads
    samtools view -b -F 0x04 -F 0x100 -F 0x800 ${bamFileOG} > ${sample}.${method}_${length}.unique.bam
    samtools index ${sample}.${method}_${length}.unique.bam

    bamFile=${working_dir}/${folder_name}/${sample}/${sample}.${method}_${length}.unique.bam
    source activate /home/muhammad555/.conda/envs/subread
    featureCounts -t exon -g gene_id -a ${annotationFileExon} -T 8 -o ${sample}.gene_count.txt ${bamFile}

    featureCounts -a ${annotationFileCDS} -g gene_id -T 8 -o ${sample}.output_file_name.1.3utr.tsv -t three_prime_utr ${bamFile}
    featureCounts -a ${annotationFileCDS} -g gene_id -T 8 -o ${sample}.output_file_name.1.5utr.tsv -t five_prime_utr ${bamFile}
    featureCounts -a ${annotationFileCDS} -g gene_id -T 8 -o ${sample}.output_file_name.1.CDS.tsv -t CDS ${bamFile}
    conda deactivate
done