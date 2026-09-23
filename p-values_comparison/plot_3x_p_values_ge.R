### comparinng the p-values of logK correlation for daily, weekly, and Mo, Wed, Fri data

library(dplyr)
library(ggplot2)
library(ggpubr)

Sys.setlocale("LC_TIME", 'en_GB.UTF-8')

########## data loading ###################
#### p-values #####

#### load p-values plot from logK daily data
source("scripts/LogK_Pvalues_ge.R")
#ge_minusLogPPlot_complete <- readRDS("data/logk_p/minusLogPPlot_complete_ge.rds")

## no filter, offset 21
ge_minusLogPPlot_complete_offset21_nofilt <- readRDS("data/logk_p/Geneva/minusLogPPlot_complete_ge_nofilt_daily_offset21.rds")

## no filter, offset 42
ge_minusLogPPlot_complete_offset42_nofilt <- readRDS("data/logk_p/Geneva/minusLogPPlot_complete_ge_nofilt_daily_offset42.rds")



#### load p-values plot from logK Mo, Wed, Fri data
source("scripts/Slopes_clean_3times_per_week.R")

## no filter, offset 21
ge_minusLogPPlot_complete_MoWedFri_offset21 <- readRDS("data/logk_p/Geneva/minusLogPPlot_complete_ge_nofilt_MoWedFri_offset21.rds")

## no filter, offset 42
ge_minusLogPPlot_complete_MoWedFri_offset42 <- readRDS("data/logk_p/Geneva/minusLogPPlot_complete_ge_nofilt_MoWedFri_offset42.rds")



#### load p-values plot from logK weekly data
source("scripts/Slopes_clean_weekly.R")
ge_minusLogPPlot_complete_weekly_offset21 <- readRDS("data/logk_p/Geneva/minusLogPPlot_complete_ge_nofilt_weekly_offset21.rds")

ge_minusLogPPlot_complete_weekly_offset42 <- readRDS("data/logk_p/Geneva/minusLogPPlot_complete_ge_nofilt_weekly_offset42.rds")

#### global parameters
startDate_ge <- as.Date("2021-11-01") 
endDate_ge <- as.Date("2022-08-01")


########### plot ####################

#ge_minusLogPPlot_complete_MoWedFri <- ge_minusLogPPlot_complete_MoWedFri + theme(plot.margin = margin(0, 0, 0, 0))


### margins:
### t=top, r=right, b=bottom, l=left
t = -6
r = 0
b= -6
l = 0

plot_pval_ge_comp <- lapply(list(ge_minusLogPPlot_complete  + rremove("xlab"), 
                             ge_minusLogPPlot_complete_MoWedFri + rremove("xlab"),
                             ge_minusLogPPlot_complete_weekly), 
                        function(x){x + scale_x_date(limits=c(startDate_ge, endDate_ge), date_labels = "%b %Y") + 
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

plot_pval_ge_comp
#ggsave("plots/LogK_daily_offset21_3xweek_weekly.pdf", plot_pval_ge_comp)

ggsave("plots/LogK_daily_offset42_3xweek_weekly.pdf", plot_pval_ge_comp)


#### Confidence Interval ####
#### daily data
source("scripts/LogK_Pvalues_ge.R")
ge_tau_complete_daily <- readRDS("data/logk_p/tauPlot_complete_ge_daily.rds")
#ge_tau_complete_daily <- readRDS("data/logk_p/tauPlot_complete_ge_daily_offset42.rds")

#### weekly data
source("scripts/Slopes_clean_weekly.R")
ge_tau_complete_weekly <- readRDS("data/logk_p/tauPlot_complete_ge_weekly.rds")

#### Mo, Wed, Fri data
source("scripts/Slopes_clean_3times_per_week.R")
ge_tau_complete_MoWedFri <- readRDS("data/logk_p/tauPlot_complete_ge_3x.rds")

ktau_all_offset21 <- ggarrange(ge_tau_complete_daily, 
                               ge_tau_complete_MoWedFri,
                               ge_tau_complete_weekly, 
                               ncol=1,nrow=3, align = "hv")

ggsave("plots/ktau_daily_offset21_3xweek_weekly.pdf", ktau_all_offset21)
#ggsave("plots/ktau_daily_offset42_3xweek_weekly.pdf", ktau_all_offset42)

#########################################
####### unfiltered daily data ###########
#### offset 42

plot_pval_ge_comp_nofilt_offset42 <- lapply(list(ge_minusLogPPlot_complete_offset42_nofilt + rremove("xlab"), 
                                  ge_minusLogPPlot_complete_MoWedFri_offset42 + rremove("xlab"),
                                  ge_minusLogPPlot_complete_weekly_offset42
                                  ), 
                             function(x){x + scale_x_date(limits=c(startDate_ge, endDate_ge), date_labels = "%b %Y") + 
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
            label.y = c(1.1,1.1,1.1),
            heights=c(1,1,1),
            #common.legend = TRUE, 
            #legend = "top",
            font.label = list(size = 12))

plot_pval_ge_comp_nofilt_offset42

saveRDS(plot_pval_ge_comp_nofilt_offset42, file="plots/logk_pvalues/plot_pval_ge_comp_nofilt_offset42.rds")
ggsave("plots/logk_pvalues/LogK_ge_daily_nofilt_offset42_3xweek_weekly.pdf", plot_pval_ge_comp_nofilt_offset42)

#########################
#########################
#### offset 21, unfiltered

#ge_minusLogPPlot_complete_offset21_nofilt <- readRDS("data/logk_p/Geneva/minusLogPPlot_complete_ge_nofilt_offset21.rds")

#ge_minusLogPPlot_complete_MoWedFri_offset21 <- readRDS("data/logk_p/Geneva/minusLogPPlot_complete_ge_nofilt_MoWedFri_offset21.rds")


plot_pval_ge_comp_nofilt_offset21 <- lapply(list(ge_minusLogPPlot_complete_offset21_nofilt  + rremove("xlab"), 
                                                 ge_minusLogPPlot_complete_MoWedFri_offset21 + rremove("xlab"),
                                                 ge_minusLogPPlot_complete_weekly_offset21), 
                                             function(x){x + scale_x_date(limits=c(startDate_ge, endDate_ge), date_labels = "%b %Y") + 
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

plot_pval_ge_comp_nofilt_offset21

saveRDS(plot_pval_ge_comp_nofilt_offset21, file="plots/logk_pvalues/plot_pval_ge_comp_nofilt_offset21.rds")
ggsave("plots/logk_pvalues/LogK_ge_daily_nofilt_offset21_3xweek_weekly.pdf", plot_pval_ge_comp_nofilt_offset21)
