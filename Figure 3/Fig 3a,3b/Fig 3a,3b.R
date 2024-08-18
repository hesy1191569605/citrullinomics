library(ggplot2)
result=read.csv("wilcox result (male and female).csv")

result$color=ifelse(result$F_PRA_HP=="up" & result$M_PRA_HP=="up","up",
                    ifelse(result$F_PRA_HP=="down" & result$M_PRA_HP=="down","down","ns")); table(result$color)

ggplot(result, aes(x=F_fc_PRA_HP, y=M_fc_PRA_HP, color=color))+
  geom_abline(intercept = 0, slope = 1, linetype=2,linewidth=.5, color="#BBBBBB")+
  geom_vline(xintercept = c(log2(1.2),-log2(1.2)), linetype=2,linewidth=.5, color="#BBBBBB")+
  geom_hline(yintercept = c(log2(1.2),-log2(1.2)), linetype=2,linewidth=.5, color="#BBBBBB")+
  geom_point()+
  scale_color_manual(values = c("#5D669F","#BFBFBF","#AF322F"),name="")+
  theme_test()+
  theme(axis.line = element_blank(),
        panel.border = element_rect(linewidth=.8),
        axis.ticks = element_line(linewidth=.8),
        axis.ticks.length = unit(1.25,"mm"))
ggsave("Fig 3a.pdf", width = 3.8, height = 3)

cor.test(result$F_fc_PRA_HP, result$M_fc_PRA_HP, method="spearman")

result$color=ifelse(result$F_RAA_HP=="up" & result$M_RAA_HP=="up","up",
                    ifelse(result$F_RAA_HP=="down" & result$M_RAA_HP=="down","down","ns")); table(result$color)

ggplot(result, aes(x=F_fc_RAA_HP, y=M_fc_RAA_HP, color=color))+
  geom_abline(intercept = 0, slope = 1, linetype=2,linewidth=.5, color="#BBBBBB")+
  geom_vline(xintercept = c(log2(1.2),-log2(1.2)), linetype=2,linewidth=.5, color="#BBBBBB")+
  geom_hline(yintercept = c(log2(1.2),-log2(1.2)), linetype=2,linewidth=.5, color="#BBBBBB")+
  geom_point()+
  scale_color_manual(values = c("#5D669F","#BFBFBF","#AF322F"),name="")+
  theme_test()+
  theme(axis.line = element_blank(),
        panel.border = element_rect(linewidth=.8),
        axis.ticks = element_line(linewidth=.8),
        axis.ticks.length = unit(1.25,"mm"))
ggsave("Fig 3b.pdf", width = 3.8, height = 3)

cor.test(result$F_fc_RAA_HP, result$M_fc_RAA_HP, method="spearman")