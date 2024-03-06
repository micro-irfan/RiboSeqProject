#!/usr/bin/bash


accession=PRJNA544411
working_dir=/home/muhammad555/data_folder/${accession}
cd ${working_dir}

referenceBed=/home/muhammad555/data_folder/reference/human/genes.bed

for dir in star_*; do
    if [ -d "$dir" ]; then
    folder_number="${dir##*_}"

    cat ${working_dir}/sra_list.txt | while read sample
    do
        cd ${working_dir}/${dir}/${sample}

        star_2=("20" "25")
        star_1=("10" "15")

        ## Quirky Mistake Lol
        if [[ " ${star_1[@]} " =~ " $folder_number " ]]; then
            bamFile=${working_dir}/${dir}/${sample}/${sample}.${folder_number}Aligned.sortedByCoord.out.bam
        elif [[ " ${star_2[@]} " =~ " $folder_number " ]]; then
            bamFile=${working_dir}/${dir}/${sample}/${sample}Aligned.sortedByCoord.out.bam
        else
            bamFile=${working_dir}/${dir}/${sample}/${sample}.20Aligned.sortedByCoord.out.bam
        fi

        source activate /home/muhammad555/.conda/envs/rseqc
        bam_stat.py -i ${bamFile} > ${sample}.${folder_number}.star.stats.txt &
        read_distribution.py -i ${bamFile} -r ${referenceBed} > ${sample}.${folder_number}.star.readdist.txt 
        conda deactivate
    done
    fi
done