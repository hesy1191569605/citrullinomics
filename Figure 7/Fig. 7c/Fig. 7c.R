library(ggplot2)

rm(list = ls())
data = data.frame(group = c("antigenic ","antigenic ","non-antigenic ","non-antigenic "),
                  type=c("0predicted","1confirmed","0predicted","1confirmed"),
                  value=c(23,17,22,17))

ggplot(data, aes(type,value,fill=type))+
  geom_bar(stat="identity", width = .3, position = position_dodge(.7))+
  geom_text(aes(label=value))+
  scale_fill_manual(values = c("#5D669F","#AF322F"))+
  scale_y_continuous(expand = c(0,0), limits = c(0,25), breaks = c(0,5,10,15,20,25))+
  theme_classic()+
  facet_wrap(.~group,nrow=1, scales = "free")+
  theme(strip.background = element_blank(),axis.line = element_line(color="black", linewidth = .6),
        axis.ticks = element_line(color="black", linewidth = .6),
        axis.ticks.length = unit(1.3,"mm"),
        axis.text = element_text(color="black"),
        axis.text.x = element_text(angle=90))
ggsave("Fig 6c.pdf", width = 5, height = 3)