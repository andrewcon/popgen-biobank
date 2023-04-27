###################################################
## ON HPC
## reduce the directly genotyped
## plink data down to just those
## with NON-white british ancestry
###################################################
## Source the parameter file
source parameters/pfile.txt

##### SLURM FILE

#!/bin/bash

#SBATCH --job-name=snpsamp_extract
#SBATCH --partition=mrcieu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=12:0:0
#SBATCH --mem=50G

module add apps/plink/2.00

INDS2KEEP=$data_dir/#.txt
SNPS2KEEP=$local_data_dir/geno/#.txt
GENO=$data_dir/#
OUT=$local_data_dir/#

plink --bfile $GENO \
	--keep $INDS2KEEP \
	--make-bed \
	--out $OUT
###################################
## Extract duffy NUll rs2814778
###################################
SNPS2KEEP=$local_data_dir/#.txt
GENO=$data_dir/#
OUT=$local_data_dir/#.dosage

plink --bfile $GENO \
	--extract $SNPS2KEEP \
	--make-bed \
	--out $OUT

module add apps/qctool/2.0rc4
###
qctool -g rs2814778.dosage.bed -filetype binary_ped -og rs2814778.dosage -ofiletype dosage

##########
## in R
##########
module add languages/r/4.0.2
###
library(data.table)
f = list.files()
mydata = fread("rs2814778.dosage", header = TRUE, sep = " ")
new = t(mydata)
##
ids = fread("rs2814778.dosage.fam", header = FALSE)
##
anno = new[1:6, ]
out = cbind(  ids[, c(1,2,5)], new[-c(1:6), ])
colnames(out) = c("ID1","ID2","sex","rs2814778_T")
write.table(out, file = "ukb_rs2814778_T.dosage", row.names = FALSE, col.names = TRUE, sep = " ", quote = FALSE)
a = data.frame(x = anno)
write.table(anno, file = "ukb_rs2814778_T.anno", row.names = TRUE, col.names = FALSE, sep = " ", quote = FALSE)

###################################
## run job
###################################
sbatch extract_ukbb_nonwhite_inds.sh


###################################################
## add plink module to environment
###################################################
module add apps/plink2


##########################
## reduce 1KG data down
## to snps available 
## in ukbb hard call data
##########################
KG_GENO=$dir_4_1kg_data/1000G/#
SNPS2KEEP=$local_data_dir/#.txt
OUT=$dir_4_1kg_data/1000G/#


plink --bfile $KG_GENO \
	--extract $SNPS2KEEP \
	--make-bed \
	--out $OUT

#########
cut -f 2 ALL_1000G_phase3_shapeit2_UKBB_SNPs.bim > UKBB_1KG_RSids.txt

##########################
## reduce UKBB data down
## to snps available 
## in 1KG
##########################
GENO=$local_data_dir#/ukbb_non_white_british
SNPS2KEEP=$dir_4_1kg_data/1000G/UKBB_1KG_RSids.txt
OUT=$local_data_dir/#/ukbb_non_white_british

plink --bfile $GENO \
	--extract $SNPS2KEEP \
	--make-bed \
	--out $OUT


#################################
## attempt merge of 1KG and MCS
#################################
DATA1=$local_data_dir/#/ukbb_non_white_british
DATA2=$dir_4_1kg_data/1000G/ALL_1000G_phase3_shapeit2_UKBB_SNPs
OUT=$local_data_dir/#/ukb_nonwhite_1kg_merge/ukb_1kg

plink --bfile $DATA1 \
	--bmerge $DATA2 \
	--make-bed \
	--out $OUT

###################################
## remove problematic SNPs
###################################
SNPEXCLUSION=$local_data_dir/#/ukb_1kg-merge.missnp

### UKBB
GENO=$local_data_dir/#/ukbb_non_white_british
OUT=$local_data_dir/#/ukbb_non_white_british_v2

plink --bfile $GENO \
	--exclude $SNPEXCLUSION \
	--make-bed \
	--out $OUT

## 1KG
GENO=$dir_4_1kg_data/1000G/ALL_1000G_phase3_shapeit2_UKBB_SNPs
OUT=$dir_4_1kg_data/1000G/ALL_1000G_phase3_shapeit2_UKBB_SNPs_v2

plink --bfile $GENO \
	--exclude $SNPEXCLUSION \
	--make-bed \
	--out $OUT


#################################
## attempt merge of 1KG and MCS
#################################
DATA1=$local_data_dir/#/ukbb_non_white_british_v2
DATA2=$dir_4_1kg_data/1000G/ALL_1000G_phase3_shapeit2_UKBB_SNPs_v2
OUT=$local_data_dir/#/ukb_nonwhite_1kg_merge/ukb_1kg

plink --bfile $DATA1 \
	--bmerge $DATA2 \
	--make-bed \
	--out $OUT



