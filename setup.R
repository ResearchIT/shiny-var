r = getOption("repos") 
r["CRAN"] = "https://mirror.las.iastate.edu/CRAN/"
options(repos = r)

all_pkgs = c("data.table","ontologyIndex","jsonlite","DT","shiny","WhopGenome")
wanted_pkgs <- setdiff(all_pkgs, installed.packages())
if(length(wanted_pkgs)>0){
  install.packages(all_pkgs)  
}

if(!"GenomicFeatures" %in% installed.packages()){
  source("https://bioconductor.org/biocLite.R")
  biocLite("GenomicFeatures")  
}

if(!"Rsamtools" %in% installed.packages()){
  source("https://bioconductor.org/biocLite.R")
  biocLite("Rsamtools")
}