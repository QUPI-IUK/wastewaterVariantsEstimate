
library(dplyr)
library(ggplot2)
library(ggpubr)

Sys.setlocale("LC_TIME", 'en_GB.UTF-8')
threshold_ge <- 0.05

##################################
##################################
### daily samples ################
### unfiltered data with offset=42


raw_pvalues_filename = "data/logk_p/Zurich/logk_p_values_corr_Zu_nofilt_offset42.rds"
shaded_regions_file = "data/shaded_regions/Zurich/shaded_regions_logk_zue_offset42_nofilt.rds"
output_file = "data/logk_p/Zurich/pointEstis/zue_pointEsti_daily_offset42.csv"

esti_daily_offset42 <- check_single_pvalues(raw_pvalues_filename = raw_pvalues_filename,
                                                                            threshold = threshold_ge,
                                                                            bonf_corr = TRUE,
                                                                            shaded_regions_file = shaded_regions_file,
                                                                            output_file = output_file)

esti_daily_offset42


##################################
##################################
### daily samples ################
### unfiltered data with offset=21


raw_pvalues_filename = "data/logk_p/Zurich/logk_p_values_corr_Zu.rds"
shaded_regions_file = "data/shaded_regions/Zurich/shaded_regions_logk_zue_offset21_nofilt.rds"
output_file = "data/logk_p/Zurich/pointEstis/zue_pointEsti_daily_offset21.csv"

esti_daily_offset21 <- check_single_pvalues(raw_pvalues_filename = raw_pvalues_filename,
                                            threshold = threshold_ge,
                                            bonf_corr = TRUE,
                                            shaded_regions_file = shaded_regions_file,
                                            output_file = output_file)

esti_daily_offset21

##################################
### 3x a week samples ################
### unfiltered data with offset=42


raw_pvalues_filename = "data/logk_p/Zurich/zue_logk_p_values_3xweek_corr_offset42_nofilt.rds"
shaded_regions_file = "data/shaded_regions/Zurich/shaded_regions_logk_zue_MoWedFri_offset42_nofilt.rd"
output_file = "data/logk_p/Zurich/pointEstis/zue_pointEsti_MoWedFRi_offset42.csv"

esti_MoWedFri_offset42 <- check_single_pvalues(raw_pvalues_filename = raw_pvalues_filename,
                                            threshold = threshold_ge,
                                            bonf_corr = TRUE,
                                            shaded_regions_file = shaded_regions_file,
                                            output_file = output_file)

esti_MoWedFri_offset42

##################################
### 3x a week samples ################
### unfiltered data with offset=21


raw_pvalues_filename = "data/logk_p/Zurich/zue_logk_p_values_3xweek_corr_offset21_nofilt.rds"
shaded_regions_file = "data/shaded_regions/Zurich/shaded_regions_logk_zue_MoWedFri_offset21_filt.rd"
output_file = "data/logk_p/Zurich/pointEstis/zue_pointEsti_MoWedFRi_offset21.csv"

esti_MoWedFri_offset21 <- check_single_pvalues(raw_pvalues_filename = raw_pvalues_filename,
                                               threshold = threshold_ge,
                                               bonf_corr = TRUE,
                                               shaded_regions_file = shaded_regions_file,
                                               output_file = output_file)

esti_MoWedFri_offset21

##################################
### weekly samples ################
### unfiltered data with offset=42


raw_pvalues_filename = "data/logk_p/Zurich/logk_p_values_corr_zue_NoFilt_weekly_offset42.rds"
shaded_regions_file = "data/shaded_regions/Zurich/shaded_regions_logk_zue_weekly_offset42_filt.rd"
output_file = "data/logk_p/Zurich/pointEstis/zue_pointEsti_weekly_offset42.csv"

esti_weekly_offset42 <- check_single_pvalues(raw_pvalues_filename = raw_pvalues_filename,
                                               threshold = threshold_ge,
                                               bonf_corr = TRUE,
                                               shaded_regions_file = shaded_regions_file,
                                               output_file = output_file)

esti_weekly_offset42

### weekly samples ################
### unfiltered data with offset=21


raw_pvalues_filename = "data/logk_p/Zurich/logk_p_values_corr_zue_NoFilt_weekly_offset21.rds"
shaded_regions_file = "data/shaded_regions/Zurich/shaded_regions_logk_zue_weekly_offset21_filt.rd"
output_file = "data/logk_p/Zurich/pointEstis/zue_pointEsti_weekly_offset21.csv"

esti_weekly_offset21 <- check_single_pvalues(raw_pvalues_filename = raw_pvalues_filename,
                                               threshold = threshold_ge,
                                               bonf_corr = TRUE,
                                               shaded_regions_file = shaded_regions_file,
                                               output_file = output_file)

esti_weekly_offset21
