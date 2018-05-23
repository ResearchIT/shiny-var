r = getOption("repos") 
r["CRAN"] = "https://mirror.las.iastate.edu/CRAN/"
options(repos = r)
install.packages("data.table")
install.packages("ontologyIndex")
install.packages("jsonlite")
install.packages("DT")
install.packages("shiny")

source("https://bioconductor.org/biocLite.R")
biocLite("GenomicFeatures")
