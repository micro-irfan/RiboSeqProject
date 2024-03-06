import os
import zipfile

current_directory = os.getcwd()
zip_list = os.listdir(current_directory)
zip_list = [i for i in zip_list if '.zip' in i]

def fetch_read_count(count_dict, sample, line):
    count_dict[sample] = int(line.split('\t')[1])

count_dict = {}
for zip_file_path in zip_list:
    sample = zip_file_path.split('_')[0]
    with zipfile.ZipFile(zip_file_path, 'r') as zip_ref:
        file_to_open = f'{sample}_trimmed_fastqc/fastqc_data.txt'
        with zip_ref.open(file_to_open) as file_in_zip:
            # Print or process the contents as needed
            for line in file_in_zip:
                line = line.decode('utf-8')
                if 'Total Sequences' in line: 
                    fetch_read_count(count_dict, sample, line)

count_dict = dict(sorted(count_dict.items()))
for k,v in count_dict.items():
    print (f'{k},{v}')