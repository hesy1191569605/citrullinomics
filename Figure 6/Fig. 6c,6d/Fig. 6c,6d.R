library(ggseqlogo)
library(ggplot2)

rm(list = ls())
df = read.csv("Fig 6c,6d.csv")
dat=list(pos_all=df$seq[df$Type=="pos_all"],neg_all=df$seq[df$Type=="neg_all"])

ggseqlogo(dat, seq_type = "aa", scale="free", method = "probability", nrow=4, stack_width=0.8)+
  scale_y_continuous(expand = c(0,0), limits = c(0,1))+
  theme(axis.line.y=element_line(color="black"),
        axis.ticks.y=element_line(color="black"),
        axis.text.x = element_blank())
ggsave("Fig 6c,6d.pdf", width = 6.5, height = 8)
