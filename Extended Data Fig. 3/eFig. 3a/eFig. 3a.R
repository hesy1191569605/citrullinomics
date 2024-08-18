
library(ggplot2)
result=read.csv("Synovium citrullinome.csv")
names(result)

ggplot(result, aes(x=log2(RO_mean), y=-log10(p), color=sig_mean))+
  geom_point()+
  geom_hline(yintercept = -log10(0.05), linetype=2,linewidth=.5, color="#BBBBBB")+
  geom_vline(xintercept = c(log2(1.2),-log2(1.2)), linetype=2,linewidth=.5, color="#BBBBBB")+
  scale_color_manual(values = c("#5D669F","#BFBFBF","#AF322F"))+
  theme_test()+
  theme(axis.line = element_blank(),
        panel.border = element_rect(linewidth=.8),
        axis.ticks = element_line(linewidth=.8),
        axis.ticks.length = unit(1.25,"mm"))
ggsave("eFig 3a.pdf", width = 3.8, height = 3)