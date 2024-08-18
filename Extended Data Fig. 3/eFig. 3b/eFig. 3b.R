library(ggplot2)

rm(list=ls())
dat=read.csv("The citrullination state change (∆Ps).csv")

ggplot(dat, aes(n, log2sum, color=type))+
  geom_point(size=3)+
  theme_classic()+
  geom_hline(yintercept = c(0.5,-0.5), linetype=2, color="#CCCCCC")+
  labs(x="No. of citrullinated peptides", y="ΔCs value")+
  scale_color_manual(values = c('#154399', "#BBBBBB","#B81C23"))+
  scale_x_sqrt()+
  theme(axis.text = element_text(color="black"), axis.ticks = element_line(color="black", linewidth = .7),
        axis.line = element_line(linewidth = .7), axis.ticks.length = unit(1.25,"mm"))
ggsave("eFig 3b.pdf", width = 4.25, height = 3)