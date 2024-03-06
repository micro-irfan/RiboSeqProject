import os
from collections import namedtuple

placeholder = namedtuple('placeholder', 'ribo mRNA tRNA clean clean_count')

current_directory = os.getcwd()
stats_list = os.listdir(current_directory)
stats_list = [i for i in stats_list if '.stats' in i]

stats_dict = {}
for stats in stats_list:
	sample = stats.split('.')[0]
	with open(stats, 'r') as f:
		tRNA_count = 0
		ribo = 0
		mRNA = 0
		for line in f:
			if '#Total' in line:
				total = int(line.split('\t')[1])
				clean_count = total
				continue
			if '#' in line:
				continue

			line = line.split('\t')
			contig = line[0]
			count = int(line[1])
			percent = float(line[2].replace('%',''))

			if 'BK000964.3' in contig:
				ribo = percent
				clean_count -= count
				continue

			if 'NC_005089.1' in contig:
				mRNA = percent
				clean_count -= count
				continue

			tRNA_count += count

		clean_count -= tRNA_count
		clean_percent = round((clean_count/total)*100, 5)
		tRNA_percent = round((tRNA_count/total)*100, 5)

		stats_dict[sample] = placeholder(ribo, mRNA, tRNA_percent, clean_percent, clean_count)

stats_dict = dict(sorted(stats_dict.items()))
with open('summary_stats.csv', 'w') as write_file:
	for k,v in stats_dict.items():
		write_file.write(f'{k},{str(v.clean_count)},{str(v.clean)},{str(v.ribo)},{str(v.tRNA)},{str(v.mRNA)}\n')


