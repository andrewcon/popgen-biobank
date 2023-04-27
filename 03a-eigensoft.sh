#####################################
## ON HPC
#####################################

## source my paramater file
source parameters/pfile.txt

############################
## (I) Prepare 1KG continental
##      pop lists
############################
module add languages/R-3.4.1-ATLAS
## Read in the 1000 Genomes pop assignment data
f = paste0(dir_4_1kg_data, "/1000G/1000G_Ind_Pop_Code.txt")
kg = read.table(f, header = TRUE, sep = "\t", as.is = TRUE)

f = paste0(dir_4_1kg_data, "/1000G/1000G_SuperPopCodes.txt")
superpop = read.table(f, header = TRUE, sep = "\t", as.is = TRUE)

f = paste0(local_data_dir, "#/ukb_nonwhite_1kg_merge/ukb_1kg_YRILDpruned.fam")
fam = read.table(f, header = FALSE, sep = "\t", as.is = TRUE)

## admixture files
f = paste0(local_data_dir, "/admixture/")
files = list.files(dir)
k = grep("UKB_IDs_80Perc_", files)
files = files[k]

### Iterate over superpops
Spops = c("AFR","EAS","EUR","SAS")
for(pop in Spops){
	w = which(superpop[,2] == pop)
	subpops = superpop[w, 1]
	## remove the american AFR pops
	if(pop == "AFR"){
		subpops = subpops[!subpops %in% c("ASW","ACB") ]
	}
	## find KG ind ids
	w = which(kg$Population %in% subpops)
	kgsubpop = kg[w, ]

	## find UKB 80% ANC individuals
	w = grep(pop, files)
	f = paste0(dir, files[w])
	anc = read.table( f , header = FALSE, sep = " ", as.is = TRUE)

	k = which(fam[,1] %in% c( anc[,1], kgsubpop[,1] ) )

	out = fam[k, 1:2]

	path = f = paste0(local_data_dir, "#/ukb_nonwhite_1kg_merge/")
	fout = paste0(path, pop, "_ancestry_ind_list.txt")
	write.table(out, file = fout, row.names = FALSE, col.names = FALSE, sep = " ", quote = FALSE)

}


# ############################
# ## (I) 1KG LD SNP Lists
# ############################
# cd $dir_4_1kg_data/1000G
# grep GBR 1000G_Ind_Pop.txt | cut -f 1 > $local_data_dir#/ukb_nonwhite_1kg_merge/GBRids.txt
# grep ITU 1000G_Ind_Pop.txt | cut -f 1 > $local_data_dir#/ukb_nonwhite_1kg_merge/ITUids.txt
# grep CHS 1000G_Ind_Pop.txt | cut -f 1 > $local_data_dir#/ukb_nonwhite_1kg_merge/CHSids.txt
# grep YRI 1000G_Ind_Pop.txt | cut -f 1 > $local_data_dir#/ukb_nonwhite_1kg_merge/YRIids.txt


# ############
# ## Edit in R
# ############
# f = c("GBRids.txt","ITUids.txt","CHSids.txt","YRIids.txt")
# for(i in f){
# 	pop = gsub("ids.txt","",i)
# 	mydata = read.table(i, header = FALSE, as.is = TRUE)
# 	mydata$pop = pop
# 	write.table(mydata, file = i, row.names = FALSE, col.names = FALSE, sep = " ", quote = FALSE)
# }

# ############
# ## Identify
# ## Unrelated ID lists
# ############
# cd $local_data_dir#/ukb_nonwhite_1kg_merge
# module add apps/plink-1.90
#
# GENO=ukb_1kg
# INDS2KEEP=GBRids.txt
# OUT=GBR
# plink --bfile $GENO --keep $INDS2KEEP --rel-cutoff --out $OUT

# GENO=ukb_1kg
# INDS2KEEP=ITUids.txt
# OUT=ITU
# plink --bfile $GENO --keep $INDS2KEEP --rel-cutoff --out $OUT

# GENO=ukb_1kg
# INDS2KEEP=CHSids.txt
# OUT=CHS
# plink --bfile $GENO --keep $INDS2KEEP --rel-cutoff --out $OUT

# GENO=ukb_1kg
# INDS2KEEP=YRIids.txt
# OUT=YRI
# plink --bfile $GENO --keep $INDS2KEEP --rel-cutoff --out $OUT

# ############
# ## Identify
# ## LD SNP lists
# ############
# cd $local_data_dir#/ukb_nonwhite_1kg_merge

# module add apps/plink-2.00 
# GENO=ukb_1kg
# INDS2KEEP=GBR.rel.id
# OUT=GBR
# LDFILE=$dir_4_1kg_data/1000G/LongRange_LD.txt
# plink --bfile $GENO --keep $INDS2KEEP --maf 0.01 --exclude range $LDFILE --indep-pairwise 50 10 0.05 --out $OUT
# wc -l GBR.prune.in ## 46,577

# GENO=ukb_1kg
# INDS2KEEP=ITU.rel.id
# OUT=ITU
# LDFILE=$dir_4_1kg_data/1000G/LongRange_LD.txt
# plink --bfile $GENO --keep $INDS2KEEP --maf 0.01 --exclude range $LDFILE --indep-pairwise 50 10 0.05 --out $OUT
# wc -l ITU.prune.in ## 41696

# GENO=ukb_1kg
# INDS2KEEP=CHS.rel.id
# OUT=CHS
# LDFILE=$dir_4_1kg_data/1000G/LongRange_LD.txt
# plink --bfile $GENO --keep $INDS2KEEP --maf 0.01 --exclude range $LDFILE --indep-pairwise 50 10 0.05 --out $OUT
# wc -l CHS.prune.in ## 29292

# GENO=ukb_1kg
# INDS2KEEP=YRI.rel.id
# OUT=YRI
# LDFILE=$dir_4_1kg_data/1000G/LongRange_LD.txt
# plink --bfile $GENO --keep $INDS2KEEP --maf 0.01 --exclude range $LDFILE --indep-pairwise 50 10 0.05 --out $OUT
# wc -l YRI.prune.in ## 42033


####################################
## (II) Identify
## 		Unrelated ID lists
####################################
cd $local_data_dir#/ukb_nonwhite_1kg_merge
###  load plink 1.9
module add apps/plink-1.90
###
GENO=ukb_1kg
INDS2KEEP=EUR_ancestry_ind_list.txt
OUT=EUR
plink --bfile $GENO --maf 0.05 --keep $INDS2KEEP --rel-cutoff --out $OUT

GENO=ukb_1kg
INDS2KEEP=SAS_ancestry_ind_list.txt
OUT=SAS
plink --bfile $GENO --maf 0.05 --keep $INDS2KEEP --rel-cutoff --out $OUT

GENO=ukb_1kg
INDS2KEEP=EAS_ancestry_ind_list.txt
OUT=EAS
plink --bfile $GENO --maf 0.05 --keep $INDS2KEEP --rel-cutoff --out $OUT

GENO=ukb_1kg
INDS2KEEP=AFR_ancestry_ind_list.txt
OUT=AFR
plink --bfile $GENO --maf 0.05 --keep $INDS2KEEP --rel-cutoff --out $OUT

####################################
## (III) Identify
## 		 LD SNP lists
####################################
cd $local_data_dir#/ukb_nonwhite_1kg_merge

module add apps/plink-2.00 
GENO=ukb_1kg
INDS2KEEP=EUR.rel.id
OUT=EUR
LDFILE=$dir_4_1kg_data/1000G/LongRange_LD.txt
plink --bfile $GENO --keep $INDS2KEEP --maf 0.01 --exclude range $LDFILE --indep-pairwise 50 10 0.05 --out $OUT
wc -l EUR.prune.in ## 40,095 NEDD TO RUN EUR

GENO=ukb_1kg
INDS2KEEP=SAS.rel.id
OUT=SAS
LDFILE=$dir_4_1kg_data/1000G/LongRange_LD.txt
plink --bfile $GENO --keep $INDS2KEEP --maf 0.01 --exclude range $LDFILE --indep-pairwise 50 10 0.025 --out $OUT
wc -l SAS.prune.in ## 43,915

GENO=ukb_1kg
INDS2KEEP=EAS.rel.id
OUT=EAS
LDFILE=$dir_4_1kg_data/1000G/LongRange_LD.txt
plink --bfile $GENO --keep $INDS2KEEP --maf 0.01 --exclude range $LDFILE --indep-pairwise 50 10 0.05 --out $OUT
wc -l EAS.prune.in ## 47113

GENO=ukb_1kg
INDS2KEEP=AFR.rel.id
OUT=AFR
LDFILE=$dir_4_1kg_data/1000G/LongRange_LD.txt
plink --bfile $GENO --keep $INDS2KEEP --maf 0.01 --exclude range $LDFILE --indep-pairwise 50 10 0.025 --out $OUT
wc -l AFR.prune.in ## 48818


####################################
## (IV) make ancestry and 
##      LD specific plink files
####################################
## EUR
GENO=$local_data_dir#/ukb_nonwhite_1kg_merge/ukb_1kg
OUT=$local_data_dir#/ukb_nonwhite_1kg_merge/ukb_1kg_EUR
INDS2KEEP=$local_data_dir#/ukb_nonwhite_1kg_merge/EUR_ancestry_ind_list.txt
SNPS2KEEP=$local_data_dir#/ukb_nonwhite_1kg_merge/EUR.prune.in

plink --bfile $GENO --keep $INDS2KEEP --extract $SNPS2KEEP --make-bed --out $OUT

## SAS
GENO=$local_data_dir#/ukb_nonwhite_1kg_merge/ukb_1kg
OUT=$local_data_dir#/ukb_nonwhite_1kg_merge/ukb_1kg_SAS
INDS2KEEP=$local_data_dir#/ukb_nonwhite_1kg_merge/SAS_ancestry_ind_list.txt
SNPS2KEEP=$local_data_dir#/ukb_nonwhite_1kg_merge/SAS.prune.in

plink --bfile $GENO --keep $INDS2KEEP --extract $SNPS2KEEP --make-bed --out $OUT

## EAS
GENO=$local_data_dir#/ukb_nonwhite_1kg_merge/ukb_1kg
OUT=$local_data_dir#/ukb_nonwhite_1kg_merge/ukb_1kg_EAS
INDS2KEEP=$local_data_dir#/ukb_nonwhite_1kg_merge/EAS_ancestry_ind_list.txt
SNPS2KEEP=$local_data_dir#/ukb_nonwhite_1kg_merge/EAS.prune.in

plink --bfile $GENO --keep $INDS2KEEP --extract $SNPS2KEEP --make-bed --out $OUT

## AFR
GENO=$local_data_dir#/ukb_nonwhite_1kg_merge/ukb_1kg
OUT=$local_data_dir#/ukb_nonwhite_1kg_merge/ukb_1kg_AFR
INDS2KEEP=$local_data_dir#/ukb_nonwhite_1kg_merge/AFR_ancestry_ind_list.txt
SNPS2KEEP=$local_data_dir#/ukb_nonwhite_1kg_merge/AFR.prune.in

plink --bfile $GENO --keep $INDS2KEEP --extract $SNPS2KEEP --make-bed --out $OUT


###############################
## (V)
## 		Run smartrel
##
##############################
###############
## 1. AFR
###############
genotypename: $local_data_dir#/ukb_nonwhite_1kg_merge/ukb_1kg_AFR.bed
snpname: $local_data_dir#/ukb_nonwhite_1kg_merge/ukb_1kg_AFR.bim
indivname: $local_data_dir/data#/ukb_nonwhite_1kg_merge/ukb_1kg_AFR.fam
outputname: ukb_1kg_AFR
numeigs: 40
relthresh: 0.05

## RUN !
cd $local_data_dir/smartrel
module add apps/eigensoft-7.2.1
smartrel -p AFR_param_file.txt > ukb_1kg_AFR_LD_smartrel.log & 
grep rel: ukb_1kg_AFR_LD_smartrel.log > ukb_1kg_AFR_EstRelatives.smartrel

phylipoutname: AFR_phylip_Fst.txt
fstonly: YES
###############
## 2. EAS
###############
# vi EAS_param_file.txt
genotypename: $local_data_dir#/ukb_nonwhite_1kg_merge/ukb_1kg_EAS.bed
snpname: $local_data_dir#/ukb_nonwhite_1kg_merge/ukb_1kg_EAS.bim
indivname: $local_data_dir#/ukb_nonwhite_1kg_merge/ukb_1kg_EAS.fam
outputname: ukb_1kg_EAS
numeigs: 40
relthresh: 0.05

## RUN !
cd $local_data_dir/smartrel
module add apps/eigensoft-7.2.1 
smartrel -p EAS_param_file.txt > ukb_1kg_EAS_LD_smartrel.log &
grep rel: ukb_1kg_EAS_LD_smartrel.log > ukb_1kg_EAS_EstRelatives.smartrel


###############
## 3. SAS
###############
# vi SAS_param_file.txt
genotypename: $local_data_dir#/ukb_nonwhite_1kg_merge/ukb_1kg_YRILDpruned_SAS.bed
snpname: $local_data_dir#/ukb_nonwhite_1kg_merge/ukb_1kg_YRILDpruned_SAS.bim
indivname: $local_data_dir#/ukb_nonwhite_1kg_merge/ukb_1kg_YRILDpruned_SAS.fam
outputname: ukb_1kg_SAS
numeigs: 40
relthresh: 0.05

## RUN !
cd $local_data_dir/smartrel
module add apps/eigensoft-7.2.1 
smartrel -p SAS_param_file.txt > ukb_1kg_SAS_LD_smartrel.log & 
grep rel: ukb_1kg_SAS_LD_smartrel.log > ukb_1kg_SAS_EstRelatives.smartrel


###############
## 4. EUR
###############
# vi EUR_param_file.txt
genotypename: $local_data_dir#/ukb_nonwhite_1kg_merge/ukb_1kg_YRILDpruned_EUR.bed
snpname: $local_data_dir#/ukb_nonwhite_1kg_merge/ukb_1kg_YRILDpruned_EUR.bim
indivname: $local_data_dir#/ukb_nonwhite_1kg_merge/ukb_1kg_YRILDpruned_EUR.fam
outputname: ukb_1kg_EUR
numeigs: 40
relthresh: 0.05

## RUN !
cd $local_data_dir/smartrel
module add apps/eigensoft-7.2.1 
smartrel -p EUR_param_file.txt > ukb_1kg_EUR_smartrel.log
grep rel: ukb_1kg_EUR_smartrel.log > ukb_1kg_EUR_EstRelatives.smartrel


####################################
## (VI)
## 		Identify relatives
##
####################################
## Run greedy selection script
## pass two arguments
Rscript greedy_unrelated_selection.R ukb_1kg_AFR_EstRelatives.smartrel AFR # Done
Rscript greedy_unrelated_selection.R ukb_1kg_EAS_EstRelatives.smartrel EAS # Done
Rscript greedy_unrelated_selection.R ukb_1kg_SAS_EstRelatives.smartrel SAS # Done


####################################
## (VII)
## 		Make smartPCA ID list
##
####################################
cd $local_data_dir/smartrel
## in R

###############
## 1. AFR
###############
f = paste0(local_data_dir,"#/ukb_nonwhite_1kg_merge/ukb_1kg_AFR.fam")
fam = read.table(f, header = FALSE, sep = " ", as.is = TRUE)
ids = paste0(fam[,1], ":", fam[,2])
out = data.frame(ids = ids, sex = "U", pop = fam[,2])
for(i in 1:3){ out[,i] = as.character(out[,i])  }
##
f = "AFR_related_inds_2remove.txt"
rel = read.table(f, header = FALSE, sep = " ", as.is = TRUE)[,1]
w = which(out$ids %in% rel & out$pop == "UKBB")
if(length(w)>0){ out$pop[w] = "UKBB_relatives" }

table(fam[,2], out$pop) ## 515 relatives
fout = "ukb_1kg_AFR.IDS"
write.table(out, file = fout, row.names = FALSE, col.names = FALSE, sep = " ", quote = FALSE)

###############
## 2. EAS  # DONE 1321 July 27
###############
f = paste0(local_data_dir,"#/ukb_nonwhite_1kg_merge/ukb_1kg_EAS.fam")
fam = read.table(f, header = FALSE, sep = " ", as.is = TRUE)
ids = paste0(fam[,1], ":", fam[,2])
out = data.frame(ids = ids, sex = "U", pop = fam[,2])
for(i in 1:3){ out[,i] = as.character(out[,i])  }
##
f = "EAS_related_inds_2remove.txt"
rel = read.table(f, header = FALSE, sep = " ", as.is = TRUE)[,1]
w = which(out$ids %in% rel & out$pop == "UKBB")
if(length(w)>0){ out$pop[w] = "UKBB_relatives" }

table(fam[,2], out$pop) ## 22 (78 in v0.1) relatives
fout = "ukb_1kg_EAS.IDS"
write.table(out, file = fout, row.names = FALSE, col.names = FALSE, sep = " ", quote = FALSE)

###############
## 3. SAS
###############
f = paste0( local_data_dir, "#/ukb_nonwhite_1kg_merge/ukb_1kg_SAS.fam")
fam = read.table(f, header = FALSE, sep = " ", as.is = TRUE)
ids = paste0(fam[,1], ":", fam[,2])
out = data.frame(ids = ids, sex = "U", pop = fam[,2])
for(i in 1:3){ out[,i] = as.character(out[,i])  }
##
f = "SAS_related_inds_2remove.txt"
rel = read.table(f, header = FALSE, sep = " ", as.is = TRUE)[,1]
w = which(out$ids %in% rel & out$pop == "UKBB")
if(length(w)>0){ out$pop[w] = "UKBB_relatives" }

table(fam[,2], out$pop) 
fout = "ukb_1kg_SAS.IDS"
write.table(out, file = fout, row.names = FALSE, col.names = FALSE, sep = " ", quote = FALSE)


###############
## 4. EUR
###############
f = paste0(local_data_dir,"#/ukb_nonwhite_1kg_merge/ukb_1kg_EUR.fam")
fam = read.table(f, header = FALSE, sep = " ", as.is = TRUE)
ids = paste0(fam[,1], ":", fam[,2])
out = data.frame(ids = ids, sex = "U", pop = fam[,2])
for(i in 1:3){ out[,i] = as.character(out[,i])  }
##
f = paste0(local_data_dir,"#/ukb_nonwhite_1kg_merge/EUR.rel.id")
rel = read.table(f, header = FALSE, sep = "\t", as.is = TRUE)
w = which(!fam[,1] %in% rel[,1] & out$pop == "UKBB")
if(length(w)>0){ out$pop[w] = "UKBB_relatives" }

table(fam[,2], out$pop) ## 12,013 relatives
fout = "ukb_1kg_EUR.IDS"
write.table(out, file = fout, row.names = FALSE, col.names = FALSE, sep = " ", quote = FALSE)



####################################
## (VIII)
## 			Run SmartPCA
##
####################################
cd $local_data_dir/smartpca
module add apps/eigensoft-7.2.1 
##
smartpca -p AFR_parameter.txt > AFR_smartpca.log &
##
smartpca -p EAS_parameter.txt > EAS_smartpca.log &
##
smartpca -p SAS_parameter.txt > SAS_smartpca.log &
##
smartpca -p EUR_parameter.txt > EUR_smartpca.log &


####################################
## (IX)
## 		Run SmartPCA with Kpop IDs
## 		- estimate Fst
####################################
cd $local_data_dir/smartpca
module add apps/eigensoft-7.2.1 

#### EDIT paramater files
cp AFR_parameter.txt AFR_parameter_Kcluster.txt
cp EUR_parameter.txt EUR_parameter_Kcluster.txt
cp SAS_parameter.txt SAS_parameter_Kcluster.txt
cp EAS_parameter.txt EAS_parameter_Kcluster.txt

##
smartpca -p AFR_parameter_Kcluster.txt > AFR_smartpca_Kcluster.log & 
##
smartpca -p EAS_parameter_Kcluster.txt > EAS_smartpca_Kcluster.log & 
##
smartpca -p SAS_parameter_Kcluster.txt > SAS_smartpca_Kcluster.log & 
##
smartpca -p EUR_parameter_Kcluster.txt > EUR_smartpca_Kcluster_r3.log &

