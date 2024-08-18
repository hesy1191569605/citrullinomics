rm(list=ls())
library(GGally)
library(reshape2)
library(dplyr)

data<-read.csv("eFig 1c.csv")
data<-data[,-c(1:2)]
data[data==0]=NA
data[,3:401]=lapply(data[,3:401], log10)
colnames(data)[3:401]=paste("C",colnames(data)[3:401])

cor=sapply(data[3:401],function(x){sapply(data[3:401],function(y){cor.test(x,y,method="spearman")[["estimate"]][["rho"]]})})
p=sapply(data[3:401],function(x){sapply(data[3:401],function(y){cor.test(x,y,method="spearman")[["p.value"]]})})
range(cor)

write.csv(cor,"IS_C_cor.csv",row.names = T)
write.csv(p,"IS_C_p.csv",row.names = T)

cor1 = as.data.frame(cor)
for(i in 1:ncol(cor1)){cor1[i,i]=NA}
range(cor1, na.rm=T)
cor2 = reshape2::melt(cor1, measure.vars=1:399)
median(cor2$value, na.rm=T)

d<-read.csv("IS_C_cor.csv", row.names = 1)
library(pheatmap)
bk <- c(seq(0.4,1,by=0.01))

pdf("eFig 1c.pdf", width = 3.5, height = 3)
pheatmap(cor,scale = "none",cluster_col = F,cluster_rows=F,
            color = c(colorRampPalette(colors = c("#F5E3E3","#d17b78"))(length(bk))),
            legend_breaks=seq(0.4,1,0.2),
            breaks=bk,
            clustering_distance_rows = F,
            cluster_cols = F,
            show_colnames = F,
            show_rownames = F)
dev.off()
