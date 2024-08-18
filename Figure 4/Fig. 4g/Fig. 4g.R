library(ggplot2)

dat = read.csv("Fig 4g.csv")
ggplot(dat,aes(variable,order,fill=rho,size=-log10(p)))+
  geom_point(shape=21)+
  scale_size(range=c(3,7))+
  scale_fill_gradient2(high="#AF322F", low="#5D669F", limits=c(-0.4,0.4))+
  theme_minimal()+
  theme(axis.line = element_line(color="black"),
        axis.ticks = element_line(color='black'),
        axis.text.x = element_text(angle=90))
ggsave("Fig 4g.pdf", width = 4, height = 6.5)