

getBedFasta <- function(bedFile,baseGenome){
	fa_loc <- config$files$genomes[[baseGenome]]
	fasta_file <- FaFile(fa_loc)
  data<-fread(bedFile)
  bed <- with(data, GRanges(chr, IRanges(start, end), strand, id=id))
  tmp_range <- GRanges(c("chr1","chr2"),ranges = IRanges(start=c(1000,2000),end=c(2000,3000)))
  seqs <- scanFa(fasta_file,bed)
  #seqs <- getSeq(fasta_file,bed)
  names(seqs) <- as.character(mcols(bed)["id"][,1])
  out_dt <- data.table(cbind(unlist(names(seqs)),as.character(seqs)))
  print(out_dt)
  out_dt
}

razipFa <- function(){
	files <- dir("data/genome",full.names = T,pattern = "*.fa")
	lapply(files,function(x){
		fa<-x
		rz<-sprintf("%s.rz",x)
		Rsamtools::razip(fa,rz)	
		Rsamtools::indexFa(rz)
	})
}

if(F){
	system.time({
		razipFa()
	})
}
