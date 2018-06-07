library("WhopGenome")
library("seqminer")
library("VariantAnnotation")

vcf_url <- "http://s3.us-east-2.amazonaws.com/wkpalan-vcf-test/maize-genome/b73.maize_mo17_agp1.vcf.gz"
vcf_file <- "data/vcf/b73.maize_mo17_agp1.vcf.gz"
?seqminer::readVCFToListByRange(vcf__url)

vcf_con <- seqminer::readVCFToListByRange(vcf_file, range="Chr1:200000-212000",annoType = "Nonsynonymous",vcfColumn = c("CHROM", "POS", "REF","ALT"),vcfInfo = "AD",vcfIndv = c("GT"))


param

header(vcffh)

urlh <- file(vcf_url,method="libcurl")
rng <- GRanges("Chr1",IRanges(start=200000,width = 20000))
vcf_param <- ScanVcfParam(info = c("INDEL","ANN"),which = rng)
urlh <- VcfFile(vcf_url,index = paste(vcf_url,".tbi",sep = ""))
vcffh <- readVcf(vcf_url,"",param = rng)
?readVcf
vcffh
a <- scanVcfHeader(vcf_file)
geno(a)

fixed(vcffh)
filt(vcffh)
ref(vcffh)
alt(vcffh)
info(vcffh)
b <- geno(vcffh)
b$GT

info(vcffh)$ANN[[2]]

