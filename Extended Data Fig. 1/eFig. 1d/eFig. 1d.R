rm(list = ls())
library(GGally)
library(devtools)
library(rstatix)

data<-read.csv("eFig 1d.csv",row.names = 1)
data[data==0]=NA
data[,1:5]=lapply(data[,1:5], log10)

p <- ggpairs(data,columns = 1:5, 
             upper = list(continuous = "cor", 
                          method = "pearson",
                          na ="na"),
             lower = list(continuous = "smooth",
                          na ="na"),
             diag = list(continuous = "densityDiag", 
                         na = "naDiag"))+
  theme_bw()+
  theme(panel.grid=element_blank())
p