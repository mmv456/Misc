from Bio import SeqIO
# Used to convert the fastq stream into a file handle
from io import StringIO
from gzip import open as gzopen
import hashlib

input_filename = "Parvoviridae_full_130_refseq_sequence.gz"

# .gz -> String
# creates a hash of the file for testing purposes
def create_hash(input_file):
    fileMD5Hash =""

    md5_hash = hashlib.md5()

    a_file = open(input_filename, "rb")
    content = a_file.read()
    md5_hash.update(content)

    digest = md5_hash.hexdigest()
    fileMD5Hash = digest

    return fileMD5Hash

# the hash variable below returns "b08f2e84ba3e24be7b540331c8741ae1"
hash = create_hash(input_filename)