#!/usr/bin/env python3

import os 
import gzip

suffix='.20.trimmed.nonribo.fq.gz'

current_directory = os.getcwd()
fastq_list = os.listdir(current_directory)
fastq_list = [i for i in fastq_list if suffix in i]


def readfq(fp, gzipped = True): # this is a generator function
    last = None # this is a buffer keeping the last unprocessed line
    while True: # mimic closure; is it a bad idea?
        if not last: # the first record or a record following a fastq
            for l in fp: # search for the start of the next record
                l = l.decode() if gzipped else l
                if l[0] in '>@': # fasta/q header line
                    last = l[:-1] # save this line
                    break
        if not last: break
        name, seqs, last = last[1:].partition(" ")[0], [], None
        for l in fp: # read the sequence
            l = l.decode() if gzipped else l
            if l[0] in '@+>':
                last = l[:-1]
                break
            seqs.append(l[:-1])
        if not last or last[0] != '+': # this is a fasta record
            yield (name, ''.join(seqs), None) # yield a fasta record
            if not last: break
        else: # this is a fastq record
            seq, leng, seqs = ''.join(seqs), 0, []
            for l in fp: # read the quality
                l = l.decode() if gzipped else l
                seqs.append(l[:-1])
                leng += len(l) - 1
                if leng >= len(seq): # have read enough quality
                    last = None
                    yield (name, seq, ''.join(seqs)) # yield a fastq record
                    break
            if last: # reach EOF before reading enough quality
                yield (name, seq, None) # yield a fasta record instead
                break


lower = 1
upper = 51

write_file = 'output.summary.csv'
write_file = open(write_file, 'w')
write_file.write(f'sampleID,{",".join([str(i) for i in range(lower, upper + 1)])},total\n')

gzipped = True
for path in fastq_list:
    print (f'Analyzing {path}')
    sample = path.replace(suffix,'')
    read_count = 0
    len_dist   = {i:0 for i in range(lower,upper + 1)}
    open_fn = gzip.open
    with open_fn(path) as fin:
        for c, (name, seq, _) in enumerate(readfq(fin, gzipped)):
            seq_len = len(seq)
            len_dist[seq_len] += 1
            read_count += 1
            if c % 1000000 == 0: 
                print (f'Analyzed read count {c}')

    percent = {i:round((count/read_count) * 100, 5) for i,count in len_dist.items()}
    percent = ','.join([str(i) for _,i in percent.items()])
    write_file.write(f'{sample},{percent},{read_count}\n')

