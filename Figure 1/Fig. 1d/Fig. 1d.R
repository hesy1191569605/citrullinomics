d=read.csv("Fig 1d.csv")
library(ggplot2)
ggplot(d,aes(rank,count,col=group,shape=group))+
  geom_line(size=1.5,alpha=0.7)+
  geom_point(size=4,alpha=0.9)+
  scale_shape_manual(values=c(17,16,18))+
  scale_color_manual(values = c("#3D7DAE","#EAC450", "#D72A26" ))+
  theme_classic()+
  labs(x="Sample rank ratio",y="Citrullinated peptide number")+
  theme(axis.line = element_line(linewidth=.8, color="black"),
        axis.ticks = element_line(linewidth=.8, color="black"),
        axis.ticks.length = unit(1.25,"mm"))
