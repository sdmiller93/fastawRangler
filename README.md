# fastawRangler
A tool to extract or remove sequences within a FASTA file based on an input list of sequence IDs.

This script is executable from the bash command line.

Given a FASTA file and input list of sequence IDs, this tool can do one of two things:
1. Output a FASTA file with the sequences of the input IDs.
-or-
2. Output a FASTA file with the sequences of the input IDs removed from the input FASTA file.

## Download the script via:
```
curl -o https://raw.githubusercontent.com/sdmiller93/fastawRangler/master/fastawrangler.R
```
## Help Message
via 

```
./fastawrangler.R -h
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
- If the IDs in your input list do not exactly match headers in your input FASTA file, please use the wildcard option and be sure your IDs include the wildcard character (*).
- Input lists don't require a header but will accept lists with headers. 
  (list is read in with header = FALSE so that lists with headers will return no matches)
- This script also outputs an intermediate FASTA file with all spaces in the headers removed. It is output in the working directory. 
- Sample datasets can be located in the "Example/" directory. Two input lists: lista = no wildcards, listb = wildcards, and the sample FASTA file.

## Troubleshooting 
In the future, I will try to incorporate these checks in the code to print a help message if encountered.

```
./fastawrangler.R ./testfasta.fasta ./listb.txt FALSE FALSE ./tmp2.fasta
This script takes an input fasta file and a list of ids with or without wildcards and extracts or removes those sequences from the fasta file. For more information type '-h'.
first arg ./testfasta.fasta
second arg ./listb.txt
third arg FALSE
fourth arg FALSE
fifth arg ./tmp2.fasta
Starting work: wildcard
[1] "outputting fasta file with spaces in headers removed to working directory"
TRINITY_DN25698_c0_g*
TRINITY_DN29861_c0_g*
Starting work: extracting or removing
Error in paste(">", name, sep = "") : object 'full_ids' not found
Calls: write.fasta ... lapply -> FUN -> write.oneseq -> writeLines -> paste
Execution halted
```

This error is a result of using an input list with wildcards present but setting the fourth flag to FALSE thereby stating that wildcards are not present. A similar error will occur if you input a list without wildcards but the fourth flag is set to TRUE. 
