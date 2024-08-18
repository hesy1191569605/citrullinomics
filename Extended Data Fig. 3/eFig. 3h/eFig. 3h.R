library(ggplot2)

rm(list=ls())
data=readxl::read_xlsx("cluster.xlsx", sheet=1)
names(data)

dat=data%>%arrange(`Entities pValue`)

df=dat[1:5,]
df$order=paste(letters[5:1], df$`Pathway name`)

ggplot(df, aes(-log10(`Entities pValue`), order, fill=`#Entities found`))+
  geom_bar(stat="identity", width = .5)+
  geom_point(aes(size=-log10(`Entities pValue`)),shape=21, fill="white")+
  scale_size(range = c(4,8), breaks = c(5,6,7))+
  scale_x_continuous(limits = c(0,8))+
  scale_fill_gradient2(high="#4F3870", low="#BEAED6", breaks=c(6,8,10))+
  theme_classic()+
  theme(axis.ticks = element_line(color="black", linewidth = .6),
        axis.line = element_line(color="black", linewidth = .6),
        axis.ticks.length = unit(1.15,"mm"),
        legend.position = "bottom")
ggsave("eFig 3h.pdf", width = 7,height = 3)