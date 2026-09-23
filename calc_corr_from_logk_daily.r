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
#### daily #####

#####################
#### Altenrhein #####

#########################################
### no coverage based filtering #########
data_complete_not_filtered <- readRDS("data/LogK_matrices_rds/Altenrhein/daily/non_filtered/mSGLogK_all_datesHaplo_withRef_complete.rds")

### correlations over 21 days
allFitsCombo_alt_offset21_nofilt <- getAllSlopes(data_complete_not_filtered,startOffset = 0,endOffset = 21)
saveRDS(allFitsCombo_alt_offset21_nofilt, "data/logk_p/Altenrhein/alt_logk_p_values_corr_offset21_daily_nofilt.rds")

#### correlations over 42 days
allFitsCombo_alt_offset42_nofilt <- getAllSlopes(data_complete_not_filtered,startOffset = 0,endOffset = 42)
saveRDS(allFitsCombo_alt_offset42_nofilt, "data/logk_p/Altenrhein/alt_logk_p_values_corr_offset42_daily_nofilt.rds")

#allFitsCombo_alt_offset42_nofilt_weighted_ktau_test <- getAllSlopes_w(data_complete_not_filtered,startOffset = 0,endOffset = 42)
#saveRDS(allFitsCombo_alt_offset42_nofilt_weighted_ktau, "data/logk_p/Altenrhein/alt_logk_p_values_corr_offset42_nofilt_w.rds")


### filter out samples with a coverage of < 90 and read depth at < 30 ####

dataBlockAlt1 <- readRDS("data/LogK_matrices_rds/Altenrhein/daily/mSGLogK_1_filtered_depth_withRef.rds")
dataBlockAlt2 <- readRDS("data/LogK_matrices_rds/Altenrhein/daily/mSGLogK_2_filtered_depth_withRef.rds")
dataBlockAlt3 <- readRDS("data/LogK_matrices_rds/Altenrhein/daily/mSGLogK_3_filtered_depth_withRef.rds")

allFitsCombo_alt_offset21 <- bind_rows(list(
  getAllSlopes(dataBlockAlt1,startOffset = 0,endOffset = 21),
  getAllSlopes(dataBlockAlt2,startOffset = 0,endOffset = 21),
  getAllSlopes(dataBlockAlt3,startOffset = 0,endOffset = 21)
))
saveRDS(allFitsCombo_alt_offset21 ,"data/logk_p/Altenrhein/alt_logk_p_values_corr_offset21_daily_filt.rds")

allFitsCombo_alt_offset42 <- bind_rows(list(
  getAllSlopes(dataBlockAlt1,startOffset = 0,endOffset = 42),
  getAllSlopes(dataBlockAlt2,startOffset = 0,endOffset = 42),
  getAllSlopes(dataBlockAkt3,startOffset = 0,endOffset = 42)
))
saveRDS(allFitsCombo_alt_offset42 ,"data/logk_p/Altenrhein/alt_logk_p_values_corr_offset42_daily_filt.rds")


#################
#### Geneva #####

#### no coverage based filtering #########
dataGeCompleteNotFiltered <- readRDS("data/LogK_matrices_rds/Geneva/GeLogK_all_datesHaplo_withRef_complete.rds")

### offest 21
allFitsGe_NoFilt_offset21 <- getAllSlopes(dataGeCompleteNotFiltered,startOffset = 0,endOffset = 21)
saveRDS(allFitsGe_NoFilt_offset21, "data/logk_p/Geneva/logk_p_values_corr_Ge_NoFilt_daily_offset21.rds")

### offset 42
allFitsGe_NoFilt_offset42 <- getAllSlopes(dataGeCompleteNotFiltered,startOffset = 0,endOffset = 42)
saveRDS(allFitsGe_NoFilt_offset42, "data/logk_p/Geneva/logk_p_values_corr_Ge_NoFilt_daily_offset42.rds")


### filter out samples with a coverage of < 90 and read depth at < 30 ####

dataBlockGe1<-readRDS("data/LogK_matrices_rds/Geneva/GeLogK_all_datesHaplo1_withRef_filtered_depth30_cov90.rds")
dataBlockGe2<-readRDS("data/LogK_matrices_rds/Geneva/GeLogK_all_datesHaplo2_withRef_filtered_depth30_cov90.rds")
dataBlockGe3<-readRDS("data/LogK_matrices_rds/Geneva/GeLogK_all_datesHaplo3_withRef_filtered_depth30_cov90.rds")

allFitsCombo_Ge_offset21<-bind_rows(list(
  getAllSlopes(dataBlockGe1,startOffset = 0,endOffset = 21),
  getAllSlopes(dataBlockGe2,startOffset = 0,endOffset = 21),
  getAllSlopes(dataBlockGe3,startOffset = 0,endOffset = 21)
))

saveRDS(allFitsCombo_Ge_offset21 ,"data/logk_p/Geneva/logk_p_values_corr_Ge_filt_daily_offset21.rds")

#################
#### Zurich ####
### no filter
dataBlockZu1<-readRDS("data/LogK_matrices_rds/Zurich/daily/mZHLogK_all_datesHaplo1.rds")
dataBlockZu2<-readRDS("data/LogK_matrices_rds/Zurich/daily/mZHLogK_all_datesHaplo2.rds")
dataBlockZu3<-readRDS("data/LogK_matrices_rds/Zurich/daily/mZHLogK_all_datesHaplo3.rds")
dataBlockZu4<-readRDS("data/LogK_matrices_rds/Zurich/daily/mZHLogK_all_datesHaplo4.rds")
dataBlockZu5<-readRDS("data/LogK_matrices_rds/Zurich/daily/mZHLogK_all_datesHaplo5.rds")

### offset 21
allFitsComboZu_nofilt_offset21 <-bind_rows(list(
  getAllSlopes(dataBlockZu1,startOffset = 0,endOffset = 21),
  getAllSlopes(dataBlockZu2,startOffset = 0,endOffset = 21),
  getAllSlopes(dataBlockZu3,startOffset = 0,endOffset = 21),
  getAllSlopes(dataBlockZu4,startOffset = 0,endOffset = 21),
  getAllSlopes(dataBlockZu5,startOffset = 0,endOffset = 21)
  ))
#saveRDS(allFitsComboZu ,"data/logk_p/Zurich/logk_p_values_corr_Zu.rds")
saveRDS(allFitsComboZu_nofilt_offset21, "data/logk_p/Zurich/logk_p_values_corr_Zu_nofilt_daily_offset21.rds")

#### offset 42
allFitsComboZu_nofilt_offset42<-bind_rows(list(
  getAllSlopes(dataBlockZu1,startOffset = 0,endOffset = 42),
  getAllSlopes(dataBlockZu2,startOffset = 0,endOffset = 42),
  getAllSlopes(dataBlockZu3,startOffset = 0,endOffset = 42),
  getAllSlopes(dataBlockZu4,startOffset = 0,endOffset = 42),
  getAllSlopes(dataBlockZu5,startOffset = 0,endOffset = 42)
))
saveRDS(allFitsComboZu_nofilt_offset42, "data/logk_p/Zurich/logk_p_values_corr_Zu_nofilt_daily_offset42.rds")


#### Zurich
### filter out samples with a coverage of < 90 and read depth at < 30 ####
dataBlockZu1_filt<-readRDS("data/LogK_matrices_rds/Zuerich/ZHLogK_1_filtered_depth_cov_withRef.rds")
dataBlockZu2_filt<-readRDS("data/LogK_matrices_rds/Zuerich/ZHLogK_2_filtered_depth_cov_withRef.rds")
dataBlockZu3_filt<-readRDS("data/LogK_matrices_rds/Zuerich/ZHLogK_3_filtered_depth_cov_withRef.rds")
dataBlockZu4_filt<-readRDS("data/LogK_matrices_rds/Zuerich/ZHLogK_4_filtered_depth_cov_withRef.rds")
dataBlockZu5_filt<-readRDS("data/LogK_matrices_rds/Zuerich/ZHLogK_5_filtered_depth_cov_withRef.rds")

### offset 21
allFitsComboZu_filt_offset21<-bind_rows(list(
  getAllSlopes(dataBlockZu1_filt,startOffset = 0,endOffset = 21),
  getAllSlopes(dataBlockZu2_filt,startOffset = 0,endOffset = 21),
  getAllSlopes(dataBlockZu3_filt,startOffset = 0,endOffset = 21),
  getAllSlopes(dataBlockZu4_filt,startOffset = 0,endOffset = 21),
  getAllSlopes(dataBlockZu5_filt,startOffset = 0,endOffset = 21)
))

#saveRDS(allFitsComboZu_filt_offset21,"data/logk_p/Zurich/logk_p_values_corr_Zu_filt.rds")
saveRDS(allFitsComboZu_filt_offset21,"data/logk_p/Zurich/logk_p_values_corr_Zu_filt_daily_offset21.rds")



