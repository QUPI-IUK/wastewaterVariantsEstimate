library(dplyr)
library(ggplot2)
library(ggpubr)

### combine Altenrhein and Zuerich p-value comparisons plots

### offset 42

plot_pval_alt_comp_nofilt_offset42 <- readRDS("plots/logk_pvalues/plot_pval_alt_comp_nofilt_offset42.rds")
plot_pval_zue_comp_nofilt_offset42 <- readRDS("plots/logk_pvalues/plot_pval_zue_comp_nofilt_offset42.rds")

combi_plot_sensitivity_offset42 <- ggarrange(plot_pval_alt_comp_nofilt_offset42, 
                        plot_pval_zue_comp_nofilt_offset42,
          #labels = c("A", "B"),
          ncol=2, 
          nrow=1,
          common.legend = TRUE, legend = "top",
          font.label = list(size = 14))

combi_plot_sensitivity_offset42
ggsave(combi_plot_sensitivity_offset42,  width=5.5, height=4.5, file="/home/raisa/Arbeit/WWsurv/manuscript/figures/combi_plot_pvalues_sensitivity_alt_zue_offset42.pdf")

### offset 21

plot_pval_alt_comp_nofilt_offset21 <- readRDS("plots/logk_pvalues/plot_pval_alt_comp_nofilt_offset21.rds")
plot_pval_zue_comp_nofilt_offset21 <- readRDS("plots/logk_pvalues/plot_pval_zue_comp_nofilt_offset21.rds")

combi_plot_sensitivity_offset21 <- ggarrange(plot_pval_alt_comp_nofilt_offset21, 
                                    plot_pval_zue_comp_nofilt_offset21,
                                    labels = c("A", "B"),
                                    ncol=2, 
                                    nrow=1,
                                    common.legend = TRUE, legend = "top",
                                    font.label = list(size = 12))
combi_plot_sensitivity_offset21

ggsave(combi_plot_sensitivity_offset21, width=5, height=5, file="/home/raisa/Arbeit/WWsurv/manuscript/figures/SuppInfo/combi_plot_pvalues_sensitivity_alt_zue_offset21.pdf")

#### combine offset 21 and 42

### for paper
### margins:
### t=top, r=right, b=bottom, l=left
#t = -6
#r = 0
#b= -6
#l = 0

plot_pval_alt_comp_nofilt_offset42 <- plot_pval_alt_comp_nofilt_offset42 + theme(plot.margin = margin(6, 0, 0, 0))
plot_pval_zue_comp_nofilt_offset42 <- plot_pval_zue_comp_nofilt_offset42 + theme(plot.margin = margin(6, 0, 0, 0))
#plot_pval_alt_comp_nofilt_offset21_adj <- plot_pval_alt_comp_nofilt_offset21 + theme(plot.margin = margin(t, r, b, l))
#plot_pval_zue_comp_nofilt_offset21_adj <- plot_pval_zue_comp_nofilt_offset21 + theme(plot.margin = margin(t, r, b, l))

combi_plot_sensitivity_offset42_21 <- ggarrange(plot_pval_alt_comp_nofilt_offset42,
                                                plot_pval_zue_comp_nofilt_offset42,
                                             plot_pval_alt_comp_nofilt_offset21, 
                                             plot_pval_zue_comp_nofilt_offset21,
                                             labels = c("A", "B", "C", "D"),
                                             ncol=2, 
                                             nrow=2,
                                             common.legend = TRUE, 
                                             legend = "top",
                                             #align = "h",
                                             font.label = list(size = 12))
combi_plot_sensitivity_offset42_21
ggsave(combi_plot_sensitivity_offset42_21, file="/home/raisa/Arbeit/WWsurv/manuscript/figures/combi_plot_pvalues_sensitivity_alt_zue_offset42_21.pdf")

###### Geneva
###### plot of daily, 3x a week, and weekly p-values for 21 and 42 days correlations
###### plot for Supplementary Material

plot_pval_ge_comp_nofilt_offset42 <- readRDS("plots/logk_pvalues/plot_pval_ge_comp_nofilt_offset42.rds")
plot_pval_ge_comp_nofilt_offset21 <- readRDS("plots/logk_pvalues/plot_pval_ge_comp_nofilt_offset21.rds")

combi_plot_sensitivity_ge <- ggarrange(plot_pval_ge_comp_nofilt_offset42, 
                                             plot_pval_ge_comp_nofilt_offset21,
                                             labels = c("A", "B"),
                                             ncol=2, 
                                             nrow=1,
                                             common.legend = TRUE, legend = "top",
                                             font.label = list(size = 12))
combi_plot_sensitivity_ge

ggsave(combi_plot_sensitivity_ge, file="/home/raisa/Arbeit/WWsurv/manuscript/figures/SuppInfo/combi_plot_pvalues_sensitivity_ge.pdf")

