
library(ggplot2)

rm(list = ls())
result=read.csv("response wilcox result  MTXLEF.csv")

result$label=ifelse(result$color_YN_mean=="up"|result$color_YN_mean=="down",result$Gene_position,NA)
ggplot(result[result$n_Y>=5 & result$n_N>=5, ], aes(fc_YN_mean,-log10(p_YN),color=color_YN_mean))+
  geom_point()+
  geom_vline(xintercept = c(log2(1.1), log2(1/1.1)), linetype=2)+
  geom_hline(yintercept = -log10(0.05), linetype=2)+
  geom_text(aes(label=label),nudge_x=0.1,nudge_y=.1,size=2)+
  scale_color_manual(values=c("#5D669F","#BBBBBB","#AF322F"),name="")+
  theme_test()+
  labs(x="Log2(Y/N)", y="-Log10(p value)",title = "")+
  theme(axis.text = element_text(color="black",size=12))
ggsave("Fig 4e left.pdf", width = 3.5, height = 3)



rm(list = ls())
dat2 = read.csv("Fig 4e right.csv")

ggplot(dat2)+
  geom_bar(aes(fc_YN_mean,order),stat="identity",width=.01, color="black")+
  geom_bar(aes(log2(fc_YN_mean_pro),order),stat="identity",width=.01, color="black")+
  geom_point(aes(fc_YN_mean,order,fill=fc_YN_mean,size=-log10(p_YN)), shape=21)+
  geom_point(aes(log2(fc_YN_mean_pro),order,fill=log2(fc_YN_mean_pro),size=-log10(p_YN_pro)), shape=24)+
  scale_size(range=c(2,5))+
  scale_fill_gradient2(high="#AF322F", low="#5D669F", limits=c(-0.8,0.8))+
  theme_minimal()+
  theme(axis.line = element_line(color="black"),
        axis.ticks = element_line(color='black'))
ggsave("Fig 4e right.pdf", width = 3.5, height = 4)



rm(list = ls())
result=read.csv("response wilcox result  MTXHCQ.csv")

result$label=ifelse(result$color_YN_mean=="up"|result$color_YN_mean=="down",result$Gene_position,NA)
ggplot(result[result$n_Y>=5 & result$n_N>=5, ], aes(fc_YN_mean,-log10(p_YN),color=color_YN_mean))+
  geom_point()+
  geom_vline(xintercept = c(log2(1.1), log2(1/1.1)), linetype=2)+
  geom_hline(yintercept = -log10(0.05), linetype=2)+
  geom_text(aes(label=label),nudge_x=0.1,nudge_y=.1,size=2)+
  scale_color_manual(values=c("#5D669F","#BBBBBB","#AF322F"),name="")+
  theme_test()+
  labs(x="Log2(Y/N)", y="-Log10(p value)",title = "")+
  theme(axis.text = element_text(color="black",size=12))
ggsave("Fig 4f left.pdf", width = 3.5, height = 3)



rm(list = ls())
dat2 = read.csv("Fig 4f right.csv")

ggplot(dat2)+
  geom_bar(aes(fc_YN_mean,order),stat="identity",width=.01, color="black")+
  geom_bar(aes(log2(fc_YN_mean_pro),order),stat="identity",width=.01, color="black")+
  geom_point(aes(fc_YN_mean,order,fill=fc_YN_mean,size=-log10(p_YN)), shape=21)+
  geom_point(aes(log2(fc_YN_mean_pro),order,fill=log2(fc_YN_mean_pro),size=-log10(p_YN_pro)), shape=24)+
  scale_size(range=c(5,10))+
  scale_fill_gradient2(high="#AF322F", low="#5D669F", limits=c(-0.8,0.8))+
  theme_minimal()+
  scale_x_continuous(limits = c(-0.33,0.26), breaks = c(-0.2,0,0.2),expand = c(0.01,0.01))+
  theme(axis.line = element_line(color="black"),
        axis.ticks = element_line(color='black'))
ggsave("Fig 4f right.pdf", width = 5, height = 3)