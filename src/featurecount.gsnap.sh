#!/bin/bash

module load samtools
module load anaconda3/2022

accession=PRJNA756018
working_dir=/home/muhammad555/data_folder/${accession}
cd ${working_dir}

length=20
folder_name=featurecount_unique_gsnap_analysis_${length}

mkdir -p ${working_dir}/${folder_name}

annotationFileExon1=/home/cbi/biodata/gencode/GRCh38/gencode.v43.annotation.gtf
annotationFileExon2=/home/muhammad555/data_folder/reference/human/Homo_sapiens.GRCh38.111.gtf
annotationFileCDS=/home/muhammad555/data_folder/reference/human/Homo_sapiens.GRCh38.111.no_overlap.gtf
referenceBed=/home/muhammad555/data_folder/reference/human/genes.bed

method=gsnap

cat ${working_dir}/fibroblast.txt | while read sample
do
    cd ${working_dir}/20240217_gsnap_mapping.20/${sample}/
    bamFileOG=${working_dir}/20240217_gsnap_mapping.20/${sample}/${sample}_sorted_output.bam
    # samtools index ${bamFileOG}

    cd ${working_dir}/${folder_name}
    mkdir -p ${sample}
    cd ${sample}

    # Remove Unmapped, Secondary Reads
    # samtools view -b -F 0x04 -F 0x100 -F 0x800 ${bamFileOG} > ${sample}.${method}_${length}.unique.bam
    # samtools index ${sample}.${method}_${length}.unique.bam
    # samtools view -F 256 ${bamFileOG} | grep -P "NH:i:1\t" | cut -f1 > ${sample}.gsnap.true.unique.txt &
    # samtools view -f 256 ${bamFileOG} | cut -f1 | LC_ALL=C sort | uniq  > ${sample}.gsnap.multimapped.txt &

    bamFile=${working_dir}/20240217_gsnap_mapping.20/${sample}/${sample}/${sample}.${method}_${length}.unique.bam
    
    source activate /home/muhammad555/.conda/envs/subread
    featureCounts -t exon -g gene_id -a ${annotationFileExon1} -T 8 -o ${sample}.gene_count.txt ${bamFile}
    featureCounts -t exon -g gene_id -a ${annotationFileExon2} -T 8 -o ${sample}.output_file_name.1.exon.tsv ${bamFile}
    featureCounts -a ${annotationFileCDS} -g gene_id -T 8 -o ${sample}.output_file_name.1.3utr.tsv -t three_prime_utr ${bamFile}
    featureCounts -a ${annotationFileCDS} -g gene_id -T 8 -o ${sample}.output_file_name.1.5utr.tsv -t five_prime_utr ${bamFile}
    featureCounts -a ${annotationFileCDS} -g gene_id -T 8 -o ${sample}.output_file_name.1.CDS.tsv -t CDS ${bamFile}
    conda deactivate
done