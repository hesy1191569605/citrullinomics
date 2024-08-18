library(dplyr)
library(ComplexHeatmap)
library(circlize)
library(TCseq) 
library(ggseqlogo)

rm(list = ls())
result=read.csv("Fig 3i.csv", header = T,row.names = 1)
names(result)
dat=result[,c("median_HP","median_PRA","median_RA_A")]

df<-as.matrix(dat)
set.seed(123)
cluster_num<-4
cluster<-timeclust(df, algo='km',k=cluster_num, standardize = TRUE)

timeclustplot(cluster, value = 'z-score', cols = 1, 
                   membership.color = rainbow(30, s = 3/4, v = 1, start = 1/6),
                   axis.line.size = 0.6, axis.title.size = 8, axis.text.size = 8, 
                   title.size = 8, legend.title.size = 8, legend.text.size = 8)

citsite_cluster <-data.frame(cluster@cluster) ;citsite_cluster$ID=rownames(citsite_cluster)
table(cluster@cluster)
dat$ID=rownames(dat)
citsite_cluster1 <- merge(citsite_cluster,dat,by="ID")

col_fun = colorRamp2(c(-1,0, 1), c("#5D669F","white","#AF322F"))
top_annotation = HeatmapAnnotation(df=data.frame(group=rep(c("Health","preRA","RA"), c(1,1,1))),
                                   col = list(group=c(RA="#BF5960",Health="#6F99AD",preRA="#F9A363"))) 
pdf("Fig 3i left.pdf",width = 3, height = 6)
Heatmap(t(scale(t(citsite_cluster1[,3:5]))),name = " ",
        col = col_fun,
        top_annotation = top_annotation,
        row_split = citsite_cluster1$cluster.cluster,
        cluster_columns = F,
        cluster_rows = F,
        show_heatmap_legend = T,
        border = F,
        show_column_names = F,
        show_row_names = F,
        column_title = NULL)
dev.off()

library(ggplot2)
citsite_cluster2=cbind(citsite_cluster1[,1:2],t(apply(citsite_cluster1[,3:5],1,scale)))
cc=reshape2::melt(citsite_cluster2,id.vars=1:2, measure.vars=3:5)

ggplot(cc)+
  geom_line(aes(variable, scale(value), color=as.factor(cluster.cluster), group=ID))+
  geom_boxplot(aes(variable, scale(value)),color="black", outlier.colour = NA, width=.4, linewidth=.8)+
  facet_wrap(.~cluster.cluster, nrow=4, scale="free")+
  geom_hline(yintercept = 0,color="#BBBBBB", linetype=2, linewidth=.4)+
  scale_y_continuous(breaks=c(-1,0,1))+
  scale_x_discrete(expand = c(0.12,0.12))+
  theme_classic()+
  labs(x="")+
  scale_color_manual(values = c("#F9A363","#AF322F","#8A86BC","#67A596"))+
  theme(legend.position = "none",
        axis.line = element_line(linewidth = .8),
        axis.ticks = element_line(linewidth=.8),
        axis.ticks.length = unit(1.25,"mm"),
        strip.background = element_blank())
ggsave("Fig 3i middle.pdf", width = 3, height = 11)

table(citsite_cluster1$cluster.cluster)

result$ID = rownames(result)
dat = merge(result[,c("ID","sequence_window2")], citsite_cluster1, by="ID")

df=list(dat$`sequence_window2`[dat$cluster.cluster==1],
        dat$`sequence_window2`[dat$cluster.cluster==2],
        dat$`sequence_window2`[dat$cluster.cluster==3],
        dat$`sequence_window2`[dat$cluster.cluster==4])
ggseqlogo(df, seq_type = "aa", scale="free", method = "probability")+
  scale_y_continuous(expand = c(0,0), limits = c(0,1))+
  theme(axis.line.y=element_line(color="black"),
        axis.ticks.y=element_line(color="black"),
        axis.text.x = element_blank())
ggsave("Fig 3i right.pdf", width = 10, height = 6)