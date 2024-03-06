
import os 

current_directory = os.getcwd()
sample_list = os.listdir(current_directory)
sample_list = [i for i in sample_list if '.py' not in i]


headers = [ 'Unassigned_MultiMapping',
            'Unassigned_NoFeatures',
            'Unassigned_Ambiguity' ]

results_dict = {}

for sample in sample_list:
    if len(sample.split('.')) > 1: continue
    if '.py' in sample: continue
    results = {}
    
    suffixes = { 'exons' : 'gene_count.txt.summary' ,
                 'CDS' : 'output_file_name.1.CDS.tsv.summary',
                 '5utr' : 'output_file_name.1.5utr.tsv.summary',
                 '3utr' : 'output_file_name.1.3utr.tsv.summary',
                 }

    for region, suffix in suffixes.items():
        file = f'{sample}/{sample}.{suffix}'

        with open(file, 'r') as f:
            next(f)
            for line in f:
                line = line.strip().split('\t')
                header = line[0]
                if header == 'Assigned':
                    results[region] = line[1]

                if region != 'exons': break
                if header not in headers: continue

                results[f'exons_{header.lower()}'] = line[1]

    results_dict[sample] = results

print (results_dict)

results_dict = dict(sorted(results_dict.items()))

new_headers = results_dict[sample].keys()
new_headers_to_write = f"sample,{','.join(new_headers)}\n"

write_file = open(f'featurecount_summary.1.csv', 'w')
write_file.write(new_headers_to_write)

for sample, results in results_dict.items():
    line = ",".join([results[h] for h in new_headers])
    write_file.write(f'{sample},{line}\n')

write_file.close()

