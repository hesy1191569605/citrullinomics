rm(list = ls())

data<-read.csv("eFig 1f.csv",row.names = 1)

data2<-log2(data)
range(na.omit(data))
boxplot(data2[1:99],axes=F,col="white",
        border = "#006BBE",lwd=1.5, cex=.3,
        xlim=c(0,579),ylim=c(-6,3),xlab = "Samples",ylab = "log2 (protein)",
        cex.lab=1.4, font.lab=1)
boxplot(data2[100:155],add = T,axes=F,at=c(100:155),col="white",
        border="#CC8C4C",lwd=1.5, cex=.3,ylim=c(-6,3))
boxplot(data2[156:579],add = T,axes=F,at=c(156:579),col="white",
        border="#B22F36",lwd=1.5, cex=.3,ylim=c(-6,3))

axis(2,at=c(-6,-3,0,3),
     label=c("-6","-3","0","3"),lwd=2,
     lwd.ticks = 2,
     font.axis=1,
     cex.axis=1.3)


