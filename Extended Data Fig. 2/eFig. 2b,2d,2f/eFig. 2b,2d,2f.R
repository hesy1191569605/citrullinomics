library(dplyr)
library(ComplexHeatmap)
library(circlize)
library(ggplot2)


rm(list = ls())
data=read.csv("wilcox result.csv")

dat=data[data$PRA_HP_youwu=="wilcox",]%>%filter(PRA_HP_all=="up" & RAA_HP_all!="up")%>%arrange(p_PRA_HP_wilcox)%>%data.frame()
rownames(dat)=dat$position
dat1=dat[1:10,c("median_HP", "median_PRA", "median_RA_A")]

col_fun = colorRamp2(c(-1,0, 1), c("#5D669F","white","#AF322F"))

top_annotation = HeatmapAnnotation(df=data.frame(group=c("Health","preRA","RA")),
                                   col = list(group=c(RA="#BF5960",Health="#6F99AD",preRA="#F9A363"))) 

pdf("eFig 2b left.pdf", width = 5, height = 4)
Heatmap(t(scale(t(dat1))),col=col_fun,
        rect_gp = gpar(col="white", lwd=3),
        top_annotation = top_annotation,
        cluster_rows = F, cluster_columns = F,
        show_heatmap_legend = T,
        border = F, show_column_names = F,
        show_row_names = T, column_title = NULL)
dev.off()


dat=data[data$RAA_HP_youwu=="wilcox",]%>%filter(RAA_HP_all=="up" & PRA_HP_all!="up")%>%arrange(p_RAA_HP_wilcox)%>%data.frame()
rownames(dat)=dat$position
dat1=dat[1:10,c("median_HP", "median_PRA", "median_RA_A")]

col_fun = colorRamp2(c(-1,0, 1), c("#5D669F","white","#AF322F"))

top_annotation = HeatmapAnnotation(df=data.frame(group=c("Health","preRA","RA")),
                                   col = list(group=c(RA="#BF5960",Health="#6F99AD",preRA="#F9A363"))) 

pdf("eFig 2d left.pdf", width = 5, height = 4)
Heatmap(t(scale(t(dat1))),col=col_fun,
        rect_gp = gpar(col="white", lwd=3),
        top_annotation = top_annotation,
        cluster_rows = F, cluster_columns = F,
        show_heatmap_legend = T,
        border = F, show_column_names = F,
        show_row_names = T, column_title = NULL)
dev.off()



dat=data[data$RAA_HP_youwu=="wilcox" & data$PRA_HP_youwu=="wilcox",]%>%filter(RAA_HP_all=="up" & PRA_HP_all=="up")%>%arrange(p_RAA_HP_wilcox,p_PRA_HP_wilcox)%>%data.frame()
rownames(dat)=dat$position
dat1=dat[1:10,c("median_HP", "median_PRA", "median_RA_A")]

col_fun = colorRamp2(c(-1,0, 1), c("#5D669F","white","#AF322F"))

top_annotation = HeatmapAnnotation(df=data.frame(group=c("Health","preRA","RA")),
                                   col = list(group=c(RA="#BF5960",Health="#6F99AD",preRA="#F9A363"))) 

pdf("eFig 2f left.pdf", width = 5, height = 4)
Heatmap(t(scale(t(dat1))),col=col_fun,
        rect_gp = gpar(col="white", lwd=3),
        top_annotation = top_annotation,
        cluster_rows = F, cluster_columns = F,
        show_heatmap_legend = T,
        border = F, show_column_names = F,
        show_row_names = T, column_title = NULL)
dev.off()







dat=data[data$PRA_HP_youwu=="wilcox",]%>%filter(PRA_HP_all=="up" & RAA_HP_all!="up")%>%arrange(p_PRA_HP_wilcox)%>%data.frame()

dat1=dat[1:10,]%>%mutate(order=letters[10:1])
names(dat1)
dat1$order = paste(dat1$order, dat1$position)

ggplot(dat1, aes(-log10(p_PRA_HP_wilcox),order, fill=`fc_PRA_HP`))+
  geom_bar(stat="identity", width=.01, color="black", fill="black")+
  geom_point(shape=21, size=5)+
  scale_size(breaks=c(16,19,21), range=c(2,5.5),name="")+
  scale_fill_gradient2(high="#F9A363", low="white",name="", breaks=c(0.5,1.5,2.5))+
  theme_minimal()+
  theme(axis.line.x = element_line(color="black"),
        axis.ticks.x = element_line(color="black"))
ggsave("eFig 2b right.pdf", width = 4, height = 3)



dat=data[data$RAA_HP_youwu=="wilcox",]%>%filter(RAA_HP_all=="up" & PRA_HP_all!="up")%>%arrange(p_RAA_HP_wilcox)%>%data.frame()

dat1=dat[1:10,]%>%mutate(order=letters[10:1])
names(dat1)
dat1$order = paste(dat1$order, dat1$position)

ggplot(dat1, aes(-log10(p_RAA_HP_wilcox),order, fill=`fc_RAA_HP`))+
  geom_bar(stat="identity", width=.01, color="black", fill="black")+
  geom_point(shape=21, size=5)+
  scale_size(breaks=c(16,19,21), range=c(2,5.5),name="")+
  scale_fill_gradient2(high="#F9A363", low="white",name="", breaks=c(0.3,0.4,0.5))+
  theme_minimal()+
  theme(axis.line.x = element_line(color="black"),
        axis.ticks.x = element_line(color="black"))
ggsave("eFig 2d right.pdf", width = 4.3, height = 3)



dat=data[data$RAA_HP_youwu=="wilcox" & data$PRA_HP_youwu=="wilcox",]%>%filter(RAA_HP_all=="up" & PRA_HP_all=="up")%>%arrange(p_RAA_HP_wilcox,p_PRA_HP_wilcox)%>%data.frame()

dat1=dat[1:10,]%>%mutate(order=letters[10:1])
names(dat1)
dat1$order = paste(dat1$order, dat1$position)

d_PRA = dat1[,c("order","p_PRA_HP_wilcox","fc_PRA_HP")]; colnames(d_PRA)[2:3]=c("p","log2fc"); d_PRA$log2fc = -d_PRA$log2fc
d_RAA = dat1[,c("order","p_RAA_HP_wilcox","fc_RAA_HP")]; colnames(d_RAA)[2:3]=c("p","log2fc")

dat2=rbind(d_PRA, d_RAA)

ggplot(dat2, aes(log2fc,order, fill=-log10(p)))+
  geom_bar(stat="identity", width=.01, color="black", fill="black")+
  geom_point(shape=21, size=5)+
  geom_vline(xintercept = 0,linetype=2)+
  scale_size(breaks=c(16,19,21), range=c(2,5.5),name="")+
  scale_fill_gradient2(high="#AF322F", low="white",name="", breaks=c(15,25,35))+
  theme_minimal()+
  theme(axis.line.x = element_line(color="black"),
        axis.ticks.x = element_line(color="black"))
ggsave("eFig 2f right.pdf", width = 4, height = 3)
