# Dependencies ####
library(vcfR)
library(stringr)
library(dplyr)
library(ggplot2)
library(stats)
library(ggpubr)

# Functions ####
tau.ci <- function(tau, N, conf.level = 0.95, correct='fieller') {
  if(correct=='none') tau.se <- 1/(N - 3)^0.5
  if(correct=='fieller') tau.se <- (0.437/(N - 4))^0.5
  moe <- qnorm(1 - (1 - conf.level)/2) * tau.se
  zu <- atanh(tau) + moe
  zl <- atanh(tau) - moe
  tanh(c(zl, zu))
}


compute_tau <- function(x=x, y=y, coords=NULL, ties = "ignore", weight_fun=NULL) {
  
  concordant <- 0
  discordant <- 0
  
  n <- length(x)
  
  for (i in 1:(n - 1)) {
    
    for (j in (i + 1):n) {
      
      dx <- x[i] - x[j]
      dy <- y[i] - y[j]
      
      if (dx == 0 || dy == 0) {
        
        if (ties == "ignore") {
          next
        }
        
        s <- 0
        
      } else {
        
        s <- sign(dx * dy)
      }
      
      
      d <- sqrt(sum((coords[i, ] - coords[j, ])^2))
      
      w <- weight_fun(d, coords)
      
      if (s > 0) {
        concordant <- concordant + w
      } else if (s < 0) {
        discordant <- discordant + w
      }
    }
  }
  
  (concordant - discordant) /
    (concordant + discordant)
}

weight_fun <- function(d, coords) {
  
  dtmp <- dist(coords)
  sigma <- median(dtmp)
  exp(-(d^2) / (2 * sigma^2))
}

weighted_kendall_tau <- function(
    x,
    y,
    coords = NULL,
    weight_fun = NULL,
    ties = "ignore",
    nperm = 999,
    seed = NULL
) {
  
  # --------------------------------------------
  # x, y      : vectors to compare
  # coords    : optional coordinates/features
  #             used to compute distances
  # weight_fun: function(d) -> weight
  #             default = Gaussian kernel
  # ties      : "ignore" or "zero"
  # --------------------------------------------
  
  options(digits=9)
  stopifnot(length(x) == length(y))
  
  if (!is.null(seed)) {
    set.seed(seed)
  }
  
  n <- length(x)
  
  if (is.null(coords)) {
    coord_x <- seq_len(n)
    coord_y <- rep(0, n)
    coords_combi <- c(coord_x, coord_y)
    #print(coord_x)
    #print(coord_y)
    coords <- matrix(coords_combi, ncol = 2)
    #print(coords)
  }
  
  #coords <- as.matrix(coords)
  
  # --------------------------------------------
  # Default Gaussian kernel
  # --------------------------------------------
  
  if (is.null(weight_fun)) {
    
    #print(coords)
    weight_fun <- function(d, coords) {
      
      dtmp <- dist(coords)
      sigma <- median(dtmp)
      exp(-(d^2) / (2 * sigma^2))
    }
  }
  
  # --------------------------------------------
  # Core tau computation
  # --------------------------------------------
  
  
  # observed statistic
  tau_obs <- compute_tau(x=x, y=y, coords=coords, ties = "ignore", weight_fun=weight_fun)
  
  # --------------------------------------------
  # Permutation test
  # --------------------------------------------
  
  tau_perm <- numeric(nperm)
  
  for (k in 1:nperm) {
    
    y_perm <- sample(y)
    
    tau_perm[k] <- compute_tau(x, y_perm, coords=coords, ties = "ignore", weight_fun=weight_fun)
  }
  
  print("tau_perm:")
  print(tau_perm)
  
  # two-sided p-value
  p_value <- (sum(abs(tau_perm) >= abs(tau_obs)) + 1) /
    (nperm + 1)
  
  print("sum:")
  print((sum(abs(tau_perm) >= abs(tau_obs)) + 1))
  
  list(
    tau = tau_obs,
    p_value = p_value,
    permuted_taus = tau_perm
  )
}


weigh_function <- function(numeric_date, logk_df, thres_1=2){
  ### make weighing function of length 42
  ### thresh_1 is the threshold that controls the steepness of the function, 
  ### a thresh_1 of 2 makes function goes down at the half of the sequence: ~20 days for 42 days sequence
  x = seq(0,1,length.out=43)*thresh_1
  x_clamped <- pmin(x,1)
  
  #y = x**2*(3-2*x)+1
  y = x_clamped**2*(3-2*x_clamped)+1
  
  df=data.frame(x=x/thres_1,y=y)
  
  ggplot(df)+ geom_line(aes(x=x, y=y))+ 
    geom_point(aes(x=x, y=y))+ 
    xlim(0,1)+
    ylim(1,2)
  
  return(y)
}


basedOnLM_weighted <- function(data,refDate,startOffset=7,endOffset=28){
  refDate=as.Date(refDate)
  endDate=refDate-startOffset
  beginDate=endDate-endOffset
  
  test<-filter(unique(data),
               (date1==refDate)&
                 (date2>=beginDate)&
                 (date2<=endDate)
  )%>%filter(!is.infinite(logK))
  
  datedif<-as.numeric(test$date2-as.Date("01-01-2000"))
  num_refdate <- as.numeric(refDate)
  
  if(nrow(test)>2){
    
    print(length(test$logK))
    #print(class(test$logK))
    #print(class(y))
    #print(test$logK)
    #print(test$date2)
    
    #print(y[0:length(test$logK)])
    #print(test$logK*y[0:length(test$logK)])
    #test$logK <- test$logK*y[0:length(test$logK)]
    
    #lmResult<-(lm(logK ~ datedif,test))
    ## conf.level = 0.95
    #ktau<-cor.test(datedif,test$logK, method="kendall")
    
    #weighted_kendall_tau
    #ktau <- weighted_kendall_tau(datedif, test$logK, coords, nperm = 5000)
    
    ktau <- weighted_kendall_tau(datedif,
                                 test$logK,
                                  coords = NULL,
                                  weight_fun = NULL,
                                  ties = "ignore",
                                  nperm = 999,
                                  seed = NULL)
    print(class(ktau$tau))
    print(ktau$p_value)
    print(nrow(test))
    
    return(data.frame(
      refDate=refDate,
      nData=nrow(test),
      tau=as.numeric(ktau$tau),
      #tauUpper=kTauCI[[1]],
      #tauLower=kTauCI[[2]],
      taup=ktau$p_value
    ))
  }  else{
    return(data.frame(
      refDate=NULL,
      tau=NULL,
      taup=NULL,
      nData=NULL
    ))
  }
}


basedOnLM<-function(data,refDate,startOffset=7,endOffset=28){
  refDate=as.Date(refDate)
  endDate=refDate-startOffset
  beginDate=endDate-endOffset
  
  test<-filter(unique(data),
               (date1==refDate)&
                 (date2>=beginDate)&
                 (date2<=endDate)
  )%>%filter(!is.infinite(logK))
  
  datedif<-as.numeric(test$date2-as.Date("01-01-2000"))
  num_refdate <- as.numeric(refDate)
  
  if(nrow(test)>2){
    
    #print(length(test$logK))
    #print(class(test$logK))
    #print(class(y))
    #print(test$logK)
    #print(test$date2)
    
    #print(y[0:length(test$logK)])
    #print(test$logK*y[0:length(test$logK)])
    #test$logK <- test$logK*y[0:length(test$logK)]
    
    lmResult<-(lm(logK ~ datedif,test))
    ## conf.level = 0.95
    ktau<-cor.test(datedif,test$logK, method="kendall")
    
    
    kTauCI<-(tau.ci(as.numeric(ktau$estimate), nrow(test)))

    pears<-cor.test(datedif,test$logK, method="pearson")

    if( is.null(pears$conf.int)){
      return(data.frame(
        refDate=refDate,
        nData=nrow(test),
        lmCoef=lmResult$coefficients[["datedif"]],
        lmUpper=lmResult$coefficients[["datedif"]]+(summary(lmResult)[[4]][[4]]*1.96),
        lmLower=lmResult$coefficients[["datedif"]]-(summary(lmResult)[[4]][[4]]*1.96),
        tau=as.numeric(ktau$estimate),
        tauUpper=kTauCI[[1]],
        tauLower=kTauCI[[2]],
        taup=ktau$p.value,
        pearsCor=as.numeric(pears$estimate),
        pearsp=pears$p.value,
        pearsLower=0,
        pearsUpper=0
      ))
    }
    return(data.frame(
      refDate=refDate,
      nData=nrow(test),
      lmCoef=lmResult$coefficients[["datedif"]],
      lmUpper=lmResult$coefficients[["datedif"]]+(summary(lmResult)[[4]][[4]]*1.96),
      lmLower=lmResult$coefficients[["datedif"]]-(summary(lmResult)[[4]][[4]]*1.96),
      tau=as.numeric(ktau$estimate),
      tauUpper=kTauCI[[1]],
      tauLower=kTauCI[[2]],
      taup=ktau$p.value,
      pearsCor=as.numeric(pears$estimate),
      pearsp=pears$p.value,
      pearsLower=pears$conf.int[1],
      pearsUpper=pears$conf.int[2]
    ))
  }  else{
    lmResult<-NULL
    pears=NULL
    ktau=NULL
    return(data.frame(
      refDate=NULL,
      lmCoef=NULL,
      tau=NULL,
      taup=NULL,
      pearsCor=NULL,
      pearsp=NULL,
      pearsLower=NULL,
      pearsUpper=NULL
    ))
  }
}

getAllSlopes_w<-function(data,startOffset=7,endOffset=28){
  avDates<-unique(data$date1)
  #### first 14 days are omitted!!!!
  allFits<-lapply(avDates[avDates>(min(avDates)+14)], 
                  function(d)basedOnLM_weighted(data,d,startOffset=startOffset,endOffset=endOffset)) %>% 
    bind_rows()
  return(allFits)
}

getAllSlopes<-function(data,startOffset=7,endOffset=28){
  avDates<-unique(data$date1)
  #### first 14 days are omitted!!!!
  allFits<-lapply(avDates[avDates>(min(avDates)+14)], 
                  function(d)basedOnLM(data,d,startOffset=startOffset,endOffset=endOffset)) %>% 
    bind_rows()
  return(allFits)
}


loess_smoothing <- function(allFitsCombo, span){
  
  ### smooth taup
  
  allFitsCombo <-allFitsCombo[order(allFitsCombo$refDate),]
  allFitsCombo$index <- 1:nrow(allFitsCombo)
  allFitsCombo$minus_log_taup <- -log10(allFitsCombo$taup)
  
  
  ### loess uses parabola as the default for the least squares calculation
  ### span gives the percentage of the points that are used for the sliding window
  loessMod <- loess(minus_log_taup ~ index, data=allFitsCombo, span=span)
  smoothed <- predict(loessMod)
  allFitsCombo$smoothed <- smoothed
  return(allFitsCombo)
}

draw_shades <- function(allFitsCombo, threshold, file){
  
  # Identify regions where y > threshold
  allFitsCombo <-allFitsCombo[order(allFitsCombo$refDate),]
  allFitsCombo$above_threshold <- allFitsCombo$smoothed > threshold
  
  ### Find start and end of exceeding regions for the shaded regions
  ### diff returns lagged difference
  shaded_regions <- allFitsCombo %>%
    mutate(group = cumsum(c(TRUE, diff(above_threshold) != 0))) %>%
    filter(above_threshold) %>%
    group_by(group) %>%
    summarise(xmin = min(refDate), xmax = max(refDate), .groups = "drop")
  
  ### save shaded regions to RDS file
  saveRDS(shaded_regions, file=file)
  
  return(shaded_regions)
}


plot_pvalues <- function(allFitsCombo, threshold_line, shaded_regions, startDate, endDate){
  
  allFitsCombo$aboveThresh <- ifelse(-log10(allFitsCombo$taup) >= threshold_line, "Above", "Below")
  
  minusLogPPlot_complete <- ggplot(allFitsCombo)+
    geom_point(aes(x=refDate,y=-log10(taup)),color="red", size=1)+
    geom_line(aes(x=refDate,y=-log10(taup)),color="red")+
    #  scale_color_manual(limits=c("Pearson","Kendall"),values=c("red","blue"))+
    geom_hline(yintercept = threshold_line,linetype=2)+
    geom_point(aes(x=refDate, y=-log10(taup), color=aboveThresh))+
    #geom_hline(yintercept = -log10(0.05),linetype=2)+
    #geom_hline(yintercept = -log10(0.05/nrow(allFitsCombo_zue)),linetype=2)+
    labs(x="Sampling date",y="-log(p-value)")+#,title = "Correlation between date and logK (between 0 and 21 days before current day)")+
    geom_rect(data = shaded_regions, aes(xmin = xmin-1, xmax = xmax, ymin = -Inf, ymax = Inf), 
              fill = "grey", alpha = 0.5, inherit.aes = FALSE) +
    scale_color_manual(values = c("Above" = "blue", "Below" = "red")) +
    geom_line(aes(x=refDate,y=smoothed))+
    xlim(startDate, endDate) +
    theme_bw()+
    theme(legend.position="none")
    #theme(axis.title.y = element_text(margin = margin(t = 0, r = -20, b = 0, l = 0))
  return(minusLogPPlot_complete)
}


read_and_plot_smoothed_pvalues <- function(raw_pvalues_filename,
                                           span=0.10,
                                           threshold,
                                           bonf_corr,
                                           shaded_regions_save_filename,
                                           startDate,
                                           endDate,
                                           final_plot_filename){
  
  ### reads p-values, smoothes and plots them over time
  ### saves the output plot into final_plot_filename
  ### saves the shaded regions into shaded_regions_save_filename
  
  ### span is for loess smoothing
  allFits <- readRDS(raw_pvalues_filename)
  
  ### Bonferroni correction if TRUE
  if(bonf_corr == TRUE){
    threshold <- -log10(threshold/nrow(allFits))
  }
  else{
    threshold <- -log10(threshold)
  }
  
  #### smooth p-values with loess smoothing
  allFits <- loess_smoothing(allFits, span=span)
  
  shaded_regions <- draw_shades(allFits, threshold, file=shaded_regions_save_filename)
  
  ### plot p-values complete set
  minusLogPPlot <- plot_pvalues(allFits = allFits, 
                                threshold, 
                                shaded_regions=shaded_regions, 
                                startDate=startDate, 
                                endDate=endDate)
  
  saveRDS(minusLogPPlot, file = final_plot_filename)
  
  return(minusLogPPlot)
}

check_single_pvalues <- function(raw_pvalues_filename,
                                           threshold,
                                           bonf_corr,
                                           shaded_regions_file,
                                           output_file
                                           ){
  

  ### checks the first point that exceeds the treshold and lies within the defined range for variants
  
  allFits <- readRDS(raw_pvalues_filename)
  
  ### Bonferroni correction if TRUE
  if(bonf_corr == TRUE){
    threshold <- -log10(threshold/nrow(allFits))
  }
  else{
    threshold <- -log10(threshold)
  }
  
  #### smooth p-values with loess smoothing
  allFits <- loess_smoothing(allFits, span=0.10)
  
  # Identify points where y > threshold
  #allFits <-allFits[order(allFits$refDate),]
  #allFits$minus_log_taup <- -log10(allFits$taup)
  
  allFits$above_threshold <- allFits$minus_log_taup > threshold
  
  shaded_regions <- readRDS(file = shaded_regions_file)
  
  point_estis <- apply(shaded_regions, 1, function(row) {
    
    allFits %>% filter(above_threshold == TRUE & (refDate <= row["xmax"] & refDate >= row["xmin"])) %>% slice(1)
    #row["xmin"]
    
    }) %>% bind_rows()
  
  write.csv2(point_estis, output_file)
  
  ggplot() + geom_line(data = allFits, aes(x = refDate, y=minus_log_taup)) +
             geom_point(data = allFits, aes(x = refDate, y=minus_log_taup)) +
             geom_line(data = allFits, aes(x = refDate, y=smoothed), col="orange") +
             geom_point(data = allFits, aes(x = refDate, y=smoothed), col="orange") +
             geom_hline(yintercept = threshold,linetype=2)+
             geom_point(data = point_estis, aes(x=refDate, y=minus_log_taup), col="blue") + 
             geom_rect(data = shaded_regions, aes(xmin = xmin, xmax = xmax, ymin = -Inf, ymax = Inf), 
                       fill = "grey", alpha = 0.5, inherit.aes = FALSE)
  
}
