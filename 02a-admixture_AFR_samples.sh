###################################################
## ON HPC
###################################################

## add Admixture module to environment
module add apps/admixture-1.3.0

## add Plink2 module to environment
module add apps/plink2

## add R to environment
module add languages/R-3.4.1-ATLAS

###########################
## Prepare the admixture .pop
## file indicating the reference
## populations in R
###########################
## Read in fam file
f = paste0(local_data_dir, "#/ukb_nonwhite_1kg_merge/ukb_1kg.fam")
fam = read.table(f, header = FALSE, sep = " ", as.is = TRUE) 

## Read in the 1000 Genomes pop assignment data
f = paste0(dir_4_1kg_data, "/1000G/1000G_Ind_Pop_Code.txt")
kg = read.table(f, header = TRUE, sep = "\t", as.is = TRUE)

m = match(fam[,1], kg$Sample)
pop = kg$Population[m]
pop[is.na(pop)] = "UKBB"

fam[,2] = pop

f = paste0( local_data_dir ,"#/ukb_nonwhite_1kg_merge/ukb_1kg.fam")
write.table(fam, file = f, row.names = FALSE, col.names = FALSE, sep = " ", quote = FALSE)

pops2keep = c("GBR","YRI","ITU","CHS","UKBB")
w = which(!fam[,2] %in% pops2keep )

remove = fam[w, 1:2] ## 2918 individuals
write.table(remove, file = "KGenomes_samples_2_remove.txt", row.names = FALSE, col.names = FALSE, sep = " ", quote = FALSE)

#######################
## remove unwanted
## 1KG samples
#######################
GENO=$local_data_dir/#/ukb_nonwhite_1kg_merge/ukb_1kg
OUT=$local_data_dir/#/ukb_1kg_popreduced
IN2remove=$local_data_dir/#/KGenomes_samples_2_remove.txt

plink --bfile $GENO --remove $IN2remove  --make-bed --out $OUT

####################
## MAKE a .pop file
## in R
####################
f = paste0(local_data_dir, "#.fam" )
fam = read.table(f, header = FALSE, sep = " ", as.is = TRUE) 

## Read in the 1000 Genomes pop assignment data
f = paste0( dir_4_1kg_data ,"/1000G/1000G_Ind_Pop_Code.txt")
kg = read.table(f, header = TRUE, sep = "\t", as.is = TRUE)

m = match(fam[,1], kg$Sample)
pop = kg$Population[m]
pop[is.na(pop)] = "-"
pop = data.frame(pop)
f = paste0( local_data_dir, "#.pop" )
write.table(pop, file = f, row.names = FALSE, col.names = FALSE, sep = " ", quote = FALSE)

# pop = sapply( fam[,1], function(x){
# 	w = which( kg$Sample %in% x  )
# 	if(length(w) > 0 ){
# 		return(kg$Population[ w[1] ])
# 	} else {
# 		return("-")
# 	}
# })

##########################
## perform an LD prunning
## using just the YRI
## samples
##########################

## ARRAY GENOTYPE Data; UKB + 1KG merge
GENO=$local_data_dir/#/ukb_nonwhite_1kg_merge/ukb_1kg_popreduced
OUT=$local_data_dir/#/ukb_nonwhite_1kg_merge/YRI_LD
IND2KEEP=YRIinds.txt
LDFILE=$dir_4_1kg_data/1000G/LongRange_LD.txt

## GENOTYPE PRUNING FOR THE RUNNING OF ADMIXTURE
plink --bfile $GENO --keep $IND2KEEP --exclude range $LDFILE --indep-pairwise  50 10 0.025 --out $OUT
wc -l YRI_LD.prune.in

##########################
## GENOTYPE PRUNING based on YRI LD FOR THE RUNNING OF ADMIXTURE
##########################
OUT=$local_data_dir/#/ukb_1kg_popreduced_YRILDpruned
plink --bfile $GENO --extract YRI_LD.prune.in --make-bed --out $OUT


#####################
##
## MAKE TEST DATA
##
#####################
f = "ukb_1kg_popreduced_YRILDpruned.fam"
fam = read.table(f, header = FALSE, as.is = TRUE, sep = " ")

w = which(fam[, 2] == "UKBB")
s = sort( sample(w,500) )
k = rbind(fam[s, 1:2], fam[-w, 1:2])
write.table(k, file = "test_sampleids.txt", row.names = FALSE, col.names = FALSE, sep = " ", quote = FALSE)

#######################
## remove unwanted
## 1KG samples
#######################
GENO=$local_data_dir/#/ukb_1kg_popreduced_YRILDpruned
OUT=$local_data_dir/#/testsamples
IN2KEEP=$local_data_dir/#/test_sampleids.txt

plink --bfile $GENO --keep $IN2KEEP  --make-bed --out $OUT

##################
## make pop file
##################
cut -f 2 -d " " testsamples.fam > testsamples
## replace UKBB with -
sed 's/UKBB/-/g' testsamples > testsamples.pop 

##################
### run Test Admixture
##################
admixture testsamples.bed 4 -s 31102020 -j6 -B --supervised

paste -d ' ' testsamples.fam testsamples.4.Q > sample_ancestry_K4.txt


####################################################
##  
##       *** PERFORM ADMIXTURE ANALYSIS ***
##
####################################################
## add Admixture module to environment
module add apps/admixture-1.3.0

cp ukb_1kg_popreduced.pop ukb_1kg_popreduced_YRILDpruned.pop
##
# admixture ukb_1kg_popreduced_YRILDpruned.bed 4 -s 31102020 -B -j6 --supervised
admixture ukb_1kg_popreduced_YRILDpruned.bed 4 -s 31102020 -j6 --supervised

## Paste fam file and ancestry file together
paste -d ' ' ukb_1kg_popreduced_YRILDpruned.fam ukb_1kg_popreduced_YRILDpruned.4.Q > sample_ancestry_K4.txt

## move ancestry file to local directory
scp dh16508@bluecrystalp3.bris.ac.uk:/newhome/dh16508/scratch/AFR_neutrophil/data/#/sample_ancestry_K4.txt ./




