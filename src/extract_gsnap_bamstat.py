
import os

headers = {
    'mapq >= mapq_cut (unique)' : 'Uniquely mapped reads number',
    'mapq < mapq_cut (non-unique)' : 'Number of reads mapped to multiple loci',    
}

current_directory = os.getcwd()
folder_list = os.listdir(current_directory)
folder_list = [i for i in folder_list]

print (folder_list)

results_dict = {}
for sample in folder_list:
    if '.csv' in sample: continue
    if '.py' in sample: continue
    file = f'{sample}/{sample}.20.gsnap.stats.txt'
    with open(file, 'r') as f:
        sample = file.split('.')[0].split('/')[0]
        tmp = {}
        for line in f: 
            if not line.startswith('mapq'): continue
            line = line.strip('\n').split(':')
            col = line[0].rstrip()
            count = line[1].strip()
            tmp[col] = count

        results_dict[sample] = tmp  

results_dict = dict(sorted(results_dict.items()))


write_file = open('summary_gsnap.csv', 'w')
write_file.write('sample,Uniquely mapped reads number,Number of reads mapped to multiple loci\n')

for sample, results in results_dict.items():
    line = f'{sample},{results["mapq >= mapq_cut (unique)"]},{results["mapq < mapq_cut (non-unique)"]}\n'
    write_file.write(line)
