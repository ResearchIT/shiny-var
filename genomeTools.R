library("Rsamtools")
library("data.table")


fasta_file <- Rsamtools::FaFile("data/genome/maize.W22.AGPv2.fa.ragz")

getBedFasta <- function(bedFile){
  data<-fread(bedFile)
  bed <- with(data, GRanges(chr, IRanges(start, end), strand, id=id))
  tmp_range <- GRanges(c("chr1","chr2"),ranges = IRanges(start=c(1000,2000),end=c(2000,3000)))
  seqs <- scanFa(fasta_file,bed)
  names(seqs) <- as.character(mcols(bed)["id"][,1])
  out_dt <- data.table(cbind(unlist(names(seqs)),as.character(seqs)))
  print(out_dt)
  out_dt
}

