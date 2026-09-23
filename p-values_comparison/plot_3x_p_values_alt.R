### comparinng the p-values of logK correlation for daily, weekly, and Mo, Wed, Fri data

library(dplyr)
library(ggplot2)
library(ggpubr)

Sys.setlocale("LC_TIME", 'en_GB.UTF-8')

########## data loading ###################
#### p-values #####
#### offset 21

#### load p-values from logK daily data
source("scripts/LogK_Pvalues_alt.R")
#alt_minusLogPPlot_complete <- readRDS("data/logk_p/minusLogPPlot_complete_alt.rds")
alt_minusLogPPlot_complete <- readRDS("data/logk_p/Altenrhein/minusLogPPlot_complete_alt_offset42.rds")

#### load p-values from logK Mo, Wed, Fri data
source("scripts/Slopes_clean_3times_per_week.R")
alt_minusLogPPlot_complete_MoWedFri_offset42 <- readRDS("data/logk_p/Altenrhein/minusLogPPlot_complete_alt_Mo_Wed_Fri_offset42.rds")

#### load p-values from logK weekly data
source("scripts/Slopes_clean_weekly.R")
alt_minusLogPPlot_complete_weekly_offset42 <- readRDS("data/logk_p/Altenrhein/minusLogPPlot_complete_alt_nofilt_weekly_offset42.rds")


########### plot ####################

#alt_minusLogPPlot_complete_MoWedFri <- alt_minusLogPPlot_complete_MoWedFri + theme(plot.margin = margin(0, 0, 0, 0))

startDate_alt <-as.Date("2021-02-01")  
endDate_alt <- as.Date("2022-02-25")

### margins:
### t=top, r=right, b=bottom, l=left
t = 0
r = 2
b= -6
l = 18

plot_pval_alt_comp <- lapply(list(alt_minusLogPPlot_complete  + rremove("xlab"), 
                             alt_minusLogPPlot_complete_MoWedFri_offset42 + rremove("xlab"),
                             alt_minusLogPPlot_complete_weekly_offset42), 
                        function(x){x + scale_x_date(limits=c(startDate_alt, endDate_alt), date_labels = "%b %Y") + 
                            theme(text=element_text(size=6), 
                                  axis.title=element_text(size=6), 
                                  legend.text=element_text(size=6), 
                                  axis.text=element_text(size=6), 
                                  axis.title.y = element_text(margin = margin(r = 6)),
                                  legend.key.size = unit(0.5,"line"))
                        }) %>% 
  ggarrange(plotlist = .,
            ncol=1,nrow=3, align = "hv",
            #labels = c("A", "B", "C", "D"),
            label.y = c(1.1,1.1,1),
            heights=c(1,1,1),
            common.legend = TRUE, legend = "top",
            font.label = list(size = 12))

plot_pval_alt_comp
#ggsave("plots/LogK_daily_offset21_3xweek_weekly.pdf", plot_pval_alt_comp)

ggsave("plots/LogK_daily_offset42_3xweek_weekly.pdf", plot_pval_alt_comp)


#### Confidence Interval ####
#### daily data
source("scripts/LogK_Pvalues_alt.R")
alt_tau_complete_daily <- readRDS("data/logk_p/tauPlot_complete_alt_daily.rds")
#alt_tau_complete_daily <- readRDS("data/logk_p/tauPlot_complete_alt_daily_offset42.rds")

#### weekly data
source("scripts/Slopes_clean_weekly.R")
alt_tau_complete_weekly <- readRDS("data/logk_p/tauPlot_complete_alt_weekly.rds")

#### Mo, Wed, Fri data
source("scripts/Slopes_clean_3times_per_week.R")
alt_tau_complete_MoWedFri <- readRDS("data/logk_p/tauPlot_complete_alt_3x.rds")

ktau_all_offset21 <- ggarrange(alt_tau_complete_daily, 
                               alt_tau_complete_MoWedFri,
                               alt_tau_complete_weekly, 
                               ncol=1,nrow=3, align = "hv")

ggsave("plots/ktau_daily_offset21_3xweek_weekly.pdf", ktau_all_offset21)
#ggsave("plots/ktau_daily_offset42_3xweek_weekly.pdf", ktau_all_offset42)

#########################################
####### unfiltered daily data ###########
#### offset 42
#### load p-values from logK daily data
source("scripts/LogK_Pvalues_alt.R")

t = 5
r = 2
b= -6
l = 16

txt_size=8
alt_minusLogPPlot_complete_offset42_nofilt <- readRDS("data/logk_p/Altenrhein/minusLogPPlot_complete_alt_nofilt_daily_offset42.rds")
alt_minusLogPPlot_complete_MoWedFri_offset42 <- readRDS("data/logk_p/Altenrhein/minusLogPPlot_complete_alt_nofilt_MoWedFri_offset42.rds")
alt_minusLogPPlot_complete_weekly_offset42 <- readRDS("data/logk_p/Altenrhein/minusLogPPlot_complete_alt_nofilt_weekly_offset42.rds")

alt_minusLogPPlot_complete_offset42_nofilt <- alt_minusLogPPlot_complete_offset42_nofilt + theme(plot.margin = margin(t, r, b, l))
alt_minusLogPPlot_complete_MoWedFri_offset42 <- alt_minusLogPPlot_complete_MoWedFri_offset42 + theme(plot.margin = margin(t, r, b, l))
alt_minusLogPPlot_complete_weekly_offset42 <- alt_minusLogPPlot_complete_weekly_offset42 + theme(plot.margin = margin(t, r, b, l))

plot_pval_alt_comp_nofilt_offset42 <- lapply(list(alt_minusLogPPlot_complete_offset42_nofilt  + rremove("xlab"), 
                                  alt_minusLogPPlot_complete_MoWedFri_offset42 + rremove("xlab"),
                                  alt_minusLogPPlot_complete_weekly_offset42
                                  ), 
                             function(x){x + scale_x_date(limits=c(startDate_alt, endDate_alt), date_labels = "%b %Y") + xlab("") +
                                 theme(text=element_text(size=txt_size), 
                                       axis.title=element_text(size=txt_size), 
                                       legend.text=element_text(size=txt_size), 
                                       axis.text=element_text(size=txt_size), 
                                       axis.title.y = element_text(margin = margin(r = 6)),
                                       legend.key.size = unit(0.5,"line"))
                             }) %>% 
  ggarrange(plotlist = .,
            ncol=1,nrow=3, align = "hv",
            #labels = c("A", "B", "C", "D"),
            label.y = c(1.1,1.1,1.1),
            heights=c(1,1,1),
            #common.legend = TRUE, 
            #legend = "top",
            font.label = list(size = 12))

plot_pval_alt_comp_nofilt_offset42

saveRDS(plot_pval_alt_comp_nofilt_offset42, file="plots/logk_pvalues/plot_pval_alt_comp_nofilt_offset42.rds")
ggsave("plots/logk_pvalues/LogK_alt_daily_nofilt_offset42_3xweek_weekly.pdf", plot_pval_alt_comp_nofilt_offset42)

#########################
#########################
#### offset 21

alt_minusLogPPlot_complete_offset21_nofilt <- readRDS("data/logk_p/Altenrhein/minusLogPPlot_complete_alt_nofilt_daily_offset21.rds")
alt_minusLogPPlot_complete_MoWedFri_offset21 <- readRDS("data/logk_p/Altenrhein/minusLogPPlot_complete_alt_nofilt_MoWedFri_offset21.rds")
alt_minusLogPPlot_complete_weekly_offset21 <- readRDS("data/logk_p/Altenrhein/minusLogPPlot_complete_alt_nofilt_weekly_offset21.rds")

alt_minusLogPPlot_complete_offset21_nofilt <- alt_minusLogPPlot_complete_offset21_nofilt + theme(plot.margin = margin(t, r, b, l))
alt_minusLogPPlot_complete_MoWedFri_offset21 <- alt_minusLogPPlot_complete_MoWedFri_offset21 + theme(plot.margin = margin(t, r, b, l))
alt_minusLogPPlot_complete_weekly_offset21 <- alt_minusLogPPlot_complete_weekly_offset21 + theme(plot.margin = margin(t, r, b, l))

plot_pval_alt_comp_nofilt_offset21 <- lapply(list(alt_minusLogPPlot_complete_offset21_nofilt  + rremove("xlab"), 
                                                  alt_minusLogPPlot_complete_MoWedFri_offset21 + rremove("xlab"),
                                                  alt_minusLogPPlot_complete_weekly_offset21), 
                                             function(x){x + scale_x_date(limits=c(startDate_alt, endDate_alt), date_labels = "%b %Y") + 
                                                 theme(text=element_text(size=6), 
                                                       axis.title=element_text(size=6), 
                                                       legend.text=element_text(size=6), 
                                                       axis.text=element_text(size=6), 
                                                       axis.title.y = element_text(margin = margin(r = 6)),
                                                       legend.key.size = unit(0.5,"line"))
                                             }) %>% 
  ggarrange(plotlist = .,
            ncol=1,nrow=3, align = "hv",
            #labels = c("A", "B", "C", "D"),
            label.y = c(1.1,1.1,1),
            heights=c(1,1,1),
            #common.legend = TRUE, 
            #legend = "top",
            font.label = list(size = 12))

plot_pval_alt_comp_nofilt_offset21

saveRDS(plot_pval_alt_comp_nofilt_offset21, file="plots/logk_pvalues/plot_pval_alt_comp_nofilt_offset21.rds")
ggsave("plots/logk_pvalues/LogK_alt_daily_nofilt_offset21_3xweek_weekly.pdf", plot_pval_alt_comp_nofilt_offset21)
