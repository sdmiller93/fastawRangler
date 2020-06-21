#!/usr/bin/env Rscript



# This is the FASTAwRangler script to be executed from the command line. 
# The script takes 5 arguments, 2 which are necessary for function
# 1) input fasta file 2) text file with seq IDs to remove or extract with
# or without wildcards * 3) optional TRUE/FALSE to note whether wildcards
# are present in the list of ids 4) optional TRUE/FALSE to to extract 
# sequences (default) or remove the sequences from the fasta file

########################################################################


# this variable can be turned on to print/track any errors in the script
# will turn off when script is ready to be used by others
error_checking = TRUE


# print message when script is invoked to let them know there is a help file
message("This script takes an input fasta file and a list of ids ",
	"with or without wildcards and extracts or removes those ",
	"sequences from the fasta file. For more information type '-h'.")

################## argument/input section ##############################

# all arguments accepted not just ones following this line
args = commandArgs(trailingOnly = TRUE)

if (error_checking) {
message(sprintf("first arg %s", args[1L]))

message(sprintf("second arg %s", args[2L]))

message(sprintf("third arg %s", args[3L]))

message(sprintf("fourth arg %s", args[4L]))

message(sprintf("fifth arg %s", args[5L]))
}

library("seqinr")
################## help message section ################################


# if the first argument passed is '-h' print the help section

if (args[1L] == "-h"){
	
	message("Arguments:")
	message("1.Input fasta file should be a where the sequences headers ",
	"begin with  a '>' character.")                                   
	message("2.Text file with a list of sequence IDs.")
	message("3.TRUE/FALSE: Do you want your output to contain only the ", 
	"sequences of IDs in the list files (TRUE and default) or a fasta file",
	" with the sequences of IDs removed from the input fasta file (FALSE).")
	message("4.TRUE/FALSE: Does your input list of IDs contain wildcard",
	" (*) characters? Default = FALSE.")
	message("5.Output path and name for your fasta file. Default = out.fasta")
	
	# stop execution of script
	stop()
}

########################################################################
########################## input checks ################################
########################################################################


##################### fasta file input check ###########################

# first argument is to give fasta file input, if no first argument is given, 
# stop code halts process
if (is.na(args[1L])) {
	
	stop("missing input fasta file")
	
} else {
	
	# if fasta file is given as first argument, this sets fasta file to the 
	# first argument passed by user
	fastafilename = args[1L]
	
	# load in fasta file (first argument from user) and check to make sure it 
	# is indeed a fasta file
	# read in fasta file as tab delimited file
	fasta <- read.delim(file = fastafilename, as.is = TRUE, header = FALSE)
	
	# check to make sure first line of fasta file starts with a ">" character
	firstline <- fasta[1,]
	
	# if it does start with ">" then progress, if not error out 
	if (startsWith(firstline, ">") == FALSE){
		stop("Your fasta file does not seem to be a fasta file")
	}
}

################## seq id list check ###################################

# second arg passed by user should be list of seq ids
# check to make sure the user supplied that information
if (is.na(args[2L])){
	
	stop("missing input list of sequence ids")
	
} else {
	# if argument by user is given, then set the id list variable to that
	# argument 
	idlist = args[2L]
}


##################### extract or remove seq check ######################

# if user keepsseqs = TRUE then they want to pull out the seqs for the ids
# that were given, if FALSE, then they want the seqs for the ids removed
# from the input fasta
if (is.na(args[3L])){
	# by default, this program will extract the sequences from the fasta
	# by the ids given
	keepseqs = TRUE	
	
} else {
	# make it FALSE to remove seqs from FASTA file and accepting the 
	# arg passed to it from the command line
	keepseqs = args[3L]
	
}

if (error_checking) {message("Starting work: wildcard")}

##################### wildcard input check #############################

# are wildcards * used, assume that they are not (wildcard = FALSE)
if (is.na(args[4L])){
	# if no argument given, assume wildcards are not used and treat the
	# id list as one with full sequence ids
	wildcard = FALSE
} else {
	wildcard = args[4L] 
	
}


#################### output file name check ############################

# check to see if user passed an argument for the output file name
if (is.na(args[5L])){
	# if none given, default file name is "out.fasta" in working directory
	outfile = "out.fasta"
} else {
	# otherwise, name the output file what user input
	outfile = args[5L]
}

########################################################################
# remove spaces in fasta header
for (i in 1:nrow(fasta)){
		
	# store the row info
	row <- fasta[i,1]
	
	# if statement for ">" character
	if (startsWith(row, ">") == TRUE){
		
		# replace spaces in fasta header to strings separated with ;
		newline <- gsub("\\s", ";", row)
		fasta[i,] <- newline
	}
}

print("outputting fasta file with spaces in headers removed to working directory")

# write out fasta without header spaces
write.table(fasta, file = "fasta_nospaces.fasta", quote = FALSE, row.names = FALSE, col.names = FALSE)

########################################################################
############### working: wildcard T/F ##################################
########################################################################

# if wildcard = true, go through steps to get all sequence names that
# belong to it
if (wildcard == TRUE){
	
	# read in the list with seqids & * wildcards as tab delimited file
	wildcard_query <- read.delim(file = idlist, sep = "\t", as.is = TRUE, header = FALSE)
		
	# since fasta file was read in as a tab delim file and not fasta file, 
	# need to get the sequence ids in the fasta file without the ">" character
	for (i in 1:nrow(fasta)){
	
		# store the line of the fasta file
		line <- fasta[i,]
		
		# determine if it is a seqid line or seq line
		if (startsWith(line, ">") == TRUE){
			
			# if seqid line, get seqid without the ">" character
			ids <- strsplit(line, fixed = TRUE, ">")
			newid <- ids[[1]][2]
			
			# replace all seqids in the fasta file with the ids without the ">" character
			fasta[i,] <- newid
	
		}
	}


	# get a list of the wildcard ids without the * character		
	for (i in 1:nrow(wildcard_query)){

		# get the first seqid in the list
		id <- wildcard_query[i,]
	
		# remove the wildcard character
		split <- strsplit(id, fixed = TRUE, "*")
		seqid <- split[[1]][1]
			
		# replace list contents with IDs without the "*"
		wildcard_query[i,] <- seqid
			
	}

	# initialize the list of full sequence ids
	names_final <- c()			


	# for each sequence id (without *) find the full sequence ids in the fasta file
	for (j in 1:nrow(wildcard_query)){
		
		id <- wildcard_query[j,]
		names <- (fasta[which(startsWith(fasta[,1], id)), ])
		names_final <- append(names_final, names)
		}

} else {
		
		# if wildcards are not used, then we can read in the input list
		# without much manipulation 

		# read in the list with seqids as tab delimited file
		temp_names_final <- read.delim(file = idlist, sep = "\t", as.is = TRUE, header = FALSE)
		# force data frame structure
		names_final <- temp_names_final$V1
		
} 


# print first two seq ids 
if (error_checking){message(paste(names_final[1], names_final[2], sep="\n"))} 



########################################################################
################### working: keep/remove seqs ##########################
########################################################################

# if true, use seqinr to extract the sequences by id easily
if (error_checking){ message("Starting work: extracting or removing")}

# load in fasta file via seqinr
fasta <- read.fasta(file = "fasta_nospaces.fasta", as.string = FALSE, forceDNAtolower = FALSE)

if (keepseqs == TRUE){
		
	# using seqinr create a fasta file that contains only the seqs with IDs stored in names_final
	newfasta <- fasta[names(fasta) %in% names_final]

	write.fasta(as.list(newfasta), names_final, outfile, open = "w", nbchar = 1000000)
		
	# load in fasta file via seqinr
	fasta <- read.fasta(file = "fasta_nospaces.fasta", as.string = FALSE, forceDNAtolower = FALSE)

# if false, remove them from the fasta file 
}else{
	for (i in 1:length(names_final)){
		fullid <- names_final[i]
		
		newfasta <- subset(fasta, !(V1 %in% c(names_final)))
		
		
		

		
	
	# using seqinr create a fasta file where the seqs are those in the input fasta file 
	# and not listed in the input ID list stored in names_final
	# newfasta <- fasta[!(names(fasta) %in% names_final)]

	# write.fasta(as.list(newfasta), names_final, outfile, open = "w", nbchar = 1000000)
		
}

if (error_checking){message("Thank you for using fastawRangler!")}
