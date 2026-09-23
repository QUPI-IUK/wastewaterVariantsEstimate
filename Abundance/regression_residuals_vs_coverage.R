library(dplyr)
library(ggplot2)
library(lubridate)
library(RcppRoll)


### Zurich
#zue_cov_data <- readRDS("/home/kociurzy/WastewaterCov/Swiss/data/Abundance/zue_coverage_readdepth.rds")
#zue_abund_data <- readRDS("/home/kociurzy/WastewaterCov/Swiss/data/Abundance/Abund_ZH_simple.rds")

zue_cov_data <- readRDS("data/Abundance/zue_coverage_readdepth.rds")
zue_abund_data <- readRDS("data/Abundance/Abund_ZH_simple.rds")

dayssinceToDate<-function(w){
  return(as.Date("2020-01-05")+days(w))
}

abund_esti_zue_df <- bind_rows(zue_abund_data)
abund_esti_zue_df$date <- as.Date(dayssinceToDate(abund_esti_zue_df$t))

#abund_esti_zue_df <- abund_esti_zue_df %>% filter(date >= as.Date("2021-01-02") & date <= as.Date("2022-09-01"))

abund_esti_zue_df_clus1 <- abund_esti_zue_df %>% filter(cluster==1)
abund_esti_zue_df_clus2 <- abund_esti_zue_df %>% filter(cluster==2)

### rolling average
roll_mean_res_clus1 <- abund_esti_zue_df_clus1 %>% group_by(estiDate) %>% 
  mutate(rolling_mean = roll_mean(abundance, n=n()-5, fill=NA))

### calculate residuals
roll_mean_res_clus1_withresids <- roll_mean_res_clus1 %>% group_by(estiDate) %>%
  filter(!is.na(rolling_mean)) %>%
  slice(-1) %>%
  mutate(resids = abs(rolling_mean - abundance)) %>%
  summarize(resids_mean = mean(resids),
            date = date) %>%
  ungroup() %>%
  select(resids_mean, date)

#roll_mean_res_clus1_withresids <- roll_mean_res_clus1_withresids[,c("resids_mean", "date")]
  
### the mean of the residuals over the dates is taken
### slice(1) because summarise does not work as expected
roll_mean_res_clus1_withresids_dates <- roll_mean_res_clus1_withresids %>%
  ungroup %>%
  select(resids_mean, date) %>%
  group_by(date) %>%
  summarise(resids_mean_date = mean(resids_mean),
        date = date) %>%
  slice(1)

roll_mean_res_clus1_withresids_dates <- roll_mean_res_clus1_withresids_dates %>% filter(date >= as.Date("2021-01-02") & date <= as.Date("2022-09-01"))

zue_clus1_merged <- merge(zue_cov_data, roll_mean_res_clus1_withresids_dates, by.x=("Collection_Date"), by.y=("date"))

ggplot() +
  geom_line(data=roll_mean_res_clus1_withresids_dates, aes(x=date,y=resids_mean_date),color="lightblue", inherit.aes = FALSE)+
  geom_point(data=roll_mean_res_clus1_withresids_dates, aes(x=date,y=resids_mean_date),color="lightblue", inherit.aes = FALSE)+
  labs(x="Date", y="mean residuals")+
  #ylim(0, 10)+
  xlim(as.Date(min(abund_esti_zue_df_clus1$date)), as.Date(max(abund_esti_zue_df_clus1$date)))+
  theme_bw()+
  theme(legend.position = "top")

lm(read_count ~ resids_mean_date, zue_clus1_merged)
