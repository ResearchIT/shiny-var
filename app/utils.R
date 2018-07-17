library("data.table")
library("ontologyIndex")
library("jsonlite")
library("GenomicFeatures")
library("WhopGenome")
library("Rsamtools")

config <- jsonlite::read_json("data/config/config.json")
genomes <- config$genomes


getGenomes <- function(){
  config <- jsonlite::read_json("data/config/config.json")
  return(config$genomes)
}


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

ann_cols <- fread("config/ann_cols.txt",header=F)$V1
sel_out_cols <- fread("config/out_cols.txt",header=F)$V1
out_cols <- fread("config/out_cols.txt",header=F)$V2

var_f <- "config/sequence_variant.csv"
if(!exists("var_f_time") || file.mtime(var_f) > var_f_time){
  seq_vars <- fread("config/sequence_variant.csv",sep = "\t")  
  var_f_time <- file.mtime(var_f)
}


if(!exists("so_time") || file.mtime(config$files$seq_ont) > so_time){
  so_obo <- ontologyIndex::get_OBO(config$files$seq_ont,extract_tags = "everything")
  so_time <- file.mtime(config$files$seq_ont)
  so_obo$name2id = names(so_obo$name)
  names(so_obo$name2id) = so_obo$name  
}





