
#Combining both scenarios into a single table
#biogeoBEARS analysis for Boris Domenech
#sebastien.renaut@gmail.com
#30november 2018


#load data 
ocean = read.table("~/Desktop/R_biogeobears/restable_AIC_rellike_formatted_ocean_20av2018_essaie5.txt",stringsAsFactors = F, header = T)
terr = read.table("~/Desktop/R_biogeobears/restable_AICc_rellike_formatted_terr_20av2018_essaie5.txt",stringsAsFactors = F,header = T)
colnames(terr) = colnames(ocean)

#merge
restable = rbind(ocean,terr)  
restable2 = restable

# With AICs:
AICtable = calc_AIC_column(LnL_vals=restable$LnL, nparam_vals=restable$numparams)
restable = cbind(restable, AICtable)
restable_AIC_rellike = AkaikeWeights_on_summary_table(restable=restable, colname_to_use="AIC")

# With AICcs -- factors in sample size
tr = read.tree("~/Desktop/R_biogeobears/onetree_crudia_3calib_20.10.newick")
samplesize = length(tr$tip.label)
AICtable = calc_AICc_column(LnL_vals=restable$LnL, nparam_vals=restable$numparams, samplesize=samplesize)
restable2 = cbind(restable2, AICtable)
restable_AICc_rellike = AkaikeWeights_on_summary_table(restable=restable2, colname_to_use="AIC")

restable_AICc_rellike

write.table(restable_AICc_rellike,"restable_AICc_rellike.tsv",quote = F,sep = "\t")

#free_params = row.names(resDECj$output@params_table[resDECj$output@params_table$type=="free",])
#names(restable_AICc_rellike) = c("LnL", "numparams", free_params, "AICc", "AICc_wt")


