#merging files with the Unix cat command
#sebastien.renaut@gmail.com
#december 2017


#set working directory
setwd("~/PD")

#list & load all R1's
system("ls *R1.fastq >list_R1")
r1 = read.table("list_R1", stringsAsFactors = F)
r1_modif_name = r1
r1_modif_name[,1] = gsub("-","_",r1_modif_name[,1])


#list & load all R2's
system("ls *R2.fastq >list_R2")
r2 = read.table("list_R2", stringsAsFactors = F)
r2_modif_name = r2
r2_modif_name[,1] = gsub("-","_",r2_modif_name[,1])


#modify all names for an "underscore" using mv command
for(i in 1:nrow(r1))
{
command_mv = paste("mv",r1[i,1],r1_modif_name[i,1])
command_mv_r2 = paste("mv",r2[i,1],r2_modif_name[i,1])

system(command_mv)
system(command_mv_r2)
}


#find the unique sample names
temp_list = unlist(strsplit(r1_modif_name[,1],".",fixed = T))
temp_list2 = temp_list[seq(2,length(temp_list),by = 3)]
unique_names = unique(temp_list2)

#find the unique sample names
temp_list_r2 = unlist(strsplit(r2_modif_name[,1],".",fixed = T))
temp_list2_r2 = temp_list_r2[seq(2,length(temp_list_r2),by = 3)]
unique_names_r2 = unique(temp_list2_r2)


#combine the samples that have the same name
for(i in 1:length(unique_names))
{
temp_seq = paste(r1_modif_name[regexpr(unique_names[i], r1_modif_name[,1])>0,1],collapse = " ") 
temp_seq_r2 = paste(r2_modif_name[regexpr(unique_names_r2[i], r2_modif_name[,1])>0,1],collapse = " ") 


#cat command
cat_command = paste("cat ",temp_seq, " >",unique_names[i],"_combined.fastq",sep = "")
cat_command_r2 = paste("cat ",temp_seq_r2, " >",unique_names_r2[i],"_combined.fastq",sep = "")

print(cat_command)
print(cat_command_r2)

system(cat_command)
system(cat_command_r2)
}
















#combine R1 and R2 into a single file
for(i in 1:nrow(r1))
{
#combined name
combined = sub("R2","R2_combined",r2[i,1])

#prepare a cat command
cat_command = paste("cat",r1[i,1],r2[i,1],">",combined)

#run cat
system(cat_command)

}

#remove temp list files
system("rm list_R1 list_R2")
