# Dependencies ####
library(matlib)
library(dplyr)
library(ggplot2)
library(stringr)
library(lubridate)
library(vcfR)

## Abundance estimator functions #####

### function splitting the SNPs in two clusters #####

# Prepping step, selecting the right SNPs
timeStepFit_v3<-function(snpDF,week, length=21, alpha=0.05) {
  zscoreCut<-qnorm(alpha,lower.tail = F)
  subsetDE<-snpDF%>%
    filter(!is.na(t))%>%
    filter(weeksince>=week-length,
           weeksince<=week)%>%
    group_by(pos,base)%>%
    mutate(matchWeeks=sum(weeksince==max(weeksince)))%>%
    ungroup()%>%
    filter(matchWeeks==1)%>%
    group_by(pos,base)%>%
    mutate(tRefpBase=pBase[weeksince==max(weeksince)],
           tRefnBase=nBase[weeksince==max(weeksince)],
           tRefDepth=depth[weeksince==max(weeksince)])%>%
    mutate(
      OR_lag=((lag(nBase)/lag(depth-nBase))/(nBase/(depth-nBase)))/(t-lag(t)),
      OR_est=(tRefnBase/(tRefDepth-tRefnBase))/(nBase/(depth-nBase)),
      OR_SE=sqrt((1/tRefnBase) + (1/(tRefDepth-tRefnBase)) +(1/nBase) +(1/(depth-nBase)))
    )
  return(subsetDE)
}

splitSNPs<-function(snpDF,week,length=21,alpha=0.05){
  tempDF<-timeStepFit_v3(snpDF%>%mutate(weeksince=t), week=week, length=length, alpha=alpha)
  
  # Create a wide instead of long dataset for clustering
  wideData<-reshape(tempDF%>%ungroup()%>%select(posBase,t,pBase,OR_lag)%>%
                      as.data.frame(), idvar = "posBase", timevar = "t", direction = "wide")%>%
    mutate(OR_Mean = rowMeans(select(.,starts_with("OR_")), na.rm = TRUE),
           pBaseMean = rowMeans(select(.,starts_with("pBase")), na.rm = TRUE),
           across(starts_with("OR_"), ~ ifelse(is.na(.), OR_Mean, .)),
           across(starts_with("pBase"), ~ ifelse(is.na(.), pBaseMean, .))
    )%>%as.data.frame()
  
  #remove rows containing INF or NA
  wideData <- wideData %>% 
    mutate(rowCheck=rowSums(wideData%>%select(starts_with(c("OR_","pBase")))))%>%
    filter(!is.infinite(rowCheck) & !is.na(rowCheck))
  
  # cluster and add cluster number to the original dataset
  wideData$cluster<-(kmeans(wideData%>%select(starts_with(c("pBase"))), centers = 2, iter.max = 100, nstart = 10)$cluster)
  tempDF<-merge(tempDF,wideData%>%select(posBase,cluster),by="posBase",all=T)
  
  return(tempDF%>%mutate(estiDate=week))
}


splitSNPs_onFreq<-function(snpDF,time,length=21,alpha=0.05, centers=2){
  # tempDF<-timeStepFit_v3(snpDF%>%mutate(weeksince=t), week=week, length=length, alpha=alpha)
  subsetDF<-snpDF%>%
    filter(!is.na(t))%>%
    filter(t>=time-length,
           t<=time)%>%
    mutate(OR_lag=((lag(nBase)/lag(depth-nBase))/(nBase/(depth-nBase)))/(t-lag(t)),
           OR_SE=sqrt((1/lag(nBase)) + (1/(lag(depth)-lag(nBase))) +(1/nBase) +(1/(depth-nBase)))
    )
  
  # Create a wide instead of long dataset for clustering
  wideData<-reshape(subsetDF%>%ungroup()%>%select(posBase,t,pBase,OR_lag)%>%
                      as.data.frame(), idvar = "posBase", timevar = "t", direction = "wide")%>%
    mutate(OR_Mean = rowMeans(select(.,starts_with("OR_")), na.rm = TRUE),
           pBaseMean = rowMeans(select(.,starts_with("pBase")), na.rm = TRUE),
           across(starts_with("OR_"), ~ ifelse(is.na(.), OR_Mean, .)),
           across(starts_with("pBase"), ~ ifelse(is.na(.), pBaseMean, .))
    )%>%as.data.frame()
  
  #remove rows containing INF or NA
  wideData <- wideData %>% 
    mutate(rowCheck=rowSums(wideData %>% select(starts_with(c("OR_","pBase")))))%>%
    filter(!is.infinite(rowCheck) & !is.na(rowCheck))
  
  # cluster and add cluster number to the original dataset
  wideData$cluster<-(kmeans(wideData %>% select(starts_with(c("pBase"))), centers = centers, iter.max = 100, nstart = 10)$cluster)
  subsetDF <- merge(subsetDF,wideData %>% select(posBase,cluster),by="posBase",all=T)
  
  # return(tempDF%>%mutate(estiDate=week))
  return(subsetDF%>%mutate(estiDate=time))
}

convertVCFtoDF<-function(filename,co_date,id=NA){
  fe<-file.exists(filename)
  print(paste0("Does file ",filename," exist? ",fe))
  if(!fe){return(NULL)} else{
    vcf <- read.vcfR(filename,verbose = F)
    
    infoParts=str_split(vcf@gt[,1],":")
    dataParts=str_split(vcf@gt[,2],":")
    ADDPpos<-bind_rows(lapply(infoParts, function(x){
      data.frame(DP=which(x=="DP"),
                 AD=which(x=="AD"))
    }
    ))
    
    df<-bind_rows(lapply(1:nrow(ADDPpos),function(i){
      if(
        length(as.numeric(str_split(dataParts[[i]][ADDPpos[[i,"AD"]]],",")[[1]]))!=
        length(c(as.character(vcf@fix[i,4]),as.character(vcf@fix[i,5])))
      ){print(
        as.numeric(str_split(dataParts[[i]][ADDPpos[[i,"AD"]]],",")[[1]])
      )
        print(
          c(as.character(vcf@fix[i,4]),str_split(as.character(vcf@fix[i,5]),",")[[1]])
        )
      }
      data.frame(
        pos=as.numeric(vcf@fix[i,2]),
        base=c(as.character(vcf@fix[i,4]),str_split(as.character(vcf@fix[i,5]),",")[[1]]),
        #base=c(as.character(vcf@fix[i,4]),as.character(vcf@fix[i,5])),
        nBase=as.numeric(str_split(dataParts[[i]][ADDPpos[[i,"AD"]]],",")[[1]]),
        depth=as.numeric(dataParts[[i]][ADDPpos[[i,"DP"]]])
      )
    }
    ))%>%mutate(pBase=nBase/depth)
    df$t<-as.numeric(as.Date(co_date)-as.Date("2020-01-05"))
    df$id<-id
    return(df)
  }
}

## Calculating proportions data ####
calculateAllProportions<-function(dataDF,depthSet=NULL){
  localProps<-dataDF%>%
    filter(!is.na(t))%>%
    group_by(t,pos,base)%>%
    mutate(nSamples=length(unique(id)))%>%
    #   group_by(t,pos,id,base)%>% #These should be unique values here!
    summarise(
      nBase=sum(nBase),
      depth=sum(depth),
      pBase=sum(pBase)/nSamples[1],
      nSamples=nSamples[1]
    )%>%
    ungroup()%>%
    group_by(pos,base,t)%>%
    summarise(
      nBase=sum(nBase),
      depth=sum(depth),
      pBase=sum(pBase),
      nSamples=nSamples[1],
      posBase=paste0(pos,base),
      SE=sqrt((1/nBase))+(1/(depth-nBase))
    )%>%ungroup()%>%
    mutate(
      oneMinuspB=1-pBase,
      Hx=pBase*oneMinuspB
    )%>%ungroup()
  return(localProps)
}

## Abundance estimators #####

simpleAbundance<-function(snpDF,thiscluster=1){
  abundDF<-snpDF%>%filter(cluster==thiscluster)%>%
    group_by(t)%>%
    mutate(meanPBaseT=mean(pBase),
           medianPBaseT=median(pBase)
    )%>%group_by(posBase)%>%
    mutate(dev1=pmax((pBase-medianPBaseT)/(1-medianPBaseT),0),
           dev2=pmax((medianPBaseT-pBase)/medianPBaseT,0),
           meanDev1=median(dev1),
           meanDev2=median(dev2),
           error=case_when(meanDev1>0 ~ (dev1-meanDev1)^2,
                           meanDev2>=0 ~ (dev2-meanDev2)^2
           )
    )%>%
    group_by(t)%>%
    summarise(totalError=sum(error),
              abundance=mean(medianPBaseT),
              estiDate=mean(estiDate),
              cluster=thiscluster
    )%>%arrange(t)%>%
    filter(!is.na(t))%>%
    as.data.frame()
  return(abundDF)
}
