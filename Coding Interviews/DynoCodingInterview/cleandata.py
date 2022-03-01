from distutils.command.clean import clean
from Bio import SeqIO
# Used to convert the fastq stream into a file handle
from io import StringIO
from gzip import open as gzopen

input_file = "Parvoviridae_full_130_refseq_sequence.gz"
output_file = open("Parvoviridae_full_130_refseq_sequence.txt", "w")

# .gz -> .txt
# cleans the data and outputs it as a txt file
def clean_data(input_file, output_file):
    
    a_file = open(input_file, "rb")

    records = SeqIO.parse(
    # There is actually simpler (thanks @peterjc)
    # StringIO(gzopen("random_10.fastq.gz").read().decode("utf-8")),
    gzopen("Parvoviridae_full_130_refseq_sequence.gz", "rt"),
    format="fasta")

    with output_file as f:
        for record in records:
            f.write(str(record))

    return output_file

clean_data(input_file, output_file)