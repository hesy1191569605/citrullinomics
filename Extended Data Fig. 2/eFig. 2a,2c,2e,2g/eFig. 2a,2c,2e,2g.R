
library(dplyr)
library(ggplot2)
library(ggpubr)

rm(list = ls())
data=data.table::fread("PRA_up_only31 GOBP.txt")%>%arrange(PValue) %>% filter(PValue<0.05)
dat=data[1:10,]%>%arrange(Count)%>%mutate(order=letters[1:10])
names(dat)

dat$order1 = paste(dat$order, dat$Term)
ggplot(dat, aes(Count, order1, fill=-log10(PValue)))+
  geom_bar(stat="identity", width = .6, color="transparent")+
  scale_size(range=c(2,5))+
  scale_fill_gradient(high="#FCA305", low="#A0CEE2", breaks = c(3,5,7))+
  scale_x_continuous(expand = c(0,0), breaks = c(0,2,4,6,8))+
  theme_minimal()+
  theme(axis.line = element_line(linewidth=.8, color="black"),
        axis.ticks = element_line(linewidth=.8, color="black"),
        axis.ticks.length = unit(1.25,"mm"))
ggsave("eFig 2a.pdf", width = 7.5, height = 3)




rm(list = ls())
data=data.table::fread("RAA_up_only24 GOBP.txt")%>%arrange(PValue) %>% filter(PValue<0.05)
dat=data[1:10,]%>%arrange(Count)%>%mutate(order=letters[1:10])
names(dat)

dat$order1 = paste(dat$order, dat$Term)
ggplot(dat, aes(Count, order1, fill=-log10(PValue)))+
  geom_bar(stat="identity", width = .6, color="transparent")+
  scale_size(range=c(2,5))+
  scale_fill_gradient(high="#FCA305", low="#A0CEE2", breaks = c(1.6,2,2.4,2.8))+
  scale_x_continuous(expand = c(0,0), breaks = c(0,1,2,3))+
  theme_minimal()+
  theme(axis.line = element_line(linewidth=.8, color="black"),
        axis.ticks = element_line(linewidth=.8, color="black"),
        axis.ticks.length = unit(1.25,"mm"))
ggsave("eFig 2c.pdf", width = 7, height = 3)



rm(list = ls())
data=data.table::fread("both_up_PRA_RAA70 GOBP.txt")%>%arrange(PValue) %>% filter(PValue<0.05)
dat=data[1:10,]%>%arrange(Count)%>%mutate(order=letters[1:10])
names(dat)

dat$order1 = paste(dat$order, dat$Term)
ggplot(dat, aes(Count, order1, fill=-log10(PValue)))+
  geom_bar(stat="identity", width = .6, color="transparent")+
  scale_size(range=c(2,5))+
  scale_fill_gradient(high="#FCA305", low="#A0CEE2", breaks=c(4,6,8))+
  scale_x_continuous(expand = c(0,0), breaks = c(0,2,4,6))+
  theme_minimal()+
  theme(axis.line = element_line(linewidth=.8, color="black"),
        axis.ticks = element_line(linewidth=.8, color="black"),
        axis.ticks.length = unit(1.25,"mm"))
ggsave("eFig 2e.pdf", width = 7, height = 3)





rm(list = ls())
data=data.table::fread("PRA_down_only20 GOBP.txt")%>%arrange(PValue) %>% filter(PValue<0.05)
d1=data[1:5,]%>%arrange(Count)%>%mutate(order=letters[1:5])
names(d1)

data=data.table::fread("both_down_PRA_RAA32 GOBP.txt")%>%arrange(PValue) %>% filter(PValue<0.05)
d2=data[1:5,]%>%arrange(Count)%>%mutate(order=letters[1:5])
names(d2)

dat = rbind(d1%>%mutate(type="PRA_down_only20 GOBP"),d2%>%mutate(type="Xboth_down_PRA_RAA32 GOBP"))
dat$order=paste(dat$type, dat$order)

dat$order1 = paste(dat$order, dat$Term)
ggplot(dat, aes(Count, order1, fill=-log10(PValue)))+
  geom_bar(stat="identity", width = .6, color="transparent")+
  scale_size(range=c(2,5))+
  scale_fill_gradient(high="#FCA305", low="#A0CEE2", breaks=c(2,3,4,5))+
  scale_x_continuous(expand = c(0,0), breaks = c(0,2,4,6))+
  theme_minimal()+
  theme(axis.line = element_line(linewidth=.8, color="black"),
        axis.ticks = element_line(linewidth=.8, color="black"),
        axis.ticks.length = unit(1.25,"mm"))
ggsave("eFig 2g.pdf", width = 10, height = 3)

