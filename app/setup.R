r = getOption("repos") 
r["CRAN"] = "https://cran.mtu.edu/"
options(repos = r)

all_pkgs = c("data.table","ontologyIndex","jsonlite","DT","shiny","WhopGenome")
wanted_pkgs <- setdiff(all_pkgs, installed.packages())
if(length(wanted_pkgs)>0){
  install.packages(wanted_pkgs)
}

source("https://bioconductor.org/biocLite.R")
all_bioc <- c("GenomicFeatures","Rsamtools")
wanted_bioc <- setdiff(all_bioc, installed.packages())
if(length(wanted_bioc)>0){
	biocLite(wanted_bioc)
}
