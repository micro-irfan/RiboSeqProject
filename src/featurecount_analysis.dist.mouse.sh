#!/usr/bin/bash

module load samtools
module load anaconda3/2022

accession=PRJNA552552
working_dir=/home/muhammad555/data_folder/${accession}
cd ${working_dir}

mkdir -p feature_count_analysis

annotationFile=/home/muhammad555/data_folder/reference/mouse/gencode.vM30.annotation.gtf
referenceBed=/home/muhammad555/data_folder/reference/mouse/genes_mouse.bed

cat ${working_dir}/sra_list.txt | while read sample
do
    cd ${working_dir}/feature_count_analysis
    mkdir -p ${sample}
    cd ${sample}

    bamFile=${working_dir}/star_20/${sample}/${sample}.20Aligned.sortedByCoord.out.bam

    samtools view -h ${bamFile} | awk '{ if ( substr($0,1,1) == "@" || (length($10) >= 28 && length($10) <= 37)) {print $0} }' | samtools view -b > ${sample}_star_28to37.bam
    samtools view -h ${bamFile} | awk '{ if ( substr($0,1,1) == "@" || (length($10) < 28)) {print $0} }' | samtools view -b > ${sample}_star_le27.bam
    samtools view -h ${bamFile} | awk '{ if ( substr($0,1,1) == "@" || (length($10) > 37)) {print $0} }' | samtools view -b > ${sample}_star_ge38.bam

    samtools sort -@ 8 -o ${sample}_star_28to37.sorted.bam ${sample}_star_28to37.bam
    samtools index -M -b -@ 8 ${sample}_star_28to37.sorted.bam

    samtools sort -@ 8 -o ${sample}_star_le27.sorted.bam ${sample}_star_le27.bam
    samtools index -M -b -@ 8 ${sample}_star_le27.sorted.bam

    samtools sort -@ 8 -o ${sample}_star_ge38.sorted.bam ${sample}_star_ge38.bam
    samtools index -M -b -@ 8 ${sample}_star_ge38.sorted.bam

    source activate /home/muhammad555/.conda/envs/subread
    
    featureCounts -t exon -g gene_id -a ${annotationFile} -T 8 -o ${sample}.gene_count.txt ${bamFile}
    featureCounts -t exon -g gene_id -a ${annotationFile} -T 8 -o ${sample}.28to37.gene_count.txt ${sample}_star_28to37.sorted.bam
    featureCounts -t exon -g gene_id -a ${annotationFile} -T 8 -o ${sample}.le27.gene_count.txt ${sample}_star_le27.sorted.bam
    featureCounts -t exon -g gene_id -a ${annotationFile} -T 8 -o ${sample}.ge38.gene_count.txt ${sample}_star_ge38.sorted.bam
    
    conda deactivate

    source activate /home/muhammad555/.conda/envs/rseqc

    bam_stat.py -i ${bamFile} > ${sample}.star.stats.txt &
    read_distribution.py -i ${bamFile} -r ${referenceBed} > ${sample}.star.readdist.txt 
    
    bamFile1=${sample}_star_28to37.sorted.bam
    bam_stat.py -i ${bamFile1} > ${sample}.28to37.star.stats.txt &
    read_distribution.py -i ${bamFile1} -r ${referenceBed} > ${sample}.28to37.star.readdist.txt 

    bamFile2=${sample}_star_le27.sorted.bam
    bam_stat.py -i ${bamFile2} > ${sample}.le27.star.stats.txt &
    read_distribution.py -i ${bamFile2} -r ${referenceBed} > ${sample}.le27.star.readdist.txt 

    bamFile3=${sample}_star_ge38.sorted.bam
    bam_stat.py -i ${bamFile3} > ${sample}.ge38.star.stats.txt &
    read_distribution.py -i ${bamFile3} -r ${referenceBed} > ${sample}.ge38.star.readdist.txt 

    conda deactivate

    rm ${sample}_star_28to37.bam
    rm ${sample}_star_le27.bam
    rm ${sample}_star_ge38.bam

done