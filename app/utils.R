library("data.table")
library("ontologyIndex")
library("jsonlite")
library("GenomicFeatures")
library("WhopGenome")
library("Rsamtools")

config <- jsonlite::read_json("config/config.json")
genomes <- config$genomes
print(genomes)
genes <- lapply(config$files$genes,function(x){
  if(file.exists(x)){
    out=fread(x,header = F)$V1
  }else{
    out=x
  }
  out
})
vcfFiles = config$files$VCF

loc_cols_wanted = c("seqnames","start","end","GENEID","tx_name","LOCATION")
eff_cols_wanted = fread("config/eff_cols_wanted.txt",header = F)$V1

setdiff(genomes,"B73")
genes[["B73"]][1:10]

ann_cols <- fread("config/ann_cols.txt",header=F)$V1
sel_out_cols <- fread("config/out_cols.txt",header=F)$V1
out_cols <- fread("config/out_cols.txt",header=F)$V2

seq_vars <- fread("config/sequence_variant.csv",sep = "\t")

so_obo <- ontologyIndex::get_OBO(config$files$seq_ont,extract_tags = "everything")
so_obo$name2id = names(so_obo$name)
names(so_obo$name2id) = so_obo$name
