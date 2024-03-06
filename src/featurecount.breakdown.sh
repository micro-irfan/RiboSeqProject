#!/usr/bin/bash

module load anaconda3/2022
source activate /home/muhammad555/.conda/envs/subread

accession=PRJNA515538
working_dir=/home/muhammad555/data_folder/${accession}
cd ${working_dir}

length=20
folder_name=feature_count_breakdown_${length}

mkdir -p ${folder_name}

annotationFile=/home/muhammad555/data_folder/reference/human/Homo_sapiens.GRCh38.111.gtf

cat ${working_dir}/sra_list.txt | while read sample
do
    cd ${working_dir}/${folder_name}
    mkdir -p ${sample}
    cd ${sample}

    bamFile=${working_dir}/star_20/${sample}/${sample}.${length}Aligned.sortedByCoord.out.bam
    
    featureCounts -a ${annotationFile} -g gene_id -T 8 -o ${sample}.ouput_file_name.3utr.tsv -t three_prime_utr ${bamFile}
    featureCounts -a ${annotationFile} -g gene_id -T 8 -o ${sample}.ouput_file_name.5utr.tsv -t five_prime_utr ${bamFile}
    featureCounts -a ${annotationFile} -g gene_id -T 8 -o ${sample}.ouput_file_name.CDS.tsv -t CDS ${bamFile}
done