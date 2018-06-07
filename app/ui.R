library(shiny)
library(DT)
source("filterSNPs.R")
source("utils.R")
source("genomeTools.R")
dir("data/genome",full.names = T)

shinyUI(fluidPage(
  titlePanel("Query SNPs mapped between Maize Inbred Genomes"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("baseGenome", label = h3("Base Genome"), 
                  choices = genomes,
                  selected = "B73"),
      fileInput("bed", "Choose bed file",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".bed")),
      downloadLink("bedExample", "Bed Example"),
      downloadButton('getRegionSeq', 'Download'),
      selectInput("alignGenome", label = h3("Aligned Genome"), 
                  choices = setdiff(genomes,"B73")),
      textInput("locus", label = h5("Locus"), value = "Chr2:258000-259000"),
      helpText("e.g. Chr1:1000000-2000000"),
      actionButton("getLocSNPs",label = "Get Variants"),
      hr(),
      selectizeInput("geneID", h5("Gene ID"), NULL,
                     options = list(maxOptions = 5,maxItems = 1)),
      helpText("e.g. Zm00001d002960"),
      selectizeInput("effectType", h5("Effect"), NULL,
                     options = list(maxOptions = 1000,maxItems = 5)),
      actionButton("getGeneSNPs",label = "Get Gene Variants"),
      width=2
    ),
    mainPanel(
      h2("Summary"),
      textOutput("genome_txt"),
      textOutput("geneID_txt"),
      h2("SNP Location"),
      DT::dataTableOutput("SNPLocation"),
      h2("SNP Effects"),
      DT::dataTableOutput("SNPEffect")
    )
  )
))
