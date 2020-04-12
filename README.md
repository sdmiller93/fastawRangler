# fastawRangler
A tool to extract or remove sequences within a FASTA file based on an input list of sequence IDs.

This script is executable from the bash command line.

## Download the script via:
```
curl -o https://raw.githubusercontent.com/sdmiller93/fastawRangler/master/fastawrangler.R
```
## Help Message
via 

```
./ fastawrangler.R -h
```
```
Arguments:
1.Input fasta file should be a where the sequences headers begin with  a '>' character.
2.Text file with a list of sequence IDs.
3.TRUE/FALSE: Do you want your output to contain only the sequences of IDs in the list files (TRUE and default) or a fasta file with the sequences of IDs removed from the input fasta file (FALSE).
4.TRUE/FALSE: Does your input list of IDs contain wildcard (*) characters? Default = FALSE.
5.Output path and name for your fasta file. Default = out.fasta
```

## Example - without wildcards
input list:
```
AAP30714.1
AAR12990.1
AAV91640.1
ATO98190.1
```
Usage:
```
# to output a fasta file with only the sequences listed in the input list, no wildcards present in list
./fastawrangler.R /path/to/input.fasta /path/to/sequenceidlist.txt TRUE FALSE /path/to/out.fasta
# to output a fasta with the sequences listed in the input list removed from the input fasta file, no wildcards present
./fastawrangler.R /path/to/input.fasta /path/to/sequenceidlist.txt FALSE FALSE /path/to/out.fasta
```

## Example - with wildcards 

input list:
```
AAP30714*
AAR12990*
AAV91640*
ATO98190*
```
Usage:
```
# to output a fasta file with only the sequences listed in the input list, no wildcards present in list
./fastawrangler.R /path/to/input.fasta /path/to/sequenceidlist.txt TRUE TRUE /path/to/out.fasta
# to output a fasta with the sequences listed in the input list removed from the input fasta file, no wildcards present
./fastawrangler.R /path/to/input.fasta /path/to/sequenceidlist.txt FALSE TRUE /path/to/out.fasta
```
## Notes

- This script requires the package "seqinr". 
- Input lists don't require a header but will accept lists with headers. 
  (list is read in with header = FALSE so that lists with headers will return no matches)
- This script also outputs an intermediate FASTA file with all spaces in the headers removed. It is output in the working directory. 
