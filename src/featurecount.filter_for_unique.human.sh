module load samtools
module load anaconda3/2022

accession=PRJNA544411
working_dir=/home/muhammad555/data_folder/${accession}
cd ${working_dir}

length=20
folder_name=featurecount_unique_star_analysis_${length}
mkdir -p ${folder_name}

annotationFileExon=/home/cbi/biodata/gencode/GRCh38/gencode.v43.annotation.gtf
annotationFileCDS=/home/muhammad555/data_folder/reference/human/Homo_sapiens.GRCh38.111.gtf
referenceBed=/home/muhammad555/data_folder/reference/human/genes.bed

method=star

cat ${working_dir}/sra_list.txt | while read sample
do
    cd ${working_dir}/${folder_name}
    mkdir -p ${sample}
    cd ${sample}

    bamFileOG=${working_dir}/star_20_Realigned/${sample}/${sample}.${length}Aligned.sortedByCoord.out.bam

    # Remove Unmapped, Secondary Reads
    samtools view -b -F 0x04 -F 0x100 ${bamFileOG} > ${sample}.${method}_${length}.unique.bam
    samtools index ${sample}.${method}_${length}.unique.bam

    bamFile=${working_dir}/${folder_name}/${sample}/${sample}.${method}_${length}.unique.bam

    source activate /home/muhammad555/.conda/envs/rseqc
    bam_stat.py -i ${bamFile} > ${sample}.star.stats.txt &
    conda deactivate

    source activate /home/muhammad555/.conda/envs/subread
    featureCounts -t exon -g gene_id -a ${annotationFileExon} -T 8 -o ${sample}.gene_count.txt ${bamFile}
    featureCounts -a ${annotationFileCDS} -g gene_id -T 8 -o ${sample}.ouput_file_name.3utr.tsv -t three_prime_utr ${bamFile}
    featureCounts -a ${annotationFileCDS} -g gene_id -T 8 -o ${sample}.ouput_file_name.5utr.tsv -t five_prime_utr ${bamFile}
    featureCounts -a ${annotationFileCDS} -g gene_id -T 8 -o ${sample}.ouput_file_name.CDS.tsv -t CDS ${bamFile}
    conda deactivate
done