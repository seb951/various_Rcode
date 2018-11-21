#renaming with Unix mv in R environment
#sebastien.renaut@gmail.com
#2016

#for Chih-Ying Lay


system("ls -1 >names")

names = read.table("names",header = F, stringsAsFactors = F)
names_sub = gsub("-","-", names)

for(i in 1:length(names))
{
system(paste("mv", names[i,1],name_sub[i,1],sep = " "))
}