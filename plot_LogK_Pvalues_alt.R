library(dplyr)
library(ggplot2)
library(ggpubr)

source("/home/raisa/Arbeit/WWsurv/scripts/slopes_functions.r")

threshold_alt <- 0.05

### dates for for plotting

startDate_alt <- as.Date("2021-02-01") 
endDate_alt <- as.Date("2022-02-25")

#################################
#################################
#### daily samples ##############
#### filtered data with offset=21
#### p-values

raw_pvalues_filename = "data/logk_p/Altenrhein/alt_logk_p_values_corr_offset21_daily_filt.rds"
shaded_regions_save_filename = "data/shaded_regions/Altenrhein/shaded_regions_logk_alt_offset21_filt.rds"
final_plot_filename = "data/logk_p/Altenrhein/minusLogPPlot_complete_alt_filt_daily_offset21.rds"

minusLogPPlot_complete_alt_filt_offset21 <- read_and_plot_smoothed_pvalues(raw_pvalues_filename = raw_pvalues_filename,
                                                                          span = 0.10,
                                                                          threshold = threshold_alt,
                                                                          bonf_corr = TRUE,
                                                                          shaded_regions_save_filename = shaded_regions_save_filename,
                                                                          startDate = startDate_alt,
                                                                          endDate = endDate_alt,
                                                                          final_plot_filename = final_plot_filename)

minusLogPPlot_complete_alt_filt_offset21

##################################
##################################
### daily samples ################
### unfiltered data with offset=21


raw_pvalues_filename = "data/logk_p/Altenrhein/alt_logk_p_values_corr_offset21_daily_nofilt.rds"
shaded_regions_save_filename = "data/shaded_regions/Altenrhein/shaded_regions_logk_alt_daily_offset21_unfilt.rds"
final_plot_filename = "data/logk_p/Altenrhein/minusLogPPlot_complete_alt_nofilt_daily_offset21.rds"

minusLogPPlot_complete_alt_nofilt_offset21 <- read_and_plot_smoothed_pvalues(raw_pvalues_filename = raw_pvalues_filename,
                                                                            span = 0.10,
                                                                            threshold = threshold_alt,
                                                                            bonf_corr = TRUE,
                                                                            shaded_regions_save_filename = shaded_regions_save_filename,
                                                                            startDate = startDate_alt,
                                                                            endDate = endDate_alt,
                                                                            final_plot_filename = final_plot_filename)

minusLogPPlot_complete_alt_nofilt_offset21

##################################
##################################
### daily samples ################
### unfiltered data with offset=42

#raw_pvalues_filename = "data/logk_p/Altenrhein/alt_logk_p_values_corr_offset42_nofilt_w.rds"
raw_pvalues_filename = "data/logk_p/Altenrhein/alt_logk_p_values_corr_offset42_daily_nofilt.rds"
shaded_regions_save_filename = "data/shaded_regions/Altenrhein/shaded_regions_logk_alt_daily_offset42_unfilt.rds"
final_plot_filename = "data/logk_p/Altenrhein/minusLogPPlot_complete_alt_nofilt_daily_offset42.rds"

minusLogPPlot_complete_alt_nofilt_offset42 <- read_and_plot_smoothed_pvalues(raw_pvalues_filename = raw_pvalues_filename,
                                                                            span = 0.10,
                                                                            threshold = threshold_alt,
                                                                            bonf_corr = TRUE,
                                                                            shaded_regions_save_filename = shaded_regions_save_filename,
                                                                            startDate = startDate_alt,
                                                                            endDate = endDate_alt,
                                                                            final_plot_filename = final_plot_filename)

minusLogPPlot_complete_alt_nofilt_offset42


##########################################################
##### samples taken three times a week, Mo, Wed, Fri #####
##########################################################
### offset 21, unfiltered

raw_pvalues_filename = "data/logk_p/Altenrhein/alt_logk_p_values_3xweek_corr_offset21_nofilt.rds"
shaded_regions_save_filename = "data/shaded_regions/Altenrhein/shaded_regions_logk_alt_MoWedFri_offset21_filt.rds"
final_plot_filename = "data/logk_p/Altenrhein/minusLogPPlot_complete_alt_nofilt_MoWedFri_offset21.rds"

minusLogPPlot_alt_nofilt_3x_offset21 <- read_and_plot_smoothed_pvalues(raw_pvalues_filename = raw_pvalues_filename,
                                                                       span = 0.10,
                                                                       threshold = threshold_alt,
                                                                       bonf_corr = TRUE,
                                                                       shaded_regions_save_filename = shaded_regions_save_filename,
                                                                       startDate = startDate_alt,
                                                                       endDate = endDate_alt,
                                                                       final_plot_filename = final_plot_filename)
minusLogPPlot_alt_nofilt_3x_offset21

##########################################################
##### samples taken three times a week, Mo, Wed, Fri #####
### offset 42, unfiltered ################################

raw_pvalues_filename = "data/logk_p/Altenrhein/alt_logk_p_values_3xweek_corr_offset42_nofilt.rds"
shaded_regions_save_filename = "data/shaded_regions/Altenrhein/shaded_regions_logk_alt_MoWedFri_offset42_nofilt.rds"
final_plot_filename = "data/logk_p/Altenrhein/minusLogPPlot_complete_alt_nofilt_MoWedFri_offset42.rds"

minusLogPPlot_alt_nofilt_3x_offset42 <- read_and_plot_smoothed_pvalues(raw_pvalues_filename = raw_pvalues_filename,
                                                                       span = 0.10,
                                                                       threshold = threshold_alt,
                                                                       bonf_corr = TRUE,
                                                                       shaded_regions_save_filename = shaded_regions_save_filename,
                                                                       startDate = startDate_alt,
                                                                       endDate = endDate_alt,
                                                                       final_plot_filename = final_plot_filename)
minusLogPPlot_alt_nofilt_3x_offset42


##########################################################
##### weekly, taken on Monday #####
##########################################################
### offset 21, unfiltered

raw_pvalues_filename = "data/logk_p/Altenrhein/logk_p_values_corr_alt_NoFilt_weekly_offset21.rds"
shaded_regions_save_filename = "data/shaded_regions/Altenrhein/shaded_regions_logk_alt_weekly_offset21_filt.rds"
final_plot_filename = "data/logk_p/Altenrhein/minusLogPPlot_complete_alt_nofilt_weekly_offset21.rds"


minusLogPPlot_alt_nofilt_weekly_offset21 <- read_and_plot_smoothed_pvalues(raw_pvalues_filename = raw_pvalues_filename,
                                                                           span = 0.10,
                                                                           threshold = threshold_alt,
                                                                           bonf_corr = TRUE,
                                                                           shaded_regions_save_filename = shaded_regions_save_filename,
                                                                           startDate = startDate_alt,
                                                                           endDate = endDate_alt,
                                                                           final_plot_filename = final_plot_filename)
minusLogPPlot_alt_nofilt_weekly_offset21

##########################################################
##### weekly, taken on Monday #####
##########################################################
### offset 42, unfiltered

raw_pvalues_filename = "data/logk_p/Altenrhein/logk_p_values_corr_alt_NoFilt_weekly_offset42.rds"
shaded_regions_save_filename = "data/shaded_regions/Altenrhein/shaded_regions_logk_alt_weekly_offset42_filt.rds"
final_plot_filename = "data/logk_p/Altenrhein/minusLogPPlot_complete_alt_nofilt_weekly_offset42.rds"


minusLogPPlot_alt_nofilt_weekly_offset42 <- read_and_plot_smoothed_pvalues(raw_pvalues_filename = raw_pvalues_filename,
                                                                           span = 0.10,
                                                                           threshold = threshold_alt,
                                                                           bonf_corr = TRUE,
                                                                           shaded_regions_save_filename = shaded_regions_save_filename,
                                                                           startDate = startDate_alt,
                                                                           endDate = endDate_alt,
                                                                           final_plot_filename = final_plot_filename)
minusLogPPlot_alt_nofilt_weekly_offset42
