library(ggseqlogo)
library(ggplot2)

df = read.csv("Fig 4a.csv")
ggplot(df, aes(group,Freq,fill=Var1))+
  geom_bar(stat="identity",width = .6)+
  scale_fill_manual(values = c("#5D669F","#BBBBBB","#AF322F"))+
  theme_test()+
  theme(axis.text = element_text(color="black"),
        axis.text.x = element_text(angle=90))
ggsave("Fig 4a.pdf", width = 3, height = 3)




dat = read.csv("neg.csv")
dat1 = read.csv("pos.csv")
df=list(dat$`sequence_window2`,dat1$`sequence_window2`)

ggseqlogo(df, seq_type = "aa", scale="free", nrow=2,
          method = "probability", stack_width=.9)+
  scale_y_continuous(expand = c(0,0), limits = c(0,1))+
  theme(axis.line.y=element_line(color="black", linewidth = .8),
        axis.ticks.y=element_line(color="black", linewidth = .8),
        axis.ticks.length = unit(1.25,"mm"),
        axis.text.x = element_blank())
ggsave("Fig 4b.pdf", width = 4, height = 5)