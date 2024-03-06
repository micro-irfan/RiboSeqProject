#!/usr/bin/bash

module load samtools
module load anaconda3/2022
source activate /home/muhammad555/.conda/envs/subread

accession=PRJNA544411
working_dir=/home/muhammad555/data_folder/${accession}
cd ${working_dir}

annotationFile=/home/cbi/biodata/gencode/GRCh38/gencode.v43.annotation.gtf

for dir in star_*; do
    if [ -d "$dir" ]; then
    folder_number="${dir##*_}"

    skip_folders=("wContaminants")

    if [[ " ${skip_folders[@]} " =~ " $folder_number " ]]; then
        # if [ "$folder_number" != 'wContaminants' ]; then
        echo "Skipping folder $dir (Number: $folder_number)"
        continue  # Skip the rest of the loop and move to the next iteration
    fi
    
    echo "Processing $dir, Min Read Length: $folder_number"
       
    mkdir -p ${working_dir}/feature_count_${folder_number}
    cat ${working_dir}/sra_list.txt | while read sample
    do
        star_2=("20" "25")
        star_1=("10" "15")

        ## Quirky Mistake Lol
        if [[ " ${star_1[@]} " =~ " $folder_number " ]]; then
            bamFile=${working_dir}/${dir}/${sample}/${sample}.${folder_number}Aligned.sortedByCoord.out.bam
        elif [[ " ${star_2[@]} " =~ " $folder_number " ]]; then
            bamFile=${working_dir}/${dir}/${sample}/${sample}Aligned.sortedByCoord.out.bam
        fi

        mkdir -p ${working_dir}/feature_count_${folder_number}/${sample}/
        cd ${working_dir}/feature_count_${folder_number}/${sample}/

        samtools view -h ${bamFile} | awk '{ if ( substr($0,1,1) == "@" || (length($10) >= 28 && length($10) <= 37)) {print $0} }' | samtools view -b > ${sample}_star_28to37.bam
        samtools view -h ${bamFile} | awk '{ if ( substr($0,1,1) == "@" || (length($10) < 28)) {print $0} }' | samtools view -b > ${sample}_star_le27.bam
        samtools view -h ${bamFile} | awk '{ if ( substr($0,1,1) == "@" || (length($10) > 37)) {print $0} }' | samtools view -b > ${sample}_star_ge38.bam

        samtools sort -@ 8 -o ${sample}_star_28to37.sorted.bam ${sample}_star_28to37.bam
        samtools index -M -b -@ 8 ${sample}_star_28to37.sorted.bam

        samtools sort -@ 8 -o ${sample}_star_le27.sorted.bam ${sample}_star_le27.bam
        samtools index -M -b -@ 8 ${sample}_star_le27.sorted.bam

        samtools sort -@ 8 -o ${sample}_star_ge38.sorted.bam ${sample}_star_ge38.bam
        samtools index -M -b -@ 8 ${sample}_star_ge38.sorted.bam

        featureCounts -t exon -g gene_id -a ${annotationFile} -T 8 -o ${sample}.gene_count.txt ${bamFile}
        featureCounts -t exon -g gene_id -a ${annotationFile} -T 8 -o ${sample}.28to37.gene_count.txt ${sample}_star_28to37.sorted.bam
        featureCounts -t exon -g gene_id -a ${annotationFile} -T 8 -o ${sample}.le27.gene_count.txt ${sample}_star_le27.bam
        featureCounts -t exon -g gene_id -a ${annotationFile} -T 8 -o ${sample}.ge38.gene_count.txt ${sample}_star_ge38.bam

    done
    fi
done
