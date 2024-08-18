library(ggplot2)
result=read.csv("wilcox result.csv", header = T,row.names = 1)

ggplot(result[result$HP_PRA=="wilcox",], aes(x=fc_PRA_HP, y=-log10(p_PRA_HP_wilcox), color=PRA_HP))+
  geom_point()+
  geom_hline(yintercept = -log10(0.05), linetype=2,linewidth=.5, color="#BBBBBB")+
  geom_vline(xintercept = c(log2(1.2),-log2(1.2)), linetype=2,linewidth=.5, color="#BBBBBB")+
  scale_color_manual(values = c("#5D669F","#BFBFBF","#AF322F"))+
  theme_test()+
  theme(axis.line = element_blank(),
        panel.border = element_rect(linewidth=.8),
        axis.ticks = element_line(linewidth=.8),
        axis.ticks.length = unit(1.25,"mm"))
ggsave("Fig 3c.pdf", width = 3.8, height = 3)

ggplot(result[result$HP_A=="wilcox",], aes(x=fc_RA_HP, y=-log10(p_RA_HP_wilcox), color=RA_HP))+
  geom_point()+
  geom_hline(yintercept = -log10(0.05), linetype=2,linewidth=.5, color="#BBBBBB")+
  geom_vline(xintercept = c(log2(1.2),-log2(1.2)), linetype=2,linewidth=.5, color="#BBBBBB")+
  scale_color_manual(values = c("#5D669F","#BFBFBF","#AF322F"))+
  theme_test()+
  theme(axis.line = element_blank(),
        panel.border = element_rect(linewidth=.8),
        axis.ticks = element_line(linewidth=.8),
        axis.ticks.length = unit(1.25,"mm"))
ggsave("Fig 3e.pdf", width = 3.8, height = 3)
