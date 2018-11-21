#modify the format of a matrix 
#sebastien.renaut@gmail.com
#October 2018

#for Jacynthe Masse & Maxime Faubert


#load and check file
fungi_abnd = read.table("/Users/jerry/Desktop/Fungi_abundance_phylum_JMforSeb.txt",stringsAsFactors = F,header =T,sep = "\t")

dim(fungi_abnd) #check file structure, looks good
rle(fungi_abnd[,1]) #how many samples, looks good
rle(sort(fungi_abnd[,2])) #how many phylum, looks good
fungi_abnd = fungi_abnd[,1:6] #get rid of extra NA columns
fungi_abnd[,3] = as.numeric(gsub(",",".",fungi_abnd[,3],fixed = T)) #decimals are seperated by commas. fix it

#create empty dataframe
fungi_df = as.data.frame(matrix(0,nrow = length(unique(fungi_abnd[,1])),ncol = 14))
fungi_df[,1] = unique(fungi_abnd[,1])
colnames(fungi_df) = c("sample",fungi_abnd[1:10,2],"block","salix","substrat")

#add stuff to it
for(i in 1:nrow(fungi_df))
{
  fungi_df[i,2:11] = fungi_abnd[fungi_abnd[,1] == fungi_df[i,1],3] #abundance
  fungi_df[i,12] = fungi_abnd[fungi_abnd[,1] ==fungi_df[i,1],4][1] #block
  fungi_df[i,13] = fungi_abnd[fungi_abnd[,1] ==fungi_df[i,1],5][1] #salix
  fungi_df[i,14] = fungi_abnd[fungi_abnd[,1] ==fungi_df[i,1],6][1] #substrat
}

#save.file
write.table(fungi_df,"fungi_df.txt",row.names =F, col.names=T, quote =F,sep = "\t")