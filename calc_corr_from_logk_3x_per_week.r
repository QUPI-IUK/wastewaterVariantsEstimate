# Dependencies ####
library(vcfR)
library(stringr)
library(dplyr)
library(ggplot2)
library(stats)
library(ggpubr)

source("slopes_functions.r")

#### This script calculates the p-values for correlations
#### between logk and time
#### correlations times of 21 and 42 days are used
#### every Monday, Wednesday, Friday #####

#####################
#### Altenrhein #####


alt_data_3x_complete <- readRDS("/home/raisa/Arbeit/WWsurv/data/LogK_matrices_rds/Altenrhein/Mo_Wed_Fri/withRefSGLogK_all_datesHaplo_3days_per_week.rds")

### offset 21
allFitsComboAlt_3x_offset21 <- getAllSlopes(alt_data_3x_complete, startOffset = 0,endOffset = 21)
saveRDS(allFitsComboAlt_3x_offset21, "data/logk_p/alt_logk_p_values_3xweek_corr_offset21_nofilt.rds")


### offset 42
allFitsComboAlt_3x_offset42 <- getAllSlopes(alt_data_3x_complete, startOffset = 0,endOffset = 42)
saveRDS(allFitsComboAlt_3x_offset42, "data/logk_p/alt_logk_p_values_3xweek_corr_offset42_nofilt.rds")



#################
#### Geneva #####

ge_data_3x_complete <- readRDS("data/LogK_matrices_rds/Geneva/Mo_Wed_Fri/GeLogK_Haplo_withRef_keepDupli_complete_3days_per_week.rds")

### offset 21
allFitsComboGe_3x_offset21 <- getAllSlopes(ge_data_3x_complete, startOffset = 0,endOffset = 21)
saveRDS(allFitsComboGe_3x_offset21, file="data/logk_p/Geneva/logk_p_values_corr_Ge_NoFilt_MoWedFri_offset21.rds")

### offset 42
allFitsComboGe_3x_offset42 <- getAllSlopes(ge_data_3x_complete, startOffset = 0,endOffset = 42)
saveRDS(allFitsComboGe_3x_offset42, file="data/logk_p/Geneva/logk_p_values_corr_Ge_NoFilt_MoWedFri_offset42.rds")


####################
##### Zurich #######

zue_data_3x_complete <- readRDS("data/LogK_matrices_rds/Zurich/Mo_Wed_Fri/ZHLogK_all_datesHaplo_3days_per_week.rds")

### offset 42
allFitsComboZue3x_offset42 <- getAllSlopes(zue_data_3x_complete, startOffset = 0,endOffset = 42)
saveRDS(allFitsComboZue3x_offset42, file="data/logk_p/Zurich/logk_p_values_corr_zue_NoFilt_MoWedFri_offset42.rds")


### offset 21
allFitsComboZue3x_offset21 <- getAllSlopes(zue_data_3x_complete, startOffset = 0,endOffset = 21)
saveRDS(allFitsComboZue3x_offset21, file="data/logk_p/Zurich/logk_p_values_corr_zue_NoFilt_MoWedFri_offset21.rds")
