
library(venneuler)

pdf("Fig 4c (left).pdf", width=3, height = 5)
plot(venneuler(c(PRA=156, neg=161, pos=12,"PRA&neg"=59,"PRA&pos"=9)), col=c("#7948ad","#255c99","#d14444"))
dev.off()



df = read.csv("Fig 4c (right).csv")
ggplot(df, aes(group,Freq,fill=Var1))+
  geom_bar(stat="identity", position = position_dodge(.7), width = .5)+
  scale_fill_manual(values = c("#5D669F","#AF322F"))+
  geom_text(aes(label=Freq),position = position_dodge(.7))+
  theme_classic()+
  scale_y_continuous(expand = c(0,0))
ggsave("Fig 4c (right).pdf", width = 4,height = 3)



pdf("Fig 4d (left).pdf", width=3, height = 5)
plot(venneuler(c(RA=146, neg=161, pos=12,"RA&neg"=52,"RA&pos"=6)), col=c("#7948ad","#255c99","#d14444"))
dev.off()



df1 = read.csv("Fig 4d (right).csv")
ggplot(df1, aes(group,Freq,fill=Var1))+
  geom_bar(stat="identity", position = position_dodge(.7), width = .5)+
  scale_fill_manual(values = c("#5D669F","#AF322F"))+
  theme_classic()+
  geom_text(aes(label=Freq),position = position_dodge(.7))+
  scale_y_continuous(expand = c(0,0))
ggsave("Fig 4d (right).pdf", width = 4,height = 3)