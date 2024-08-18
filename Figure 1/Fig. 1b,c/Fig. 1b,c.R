library(dplyr); library(ggplot2)

data1 = read.csv("Fig 1b,1c.csv")
dat = data1 %>%group_by(Tissue, Protein) %>% summarise(n=n(),xcommon=NA)

data1 = data1[!is.na(data1$ID_position),]
i = "1 synovium"
for(i in unique(data1$Tissue)){
  
  d = data1[data1$Tissue==i,]
  d1 = reshape2::dcast(d, ID_position ~ Protein, value.var = "Tissue") %>% filter(PAD2!=0 & PAD4!=0)
  
  dat$xcommon[dat$Tissue==i]=nrow(d1)
}


dat1 = reshape2::melt(dat, id.vars=1:2, measure.vars=3:4)
names(dat1)
dat1$col = paste(dat1$Protein, dat1$variable); table(dat1$col)
ggplot(dat1, aes(Protein, value, fill=col))+
  geom_bar(stat="identity", width = .6, color="black")+
  facet_wrap(.~Tissue,nrow=1)+
  theme_classic()+
  scale_fill_manual(values = c("#d8e5ef","black","#F1E7CB","black"))+
  geom_text(aes(label=value), nudge_y = 2)+
  scale_y_continuous(expand = c(0,0))+
  labs(x="", y="Number of citrullinated peptides/ number of total peptides")+
  theme(axis.line = element_line(linewidth=.9, color="black"),
        axis.ticks = element_line(linewidth=.9, color="black"),
        axis.ticks.length = unit(1.25,"mm"))
ggsave("Fig 1b.pdf", width = 6.5, height = 3)

library(Vennerable)
data<-Venn(list(PAD2 = na.omit(unique(data1$ID_position[data1$Protein=="PAD2"])), 
                PAD4 = na.omit(unique(data1$ID_position[data1$Protein=="PAD4"]))))
plot(data,doWeight=T)
