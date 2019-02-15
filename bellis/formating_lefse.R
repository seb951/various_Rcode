
#Change directory (I've stored all the files in a folder called "bellis" on my desktop).
setwd("~/Desktop/bellis")


#load datasets
meta = read.table("QCBS_fullmetadata_LEFSE.txt",stringsAsFactors = F, sep = "\t",header = F)
abundance = read.table("Q.ROOTBACT.comm.noten.LEFSE.csv",stringsAsFactors = F, sep = ",",header = T)
taxo = read.table("Q.ROOTBACT.taxo.noten.LEFSE.csv",stringsAsFactors = F, sep = ",",header = T,na.strings = "ignoreNAs")

#clean taxonomy by removing the *__ symbols and adding NAs to empty cells...
taxo.clean = taxo
for(i in 2:8) 
{
  taxo.clean[,i] = gsub("^...","",taxo.clean[,i])
  taxo.clean[taxo.clean[,i] == "",i] = "NA" 
  }


#Choose what taxonomy level you are interested in by changing the taxo_level variable.
taxo_level = "Order"
col = c(1:ncol(taxo.clean))[colnames(taxo.clean) == taxo_level]

#remove 2 samples from the metadatas
meta = meta[meta[,1]!="BC.C1.2",]
meta = meta[meta[,1]!="T1.S2.DOR",]


#get metadata of interest (samples,stand type,TransplantedSite,SeedSourceOrigin,description)
meta.temp = t(meta[,c(1,3,4,6,2)])


###get taxonomic data and create a new matrix with this info
taxo.temp.full = apply(taxo.clean[,2:col],1,paste,collapse ="|")
taxo.temp.full.unique = unique(sort(apply(taxo.clean[,2:col],1,paste,collapse ="|")))
taxo.abundance = matrix(0,nrow = length(taxo.temp.full.unique) , ncol = nrow(abundance))


#merge info, taxo_level per taxo_level
for(i in 1:length(taxo.temp.full.unique))
    {
      #get all the OTUs for a single phylum
      otu = taxo.clean[taxo.temp.full == taxo.temp.full.unique[i],1]
      otu = otu[!is.na(otu)]
      
      #get all the abundance for all the OTUs for a single taxo_level
      otu_abundance = abundance[,colnames(abundance) %in% otu]
      
      if(length(otu) >  1) taxo.abundance[i,] = rowSums(otu_abundance) #many OTU per taxo_level: sum the rows
      if(length(otu) == 1) taxo.abundance[i,] = otu_abundance #a single OTU...
}


#relative abundances
for(j in 1:ncol(taxo.abundance))
    {
  taxo.abundance[,j] = taxo.abundance[,j]/colSums(taxo.abundance)[j]
}  

  
#combine everything into a single matrix
meta.taxo = rbind(meta.temp,taxo.abundance)
rownames(meta.taxo) = c(c("","StandType","TransplantedSite","SeedSourceOrigin","ID"),taxo.temp.full.unique)


###write it as a csv file
write.table(meta.taxo,paste0("Rscripted_Q.ROOTBACT_",taxo_level,"_LEFSEex.csv"),sep = ",",quote = F,col.names = F)


