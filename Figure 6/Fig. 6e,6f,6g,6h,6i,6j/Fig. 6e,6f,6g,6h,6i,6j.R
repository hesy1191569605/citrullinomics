library(dplyr)
library(ggplot2)
library(ggpubr)

rm(list = ls())

# pos
bp = data.table::fread("pos_all GOBP.txt")%>%arrange(PValue)%>%filter(PValue<0.05)
bp = bp[1:5]%>%arrange(-PValue)%>%mutate(order=letters[1:5], group=rep("GOBP pos",5))

cc = data.table::fread("pos_all GOCC.txt")%>%arrange(PValue)%>%filter(PValue<0.05)
cc = cc[1:5]%>%arrange(Count)%>%mutate(order=letters[1:5], group=rep("GOCC pos",5))

mf = data.table::fread("pos_all GOMF.txt")%>%arrange(PValue)%>%filter(PValue<0.05)
mf = mf[1:5]%>%arrange(Count)%>%mutate(order=letters[1:5], group=rep("GOMF pos",5))


# neg
bp1 = data.table::fread("neg_all GOBP.txt")%>%arrange(PValue)%>%filter(PValue<0.05)
bp1 = bp1[1:5]%>%arrange(Count)%>%mutate(order=letters[1:5], group=rep("GOBP neg",5))

cc1 = data.table::fread("neg_all GOCC.txt")%>%arrange(PValue)%>%filter(PValue<0.05)
cc1 = cc1[1:5]%>%arrange(Count)%>%mutate(order=letters[1:5], group=rep("GOCC neg",5))

mf1 = data.table::fread("neg_all GOMF.txt")%>%arrange(PValue)%>%filter(PValue<0.05)
mf1 = mf1[1:5]%>%arrange(Count)%>%mutate(order=letters[1:5], group=rep("GOMF neg",5))



data = rbind(mf, mf1, bp, bp1, cc, cc1)
data$Description = gsub(".*\\~","",data$Term)%>%stringr::str_to_title() 


group = unique(data$group)

p_list <- lapply(group, function(x){
  ggplot(data[data$group==x,], aes(Count, order, fill=-log10(PValue)))+
    geom_bar(stat="identity", width = .6, color="transparent")+
    scale_fill_gradient(high="#FCA305", low="#A0CEE2")+
    scale_x_continuous(expand = c(0,0))+
    scale_y_discrete(label=data$Description[data$group==x])+
    theme_minimal()+
    theme(axis.line = element_line(color="black", linewidth = .7),
          axis.ticks = element_line(color="black", linewidth = .7))+
    ggtitle(x)
})

pdf("Fig 6e,6f,6g,6h,6i,6j.pdf", width = 18, height = 6)
do.call(gridExtra::grid.arrange,c(p_list, ncol=3))
dev.off()

