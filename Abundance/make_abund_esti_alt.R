# Dependencies ####
library(matlib)
library(dplyr)
library(ggplot2)
library(stringr)
library(lubridate)
library(vcfR)

source("Abundance/abundance_functions.R")

### Altenrhein ##### 
## read data based on the library ####

Altlibrary <- read.csv("data/VCF_files/Altenrhein/library_shemes_Alt.csv",sep=",")
alt_allVCF <- lapply(1:nrow(Altlibrary),
                  function(x) convertVCFtoDF(
                    paste0("data/VCF_files/Altenrhein/VCF_results_raw_processed_filtered_nodupli/",Altlibrary[x,"Run"],"_trimmed_filtered_nodupli.vcf"),
                    co_date=Altlibrary[x,"Collection_Date"],
                    id=x))

sum(!unlist(lapply(alt_allVCF,is.null)))
alt_allVCF <- bind_rows(alt_allVCF)

## Calculate SNP proportions ####

altprops <- calculateAllProportions(alt_allVCF)


# Split all SNPs in each timeframe
splitSNPdf_all_alt <- lapply((min(altprops$t)+28):max(altprops$t),function(t){
  print(t)
  splitSNPs_onFreq(altprops %>% mutate(weeksince=t),t,length=28,alpha=0.01, centers=2)
})

## Estimating abundance, direct method #####
abundEst_simple_all_alt <- lapply(splitSNPdf_all_alt,function(x_df){
  print(min(x_df$estiDate))
  resDF1 <- simpleAbundance(x_df,thiscluster=1)
  resDF2 <- simpleAbundance(x_df,thiscluster=2)
  return(rbind(resDF1,resDF2))
}
)

saveRDS(abundEst_simple_all_alt,"data/Abundance/Abund_alt_simple.rds")

dayssinceToDate <- function(w){
  return(as.Date("2020-01-05")+days(w))
}

abund_esti_alt_df <- bind_rows(abundEst_simple_all_alt)
abund_esti_alt_df$date <- as.Date(dayssinceToDate(abund_esti_alt_df$t))

abund_esti_alt_df <- abund_esti_alt_df %>% filter((date <= as.Date("2022-01-25") & date >= as.Date("2021-02-16")))

abund_esti_alt_df_clus1 <- abund_esti_alt_df %>% filter(cluster==1)
abund_esti_alt_df_clus2 <- abund_esti_alt_df %>% filter(cluster==2)


alt_abund_plot <- ggplot() +
  geom_line(data = abund_esti_alt_df_clus1, 
            aes(x=date,y=abundance,group=estiDate),
            color="#00000010", 
            inherit.aes = FALSE)+
  geom_line(data = abund_esti_alt_df_clus2, 
            aes(x=date,y=abundance,group=estiDate),
            color="#00000010", 
            inherit.aes = FALSE)+
  theme_bw()

alt_abund_plot

##################################################
#### use cluster=4 ###############################

altprops_sub <- altprops

# Split all SNPs in each timeframe
splitSNPdf_all_4clust <- lapply((min(altprops_sub$t)+28):max(altprops_sub$t),function(t){
  print(t)
  splitSNPs_onFreq(altprops_sub %>% mutate(weeksince=t),t,length=28,alpha=0.01, centers=4)
})

## Estimating abundance, direct method #####
abundEst_simple_all_4clust <- lapply(splitSNPdf_all_4clust,function(x_df){
  print(min(x_df$estiDate))
  resDF1 <- simpleAbundance(x_df,thiscluster=1)
  resDF2 <- simpleAbundance(x_df,thiscluster=2)
  resDF3 <- simpleAbundance(x_df,thiscluster=3)
  resDF4 <- simpleAbundance(x_df,thiscluster=4)
  return(rbind(resDF1,resDF2,resDF3,resDF4))
}
)

saveRDS(abundEst_simple_all_4clust,"data/Abundance/Abund_alt_simple_4clust.rds")
