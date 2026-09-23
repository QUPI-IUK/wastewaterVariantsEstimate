# Dependencies ####
library(matlib)
library(dplyr)
library(ggplot2)
library(stringr)
library(lubridate)
library(vcfR)

source("Abundance/abundance_functions.R")

# Zürich ##### 
## read data based on the library ####

#Genflibrary <- read.csv("../data/VCF_files/Genf/library_shemes_Genf.csv",sep=",")
Genflibrary <- read.csv("data/VCF_files/Genf/library_shemes_Genf.csv",sep=",")
GE_allVCF <- lapply(1:nrow(Genflibrary),
                  function(x) convertVCFtoDF(
                    paste0("data/VCF_files/Genf/VCF_results_raw_processed_filtered_nodupli/",Genflibrary[x,"run_accession"],"_trimmed_filtered_nodupli.vcf"),
                    co_date=Genflibrary[x,"Collection_Date"],
                    id=x))

sum(!unlist(lapply(GE_allVCF,is.null)))
GE_allVCF <- bind_rows(GE_allVCF)

## Calculate SNP proportions ####

GEprops <- calculateAllProportions(GE_allVCF)


# Split all SNPs in each timeframe
splitSNPdf_all_GE <- lapply((min(GEprops$t)+28):max(GEprops$t),function(t){
  print(t)
  splitSNPs_onFreq(GEprops %>% mutate(weeksince=t),t,length=28,alpha=0.01)
})

## Estimating abundance, direct method #####
abundEst_simple_all_GE <- lapply(splitSNPdf_all_GE,function(x_df){
  print(min(x_df$estiDate))
  resDF1 <- simpleAbundance(x_df,thiscluster=1)
  resDF2 <- simpleAbundance(x_df,thiscluster=2)
  return(rbind(resDF1,resDF2))
}
)

saveRDS(abundEst_simple_all_GE,"Abundance/Abund_GE_simple.rds")

dayssinceToDate <- function(w){
  return(as.Date("2020-01-05")+days(w))
}

abund_esti_GE_df <- bind_rows(abundEst_simple_all_GE)
abund_esti_GE_df$date <- as.Date(dayssinceToDate(abund_esti_GE_df$t))

abund_esti_ge_df_clus1 <- abund_esti_GE_df %>% filter(cluster==1)
abund_esti_ge_df_clus2 <- abund_esti_GE_df %>% filter(cluster==2)

ge_abund_plot <- ggplot() +
  geom_line(data = abund_esti_ge_df_clus1, 
            aes(x=date,y=abundance,group=estiDate),
            color="#00000010", 
            inherit.aes = FALSE)+
  geom_line(data = abund_esti_ge_df_clus2, 
            aes(x=date,y=abundance,group=estiDate),
            color="#00000010", 
            inherit.aes = FALSE)+
  theme_bw()
ge_abund_plot
