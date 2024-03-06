
import os

header = [
    'Uniquely mapped reads number',
    'Uniquely mapped reads %', 
    'Average mapped length',
    'Number of reads mapped to multiple loci',
    '% of reads mapped to multiple loci',
    'Number of reads mapped to too many loci',
    '% of reads mapped to too many loci',
    'Number of reads unmapped: too many mismatches',
    '% of reads unmapped: too many mismatches', 
    'Number of reads unmapped: too short',
    '% of reads unmapped: too short',
    'Number of reads unmapped: other', 
    '% of reads unmapped: other',
]

current_directory = os.getcwd()
folder_list = os.listdir(current_directory)
folder_list = [i for i in folder_list if '.py' not in i]

print (folder_list)

result_dict = {}
for sample in folder_list:
    file = f'{sample}/{sample}Log.final.out'
    with open(file, 'r') as f:
        tmp_dict = {}
        for line in f:
            if '|' in line:
                col = line.split('|')
                title = col[0].lstrip()[:-1]
                if title in header:
                    results = col[1].replace('\t','').strip()
                    # print (sample, title, results)
                    tmp_dict[title] = results

        result_dict[sample] = tmp_dict

result_dict = dict(sorted(result_dict.items()))

with open('summary.csv', 'w') as write_file:
    write_file.write('sample,' + ','.join(header) + '\n')

    for sample, results in result_dict.items():
        results_reordered = ','.join([results[h] for h in header])
        print (results_reordered)
        write_file.write(f'{sample},{results_reordered}\n')


    
    