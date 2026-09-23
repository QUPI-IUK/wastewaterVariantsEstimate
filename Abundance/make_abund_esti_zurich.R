# Dependencies ####
library(matlib)
library(dplyr)
library(ggplot2)
library(stringr)
library(lubridate)
library(vcfR)

source("Abundance/abundance_functions.R")

### Zürich ##### 
### read data based on the library ####

ZHlibrary<-read.csv("data/VCF_files/Zurich/library_shemes_ZH_mod.csv",sep=",")
ZH_allVCF<-lapply(1:nrow(ZHlibrary),
                  function(x) convertVCFtoDF(
                    paste0("Data/Switzerland/Zuerich/VCF_results_raw_processed_nodupli/",ZHlibrary[x,"Run"],"_trimmed_nodupli.vcf"),
                    co_date=ZHlibrary[x,"Collection_Date"],
                    id=x))

sum(!unlist(lapply(ZH_allVCF,is.null)))
ZH_allVCF<-bind_rows(ZH_allVCF)

## Calculate SNP proportions ####

ZHprops<-calculateAllProportions(ZH_allVCF)


# Split all SNPs in each timeframe
splitSNPdf_all_ZH <- lapply((min(ZHprops$t)+28):max(ZHprops$t),function(t){
  print(t)
  splitSNPs_onFreq(ZHprops%>%mutate(weeksince=t),t,length=28,alpha=0.01)
})

## Estimating abundance, direct method #####
abundEst_simple_all_ZH <- lapply(splitSNPdf_all_ZH,function(x_df){
  print(min(x_df$estiDate))
  resDF1<-simpleAbundance(x_df,thiscluster=1)
  resDF2<-simpleAbundance(x_df,thiscluster=2)
  return(rbind(resDF1,resDF2))
}
)

saveRDS(abundEst_simple_all_ZH,"data/Abundance/Abund_ZH_simple.rds")

dayssinceToDate <- function(w){
  return(as.Date("2020-01-05")+days(w))
}

abund_esti_zue_df <- bind_rows(abundEst_simple_all_ZH)
abund_esti_zue_df$date <- as.Date(dayssinceToDate(abund_esti_zue_df$t))

abund_esti_zue_df_clus1 <- abund_esti_zue_df %>% filter(cluster==1)
abund_esti_zue_df_clus2 <- abund_esti_zue_df %>% filter(cluster==2)

zue_abund_plot <- zue_plot_VOC_prev +
  geom_line(data=abund_esti_zue_df_clus1,aes(x=date,y=abundance,group=estiDate),color="#00000010", inherit.aes = FALSE)+
  geom_line(data=abund_esti_zue_df_clus2,aes(x=date,y=abundance,group=estiDate),color="#00000010", inherit.aes = FALSE)+
  labs(x="Date", y="Abundance")+
  theme_bw()+
  theme(legend.position = "top")
