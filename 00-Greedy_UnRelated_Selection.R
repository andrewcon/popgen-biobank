## Read in the file name from the command line
args = commandArgs(trailingOnly=TRUE)
args = "#.smartrel.rel"

file2readin = args[1]

## read in data file
d = read.table( file2readin , header = FALSE, as.is  = TRUE)

## redefine data structure : 
##  - note the pairs of individuals are already filtered by the kinship estimator
##  - so we do not technically need that paramater any more. 
d = d[, 2:3]

## order the table by frequency
# f = names(sort(table(d[,2]), decreasing = TRUE))

# new = c()
# for(id in f){
# 	w = which( d[,2] %in% id )
# 	new = rbind(new, d[w, ])	
# }

# d = new

## grab all sample ids (NOT UNIQUE)
ids = c(d[,1], d[,2])

## start empty vectors
related_inds = c()
unrelated_inds = c()

## iterate over each row of the 
## data table
for(i in 1:nrow(d)){
	a = d[i, ]
	x = length(grep(a[1], ids))
	y = length(grep(a[2], ids))
	if( x >= y ){ 
		rel = a[1]
		unrel = a[2]
		} else {
			rel = a[2]
			unrel = a[1]
			}
	##########	
	if(!unrel %in% unrelated_inds & !unrel %in% related_inds){
		unrelated_inds = c(unrelated_inds, unrel)
	}
	##########
	if(!rel %in% related_inds & !rel %in% unrelated_inds){
		related_inds = c(related_inds, rel)
	}

}
unrelated_inds = unlist(unrelated_inds)
related_inds = unlist(related_inds)

# length(unrelated_inds)
# length(related_inds)
unrelated_inds = t( sapply(unrelated_inds, function(x){strsplit(x, split = ":")[[1]]}) )
related_inds = t( sapply(related_inds, function(x){strsplit(x, split = ":")[[1]]}) )

## write the individuals to file
if(!is.na(args[2])){
	n = paste0(args[2], "_unrelated_inds_2keep.txt")
} else {
	n = "unrelated_inds_2keep.txt"
}
#unrelated_inds = data.frame(unrelated_inds = unrelated_inds)
write.table(unrelated_inds, file = n, row.names = FALSE, col.names = FALSE, sep = " ", quote = FALSE)

#######
if(!is.na(args[2])){
	n = paste0(args[2], "_related_inds_2keep.txt")
} else {
	n = "related_inds_2keep.txt"
}
#related_inds = data.frame(related_inds = related_inds)
write.table(related_inds, file = n, row.names = FALSE, col.names = FALSE, sep = " ", quote = FALSE)


