rm(list=ls())
library(ggplot2)

pca = data.table::fread("Fig 1e.csv")
ggplot(data = pca, aes(x = Dim.1, y = Dim.2)) +
  geom_point(aes(color = group), size = 2, alpha=1) + 
  scale_color_manual(values = c(RA="#D72E2A",HP="#3D7DAE",PRA="#EAC450")) + 
  theme(panel.grid = element_blank(), panel.background = element_rect(color = 'black', fill = 'transparent'), 
        legend.key = element_rect(fill = 'transparent'),
        legend.position = "bottom") + 
  labs(x =  paste('PCA1:', 15.1, '%'), y = paste('PCA2:', 7.33, '%'), color = '')+  
  stat_ellipse(aes(fill = group), geom = 'polygon', level = 0.95, alpha = 0.2, show.legend = FALSE) +
  scale_fill_manual(values = c(RA="#D72E2A",HP="#3D7DAE",PRA="#EAC450"))
