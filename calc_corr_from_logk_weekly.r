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
#### for weekly samples

#####################
#### Altenrhein #####

### load LogK matrix
alt_data_weekly_complete <- readRDS("data/LogK_matrices_rds/Altenrhein/weekly/SGLogK_Haplo_withRef_keepDupli_complete_weekly.rds")

### offset 21
allFitsComboAlt_weekly_offset21 <- getAllSlopes(alt_data_weekly_complete, startOffset = 0,endOffset = 21)
saveRDS(allFitsComboAlt_weekly_offset21, file="data/logk_p/Altenrhein/logk_p_values_corr_alt_NoFilt_weekly_offset21.rds")

### offset 42
allFitsComboAlt_weekly_offset42 <- getAllSlopes(alt_data_weekly_complete, startOffset = 0,endOffset = 42)
saveRDS(alt_data_weekly_complete_offset42, file="data/logk_p/Altenrhein/logk_p_values_corr_alt_NoFilt_weekly_offset42.rds")


######################
###### Geneva ########

### load LogK matrix

ge_data_weekly_complete <- readRDS("data/LogK_matrices_rds/Geneva/weekly/GeLogK_Haplo_withRef_keepDupli_complete_weekly.rds")

### offset 21
allFitsComboGe_weekly_offset21 <- getAllSlopes(ge_data_weekly_complete, startOffset = 0,endOffset = 21)
saveRDS(allFitsComboGe_NoFilt_weekly_offset21, file="data/logk_p/Geneva/logk_p_values_corr_Ge_NoFilt_weekly_offset21.rds")


### offset 42
allFitsComboGe_weekly_offset42 <- getAllSlopes(ge_data_weekly_complete, startOffset = 0,endOffset = 42)
saveRDS(allFitsComboGe_NoFilt_weekly_offset42, file="data/logk_p/Geneva/logk_p_values_corr_Ge_NoFilt_weekly_offset42.rds")


##################
##### Zurich #####

zue_data_weekly_complete <- readRDS("data/LogK_matrices_rds/Zurich/weekly/ZHLogK_all_datesHaplo_weekly.rds")

### offset 21
allFitsComboZue_weekly_offset21 <- getAllSlopes(zue_data_weekly_complete, startOffset = 0,endOffset = 21)
saveRDS(allFitsComboZue_weekly_offset21, file="data/logk_p/Zurich/logk_p_values_corr_zue_NoFilt_weekly_offset21.rds")

### offset 42
allFitsComboZue_weekly_offset42 <- getAllSlopes(zue_data_weekly_complete, startOffset = 0,endOffset = 42)
saveRDS(allFitsComboZue_weekly_offset42, file="data/logk_p/Zurich/logk_p_values_corr_zue_NoFilt_weekly_offset42.rds")

