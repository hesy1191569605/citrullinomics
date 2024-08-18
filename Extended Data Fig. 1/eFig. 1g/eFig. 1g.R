rm(list = ls())
library(ggplot2)
library(ggpubr)
library(RColorBrewer)

data <- read.csv("eFig 1g.csv",row.names = 1)
data[data == 0] <- NA
data1 <- log10(data)
range(na.omit(data1))

boxplot(data1[1:4],axes=F,col="white",
        border = "#3583C9",lwd=2, cex=.5,
        xlim=c(0,9),ylim=c(-4,2),xlab = "Samples",ylab = "log10(data)",
        cex.lab=1.4, font.lab=1) 
boxplot(data1[5:8],add = T,axes=F,at=c(5:8),col="white",
        border="#8B7EC0",lwd=2, cex=.5) 
axis(2,at=c(-4,-3,-2,-1,0,1,2), 
     label=c("-4","-3","-2","-1","0","1","2"),lwd=2,
     lwd.ticks = 2,
     font.axis=1, 
     cex.axis=1.3) 
legend(list(x=0,y=20),bty="n",title=NA, lwd = 2,
       c("OA","RA"),
       pch=c(0,0),col=c("#3583C9","#8B7EC0"),horiz=T,pt.cex=3,
       cex=1.4,text.font = 1,text.width = strwidth("1000000000000"))