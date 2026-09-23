library(dplyr)
library(ggplot2)
library(ggpubr)

source("/home/raisa/Arbeit/WWsurv/scripts/slopes_functions.r")

############# global parameters
# Define threshold for shaded regions
#threshold_ge <- -log(0.05/nrow(allFitsCombo_ge))
#threshold_ge <- -log10(0.05)
threshold_ge <- 0.05

### dates for for plotting

startDate_gen <- as.Date("2021-11-01") 
endDate_gen <- as.Date("2022-08-01")

#################################
#################################
#### daily samples ##############
#### filtered data with offset=21
#### p-values

raw_pvalues_filename = "data/logk_p/Geneva/logk_p_values_corr_Ge_filt_daily_offset21.rds"
shaded_regions_save_filename = "data/shaded_regions/shaded_regions_logk_gen_offset21_filt.rds"
final_plot_filename = "data/logk_p/Geneva/logk_p_values_corr_Ge_Filt_offset21.rds"

minusLogPPlot_complete_ge_filt_offset21 <- read_and_plot_smoothed_pvalues(raw_pvalues_filename = raw_pvalues_filename,
                                                                            span = 0.10,
                                                                            threshold = threshold_ge,
                                                                            bonf_corr = TRUE,
                                                                            shaded_regions_save_filename = shaded_regions_save_filename,
                                                                            startDate = startDate_gen,
                                                                            endDate = endDate_gen,
                                                                            final_plot_filename = final_plot_filename)

minusLogPPlot_complete_ge_filt_offset21

##################################
##################################
### daily samples ################
### unfiltered data with offset=21


raw_pvalues_filename = "data/logk_p/Geneva/logk_p_values_corr_Ge_NoFilt_daily_offset21.rds"
shaded_regions_save_filename = "data/shaded_regions/Geneva/shaded_regions_logk_gen_offset21_filt.rds"
final_plot_filename = "data/logk_p/Geneva/minusLogPPlot_complete_ge_nofilt_daily_offset21.rds"

minusLogPPlot_complete_ge_nofilt_offset21 <- read_and_plot_smoothed_pvalues(raw_pvalues_filename = raw_pvalues_filename,
                                                                            span = 0.10,
                                                                            threshold = threshold_ge,
                                                                            bonf_corr = TRUE,
                                                                            shaded_regions_save_filename = shaded_regions_save_filename,
                                                                            startDate = startDate_gen,
                                                                            endDate = endDate_gen,
                                                                            final_plot_filename = final_plot_filename)

minusLogPPlot_complete_ge_nofilt_offset21

##################################
##################################
### daily samples ################
### unfiltered data with offset=42


raw_pvalues_filename = "data/logk_p/Geneva/logk_p_values_corr_Ge_NoFilt_daily_offset42.rds"
shaded_regions_save_filename = "data/shaded_regions/shaded_regions_logk_gen_offset42_filt.rds"
final_plot_filename = "data/logk_p/Geneva/minusLogPPlot_complete_ge_nofilt_daily_offset42.rds"

minusLogPPlot_complete_ge_nofilt_offset42 <- read_and_plot_smoothed_pvalues(raw_pvalues_filename = raw_pvalues_filename,
                               span = 0.10,
                               threshold = threshold_ge,
                               bonf_corr = TRUE,
                               shaded_regions_save_filename = shaded_regions_save_filename,
                               startDate = startDate_gen,
                               endDate = endDate_gen,
                               final_plot_filename = final_plot_filename)

minusLogPPlot_complete_ge_nofilt_offset42


##########################################################
##### samples taken three times a week, Mo, Wed, Fri #####
##########################################################
### offset 21, unfiltered

raw_pvalues_filename = "data/logk_p/Geneva/logk_p_values_corr_Ge_NoFilt_MoWedFri_offset21.rds"
shaded_regions_save_filename = "data/shaded_regions/shaded_regions_logk_gen_MoWedFri_offset21_filt.rds"
final_plot_filename = "data/logk_p/Geneva/minusLogPPlot_complete_ge_nofilt_MoWedFri_offset21.rds"

minusLogPPlot_ge_nofilt_3x_offset21 <- read_and_plot_smoothed_pvalues(raw_pvalues_filename = raw_pvalues_filename,
                                                                   span = 0.10,
                                                                   threshold = threshold_ge,
                                                                   bonf_corr = TRUE,
                                                                   shaded_regions_save_filename = shaded_regions_save_filename,
                                                                   startDate = startDate_gen,
                                                                   endDate = endDate_gen,
                                                                   final_plot_filename = final_plot_filename)
minusLogPPlot_ge_nofilt_3x_offset21

##########################################################
##### samples taken three times a week, Mo, Wed, Fri #####
### offset 42, unfiltered ################################

raw_pvalues_filename = "data/logk_p/Geneva/logk_p_values_corr_Ge_NoFilt_MoWedFri_offset42.rds"
shaded_regions_save_filename = "data/shaded_regions/shaded_regions_logk_gen_MoWedFri_offset42_filt.rds"
final_plot_filename = "data/logk_p/Geneva/minusLogPPlot_complete_ge_nofilt_MoWedFri_offset42.rds"

minusLogPPlot_ge_nofilt_3x_offset42 <- read_and_plot_smoothed_pvalues(raw_pvalues_filename = raw_pvalues_filename,
                                                                   span = 0.10,
                                                                   threshold = threshold_ge,
                                                                   bonf_corr = TRUE,
                                                                   shaded_regions_save_filename = shaded_regions_save_filename,
                                                                   startDate = startDate_gen,
                                                                   endDate = endDate_gen,
                                                                   final_plot_filename = final_plot_filename)
minusLogPPlot_ge_nofilt_3x_offset42


##########################################################
##### weekly, taken on Monday #####
##########################################################
### offset 21, unfiltered

raw_pvalues_filename = "data/logk_p/Geneva/logk_p_values_corr_Ge_NoFilt_weekly_offset21.rds"
shaded_regions_save_filename = "data/shaded_regions/Geneva/shaded_regions_logk_gen_weekly_offset21_filt.rds"
final_plot_filename = "data/logk_p/Geneva/minusLogPPlot_complete_ge_nofilt_weekly_offset21.rds"


minusLogPPlot_ge_nofilt_weekly_offset21 <- read_and_plot_smoothed_pvalues(raw_pvalues_filename = raw_pvalues_filename,
                                                                   span = 0.10,
                                                                   threshold = threshold_ge,
                                                                   bonf_corr = TRUE,
                                                                   shaded_regions_save_filename = shaded_regions_save_filename,
                                                                   startDate = startDate_gen,
                                                                   endDate = endDate_gen,
                                                                   final_plot_filename = final_plot_filename)
minusLogPPlot_ge_nofilt_weekly_offset21

##########################################################
##### weekly, taken on Monday #####
##########################################################
### offset 42, unfiltered

raw_pvalues_filename = "data/logk_p/Geneva/logk_p_values_corr_Ge_NoFilt_weekly_offset42.rds"
shaded_regions_save_filename = "data/shaded_regions/shaded_regions_logk_gen_weekly_offset42_filt.rds"
final_plot_filename = "data/logk_p/Geneva/minusLogPPlot_complete_ge_nofilt_weekly_offset42.rds"


minusLogPPlot_ge_nofilt_weekly_offset42 <- read_and_plot_smoothed_pvalues(raw_pvalues_filename = raw_pvalues_filename,
                                                                          span = 0.10,
                                                                          threshold = threshold_ge,
                                                                          bonf_corr = TRUE,
                                                                          shaded_regions_save_filename = shaded_regions_save_filename,
                                                                          startDate = startDate_gen,
                                                                          endDate = endDate_gen,
                                                                          final_plot_filename = final_plot_filename)
minusLogPPlot_ge_nofilt_weekly_offset42
