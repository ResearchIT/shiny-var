

if(F){
  txDB = list()
  txName = list()
  
  b73_agpv4_tx_file <- "data/Zea_mays_B73_AGPv4.sqlite"
  txDB[["B73"]] <- loadDb(b73_agpv4_tx_file)
  txName[["B73"]] = id2name(txDB[["B73"]],feature.type = c("tx"))
  seqlevels(txDB[["B73"]]) <- paste("Chr",c(1:10),sep = "")
}

getSNPs <-  function(baseGenome,alignGenome,locus){
  
  if(baseGenome=="B73"){
    locus=gsub("chr","Chr",locus)
  }else{
    locus=gsub("Chr","chr",locus)
  }
  
  sel_vcfFile = config$files$VCF[[baseGenome]][[alignGenome]]
  print(sel_vcfFile)
  vcffile = vcf_open(sel_vcfFile)
  locus_splt = unlist(strsplit(locus,"[:]|-|[[:space:]]+"))
  if(length(locus_splt)==2){
    names(locus_splt) = c("chr","start")
    start_pos = as.numeric(locus_splt["start"])-1
    end_pos = as.numeric(locus_splt["start"])
  }
  else if(length(locus_splt)==3){
    names(locus_splt) = c("chr","start","end")
    start_pos = as.numeric(locus_splt["start"])
    end_pos = as.numeric(locus_splt["end"])
  }else{
    return("The locus is misformed")
  }
  chr = locus_splt["chr"]
  
  if(!chr %in% vcf_getcontignames(vcffile)){
    return("Chromsome not found in genome")
  }
  
  vcf_setregion(vcffile, chr,start_pos,end_pos)
  
  all_snps <- NULL
  while(vcf_parseNextLine(vcffile)){
    chr <- vcf_getChrom(vcffile)
    pos <- vcf_getPos(vcffile)
    ref <- vcf_getRef(vcffile)
    alt <- vcf_getAlt(vcffile)
    fmt_names = unlist(strsplit(vcf_getFormat(vcffile),":"))
    fmt_values = unlist(strsplit(vcf_getSample(vcffile,as.integer(0)),":"))
    names(fmt_values) <- fmt_names
    ad <- unlist(strsplit(fmt_values["AD"],","))[1:2]
    if(length(unlist(strsplit(fmt_values["AD"],",")))>2){
      ad[2] <- sum(as.numeric(unlist(strsplit(fmt_values["AD"],","))[-1]))
    }
    
    names(ad) <- c("Ref_Dep","Alt_dep")
    var_type <- ifelse(vcf_isINDEL(vcffile),"INDEL","SNP")
    qual = vcf_getQual(vcffile)
    ann <- vcf_getInfoField( vcffile, "ANN" )
    
    if(is.null(ann)){
      sel_ann <- data.table(matrix(rep(NA,3),nrow = 1))
      colnames(sel_ann) <- c("Effect","Impact","Gene")
    }else{
      ann_dt <- data.table(do.call(rbind,strsplit(unlist(strsplit(ann,",")),"\\|")))[,1:15,with=F]
      colnames(ann_dt) <-  ann_cols
      sel_ann <- unique(ann_dt[,.(effect,putative_impact,gene_name)])
      colnames(sel_ann) <- c("Effect","Impact","Gene")
      sel_ann[,Gene:=gsub("gene:","",Gene)]
    }
    setcolorder(sel_ann,c("Gene","Effect","Impact"))
    tmp_row <- cbind(chr,pos,ref,alt,var_type,qual,t(ad),sel_ann)
    print(tmp_row)
    if(is.null(all_snps)){
      all_snps <- data.table(tmp_row)
    }else{
      all_snps <- rbind(all_snps,tmp_row)
    }
  }
  if(is.null(all_snps)){
    all_snps="There are no Variations within the locus"
  }
  return(all_snps)  
  
}

getSNPEffects <-  function(geneID,baseGenome,alignGenome,effects){
  
  if(baseGenome=="B73"){
    geneID = paste("gene:",geneID,sep="")
  }
  
  tmp_txDB <- loadDb(config$files$txdb[[baseGenome]])
  geneRange <- genes(tmp_txDB,filter=list(gene_id=geneID))
  print(geneRange)
  seqName <- as.character(unique(seqnames(geneRange)))
  seqlevels(tmp_txDB) <- as.character(seqName)
  
  sel_vcfFile = config$files$VCF[[baseGenome]][[alignGenome]]
  vcffile = vcf_open(sel_vcfFile)
  print(length(geneRange))
  if(length(geneRange)==0){
    return("The Gene ID selected doesn't match the selected genome")
  }
  
  chr = as.character(seqnames(geneRange))
  start_pos = start(geneRange)-1000
  end_pos = end(geneRange)+1000
  vcf_setregion(vcffile, chr,start_pos,end_pos)
  
  
  all_snps <- NULL 
  while(vcf_parseNextLine(vcffile)){
    if(vcf_isINDEL(vcffile)){
      print("INDEL")
    }
    chr <- vcf_getChrom(vcffile)
    pos <- vcf_getPos(vcffile)
    ref_allele <- vcf_getRef(vcffile)
    alt_allele <- vcf_getAlt(vcffile)
    ann <- vcf_getInfoField( vcffile, "ANN" )
    ann_dt <- data.table(do.call(rbind,strsplit(unlist(strsplit(ann,",")),"\\|")))[,1:15,with=F]
    colnames(ann_dt) <-  ann_cols
    eff_idx <- grep("&",ann_dt$effect)
    if(length(eff_idx)>0){
      eff_splt_list <- lapply(eff_idx,function(x){
        splt_effs <- unlist(strsplit(ann_dt[x]$effect,"&"))
        cbind(ann_dt[x,-"effect",with=F],effect=splt_effs)
      })
      tmp_ann_dt <- do.call(rbind,eff_splt_list)
      print(tmp_ann_dt)
      ann_dt <- rbind(ann_dt[-eff_idx],tmp_ann_dt)
      print(ann_dt)
    }
    ann_dt <- cbind(chr,pos,ref_allele, alt_allele,ann_dt)
    out_dt <- ann_dt[,sel_out_cols,with=F]
    colnames(out_dt) <- out_cols
    out_dt[,Gene:=gsub(".+:","",Gene)]
    out_dt[,Transcript:=gsub(".+:","",Transcript)]
    
    if(is.null(all_snps)){
      all_snps <- data.table(out_dt)
    }else{
      all_snps <- rbind(all_snps,out_dt)
    }
  }
  
  
  if(length(effects)>0){
    effect_names = so_obo$name[get_descendants(so_obo,so_obo$name2id[effects])]
    if(is.null(all_snps)){
      filt_snps <- all_snps
    }else{
      filt_snps <- all_snps[Effect %in% effect_names]
    }
  }else{
    filt_snps <- all_snps
  }
  
  if(is.null(filt_snps)){
    filt_snps="The Gene Model does not have SNPs"
  }
  return(filt_snps)
}

getGeneRange <- function(geneID,baseGenome){
  genes(txDB[[baseGenome]],filter=list(gene_id=geneID))
}


?runApp
