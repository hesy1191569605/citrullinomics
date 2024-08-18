rm(list = ls())
library(igraph)
library(reshape2)


d1<-read.csv("eFig 1e (citsite first).csv")[,-1]
d2<-read.csv("eFig 1e (citsite second).csv")[,-1]
table(colnames(d1)==colnames(d2));table(rownames(d1)==rownames(d2))

d1<-d1[,-1]
d2<-d2[,-1]
cor=sapply(1:ncol(d1),function(x){cor.test(d1[,x],d2[,x],method="spearman")[["estimate"]][["rho"]]})
plot(density(cor))

median<-median(cor)
cor2=density(cor)
cor3=data.frame(x=cor2$x,y=cor2$y)
cor1=data.frame(cor=cor)
library(ggplot2)
ggplot()+
  geom_density(data=cor1, aes(x=cor),stat = "density", fill="pink")+
  xlim(0.3,0.7)+
  ylim(0,6)+
  geom_vline(xintercept = 0.514,linetype=2,color="black",size=1)+
  theme_classic()
