library(ggplot2)

rm(list = ls())
dat = read.csv("Fig 6b.csv")

ggplot()+
  geom_bar(data=dat, aes(order, pos_rate, fill=pos_rate, color=sig),stat="identity", width=.6)+
  theme_classic()+
  scale_fill_gradient(high="#FCA305", low="#A0CEE2")+
  scale_color_manual(values = c("transparent","red3"))+
  scale_y_continuous(limit=c(0,75), breaks=c(0,25,50,75), expand = c(0,0))+
  theme(axis.line = element_line(color="black", linewidth = .6),
        axis.ticks = element_line(color="black", linewidth = .6),
        axis.ticks.length = unit(1.1,"mm"),
        axis.text = element_text(color="black"),
        axis.text.x = element_text(angle=90))
ggsave("Fig 6b.pdf", width = 9, height = 3.5)