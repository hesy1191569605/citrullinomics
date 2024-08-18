
library(ggplot2)

rm(list = ls())
dat<-read.csv("eFig 1h.csv")

dat1 = reshape2::melt(dat, id.vars=1:2) %>% na.omit()
dat1$IDpro = gsub("\\_.*","",dat1$variable)

n = dat1 %>%group_by(ID) %>% summarise(n_peptides = length(unique(variable)), n_pro = length(unique(IDpro))) %>% arrange(n_peptides)
n$sum_peptides = NA; n$sum_pro = NA

i = 2; n$sum_peptides[1] = n$n_peptides[1]; n$sum_pro[1] = n$n_pro[1]
for(i in 2:nrow(n)){
  d = dat1[dat1$ID %in% n$ID[1:i],]
  n$sum_peptides[i] = length(unique(d$variable))
  n$sum_pro[i] = length(unique(d$IDpro))
}

n$order = 1:579
ggplot(n)+
  geom_line(aes(x=order, y=sum_pro),color="grey", lwd=0.5, lty=1)+
  geom_line(aes(x=order, y=sum_peptides),color="grey", lwd=0.5, lty=1)+
  geom_point(aes(x=order, y=sum_pro),shape=16, color="#4A87C6", size=2)+
  geom_point(aes(x=order, y=sum_peptides),shape=17, color="#F16A6B", size=2)+
  ylim(0,1550)+
  theme_classic()
ggsave("eFig 1h.pdf", width = 3.3, height = 3)
