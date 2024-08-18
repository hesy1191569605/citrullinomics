library(dplyr)
library(ggplot2)

rm(list = ls())
data=read.csv("eFig 4a,4b,4c,4g,4h,4i.csv", header = F,row.names = NULL)
colnames(data)=data[1,];data=data[-1,];data[,7:ncol(data)] = lapply(data[,7:ncol(data)], as.numeric)

dat=data%>%filter(Group=="RA_A"|Group=="RA_B",`Drugs-HM`=="MTXHCQ")
dat=dat[!is.na(dat$`Responder-HM`),]



gender=as.data.frame(table(dat$Gender,dat$`Responder-HM`))
ggplot(gender, aes(Var1, Freq, fill=Var2))+
  geom_bar(stat="identity", position = position_dodge(.8), width = .6)+
  geom_text(aes(label=Freq), position = position_dodge(.8))+
  scale_fill_manual(values = c("#5D669F","#AF322F"))+
  theme_classic()+
  scale_y_continuous(expand = c(0,0), limits = c(0,60), breaks=c(0,20,40,60))
ggsave("eFig 4g.pdf", width = 3.5, height = 3)



ggplot(dat, aes(`Responder-HM`, Age, fill=`Responder-HM`))+
  geom_violin(width=.6, alpha=.1)+
  geom_boxplot(width = .25, outlier.colour = NA, alpha=1, fill="white")+
  geom_jitter(shape=21, width=.1 , color="transparent")+
  scale_fill_manual(values = c("#5D669F","#AF322F"), name="")+
  theme_classic()+
  stat_compare_means(method="wilcox.test", label.y = 90, size=5)+
  scale_y_continuous(expand = c(0,0), limits = c(0,100), breaks=c(0,25,50,75,100))+
  theme(axis.text = element_text(color="black",size=15),
        axis.line = element_line(color="black"),
        axis.ticks =  element_line(color="black"),
        axis.title = element_text(color="black",size=15))
ggsave("eFig 4h.pdf", width = 3.5, height = 3)


dat[,8:ncol(dat)] = lapply(dat[,8:ncol(dat)], scale)
dat1=reshape2::melt(dat, id.vars=c(1,2,5), measure.vars=c(8:ncol(dat)))

ggplot(dat1, aes(variable, value, color=`Responder-HM`, fill=`Responder-HM`))+
  geom_boxplot(outlier.colour = NA, width=.5, alpha=.01, position = position_dodge(width = .7),color="black")+
  geom_jitter(position = position_jitterdodge(jitter.width = .15, dodge.width = .7), alpha=1)+
  stat_compare_means(label="p.signif",method="wilcox.test", label.y = 5.2,size=5)+
  scale_color_manual(values = c("#5D669F","#AF322F"), name="")+ 
  scale_fill_manual(values = c("#5D669F","#AF322F"), name="")+
  coord_cartesian(ylim=c(-2.5,5.5))+
  theme_classic()+
  labs(x="",y="Scaled value")+
  theme(axis.text = element_text(color="black",size=15),
        axis.line = element_line(color="black"),
        axis.ticks =  element_line(color="black"),
        axis.title = element_text(color="black",size=15))
ggsave("eFig 4i.pdf", width = 4.5, height = 3)