### comparinng the p-values of logK correlation for daily, weekly, and Mo, Wed, Fri data

library(dplyr)
library(ggplot2)
library(ggpubr)

Sys.setlocale("LC_TIME", 'en_GB.UTF-8')

########## data loading ###################
#### p-values #####

#### load p-values plot from logK daily data
source("scripts/LogK_Pvalues_zue.R")
#zue_minusLogPPlot_complete <- readRDS("data/logk_p/minusLogPPlot_complete_zue.rds")

## no filter, offset 21
zue_minusLogPPlot_complete_offset21_nofilt <- readRDS("data/logk_p/Zurich/minusLogPPlot_complete_zue_nofilt_daily_offset21.rds")

## no filter, offset 42
zue_minusLogPPlot_complete_offset42_nofilt <- readRDS("data/logk_p/Zurich/minusLogPPlot_complete_zue_nofilt_daily_offset42.rds")



#### load p-values plot from logK Mo, Wed, Fri data
source("scripts/Slopes_clean_3times_per_week.R")

## no filter, offset 21
zue_minusLogPPlot_complete_MoWedFri_offset21 <- readRDS("data/logk_p/Zurich/minusLogPPlot_complete_zue_nofilt_MoWedFri_offset21.rds")

## no filter, offset 42
zue_minusLogPPlot_complete_MoWedFri_offset42 <- readRDS("data/logk_p/Zurich/minusLogPPlot_complete_zue_nofilt_MoWedFri_offset42.rds")



#### load p-values plot from logK weekly data
source("scripts/Slopes_clean_weekly.R")
zue_minusLogPPlot_complete_weekly_offset21 <- readRDS("data/logk_p/Zurich/minusLogPPlot_complete_zue_nofilt_weekly_offset21.rds")

zue_minusLogPPlot_complete_weekly_offset42 <- readRDS("data/logk_p/Zurich/minusLogPPlot_complete_zue_nofilt_weekly_offset42.rds")


#### global parameters
#startDate_zue <- as.Date("2021-11-01") 
#endDate_zue <- as.Date("2022-08-01")

startDate_zue <- as.Date("2020-12-23") 
endDate_zue <- as.Date("2022-09-30")

########### plot ####################

#zue_minusLogPPlot_complete_MoWedFri <- zue_minusLogPPlot_complete_MoWedFri + theme(plot.margin = margin(0, 0, 0, 0))


### margins:
### t=top, r=right, b=bottom, l=left
#t = -6
#r = 0
#b= -6
#l = 0

#zue_minusLogPPlot_complete_offset21_nofilt <- zue_minusLogPPlot_complete_offset21_nofilt + theme(plot.margin = margin(t, r, b, l))
#zue_minusLogPPlot_complete_MoWedFri <- zue_minusLogPPlot_complete_MoWedFri + theme(plot.margin = margin(t, r, b, l))
#zue_minusLogPPlot_complete_weekly <- zue_minusLogPPlot_complete_weekly + theme(plot.margin = margin(t, r, b, l))

plot_pval_zue_comp <- lapply(list(zue_minusLogPPlot_complete_offset21_nofilt  + rremove("xlab"), 
                             zue_minusLogPPlot_complete_MoWedFri + rremove("xlab"),
                             zue_minusLogPPlot_complete_weekly), 
                        function(x){x + scale_x_date(limits=c(startDate_zue, endDate_zue), date_labels = "%b %Y") + 
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

plot_pval_zue_comp
#ggsave("plots/LogK_daily_offset21_3xweek_weekly.pdf", plot_pval_zue_comp)

ggsave("plots/logk_pvalues/LogK_daily_offset42_3xweek_weekly.pdf", plot_pval_zue_comp)


#### Confidence Interval ####
#### daily data
source("scripts/LogK_Pvalues_zue.R")
zue_tau_complete_daily <- readRDS("data/logk_p/tauPlot_complete_zue_daily.rds")
#zue_tau_complete_daily <- readRDS("data/logk_p/tauPlot_complete_zue_daily_offset42.rds")

#### weekly data
source("scripts/Slopes_clean_weekly.R")
zue_tau_complete_weekly <- readRDS("data/logk_p/tauPlot_complete_zue_weekly.rds")

#### Mo, Wed, Fri data
source("scripts/Slopes_clean_3times_per_week.R")
zue_tau_complete_MoWedFri <- readRDS("data/logk_p/tauPlot_complete_zue_3x.rds")

ktau_all_offset21 <- ggarrange(zue_tau_complete_daily, 
                               zue_tau_complete_MoWedFri,
                               zue_tau_complete_weekly, 
                               ncol=1,nrow=3, align = "hv")

ggsave("plots/ktau_daily_offset21_3xweek_weekly.pdf", ktau_all_offset21)
#ggsave("plots/ktau_daily_offset42_3xweek_weekly.pdf", ktau_all_offset42)

#########################################
####### unfiltered daily data ###########
#### offset 42

startDate_zue <- as.Date("2020-12-23") 
endDate_zue <- as.Date("2022-09-30")

### margins:
### t=top, r=right, b=bottom, l=left
t = 5
r = 2
b= -6
l = 15

txt_size=8
zue_minusLogPPlot_complete_offset42_nofilt <- zue_minusLogPPlot_complete_offset42_nofilt + theme(plot.margin = margin(t, r, b, l))
zue_minusLogPPlot_complete_MoWedFri_offset42 <- zue_minusLogPPlot_complete_MoWedFri_offset42 + theme(plot.margin = margin(t, r, b, l))
zue_minusLogPPlot_complete_weekly_offset42 <- zue_minusLogPPlot_complete_weekly_offset42 + theme(plot.margin = margin(t, r, b, l))

plot_pval_zue_comp_nofilt_offset42 <- lapply(list(zue_minusLogPPlot_complete_offset42_nofilt  + rremove("xlab"), 
                                  zue_minusLogPPlot_complete_MoWedFri_offset42 + rremove("xlab"),
                                  zue_minusLogPPlot_complete_weekly_offset42), 
                             function(x){x + scale_x_date(limits=c(startDate_zue, endDate_zue), date_labels = "%b %Y") + xlab("") +
                                 theme(text=element_text(size=txt_size),
                                       #axis.title.x=element_blank(),
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

plot_pval_zue_comp_nofilt_offset42

saveRDS(plot_pval_zue_comp_nofilt_offset42, file="plots/logk_pvalues/plot_pval_zue_comp_nofilt_offset42.rds")
ggsave("plots/logk_pvalues/LogK_zue_daily_nofilt_offset42_3xweek_weekly.pdf", plot_pval_zue_comp_nofilt_offset42)

#########################
#########################
#### offset 21, unfiltered

#zue_minusLogPPlot_complete_offset21_nofilt <- readRDS("data/logk_p/Zurich/minusLogPPlot_complete_zue_nofilt_offset21.rds")

#zue_minusLogPPlot_complete_MoWedFri_offset21 <- readRDS("data/logk_p/Zurich/minusLogPPlot_complete_zue_nofilt_MoWedFri_offset21.rds")

zue_minusLogPPlot_complete_offset21_nofilt <- zue_minusLogPPlot_complete_offset21_nofilt + theme(plot.margin = margin(t, r, b, l))
zue_minusLogPPlot_complete_MoWedFri_offset21 <- zue_minusLogPPlot_complete_MoWedFri_offset21 + theme(plot.margin = margin(t, r, b, l))
zue_minusLogPPlot_complete_weekly <- zue_minusLogPPlot_complete_weekly + theme(plot.margin = margin(t, r, b, l))

plot_pval_zue_comp_nofilt_offset21 <- lapply(list(zue_minusLogPPlot_complete_offset21_nofilt  + rremove("xlab"), 
                                                  zue_minusLogPPlot_complete_MoWedFri_offset21 + rremove("xlab"),
                                                  zue_minusLogPPlot_complete_weekly), 
                                             function(x){x + scale_x_date(limits=c(startDate_zue, endDate_zue), date_labels = "%b %Y") + 
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
            #title="Zurich, 21 days",
            #common.legend = TRUE, 
            #legend = "top",
            font.label = list(size = 12))

plot_pval_zue_comp_nofilt_offset21


saveRDS(plot_pval_zue_comp_nofilt_offset21, file="plots/logk_pvalues/plot_pval_zue_comp_nofilt_offset21.rds")
ggsave("plots/logk_pvalues/LogK_zue_daily_nofilt_offset21_3xweek_weekly.pdf", plot_pval_zue_comp_nofilt_offset21)
