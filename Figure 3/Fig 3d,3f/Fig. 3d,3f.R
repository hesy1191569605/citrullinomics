library(ComplexHeatmap)
library(circlize)


rm(list = ls())
df = read.csv("Fig 3d.csv", row.names = 1)
col_fun = colorRamp2(c(-1, 1), c("#fbeae8","#b13835"))
top_annotation = HeatmapAnnotation(df=data.frame(group=substring(colnames(df),1,1)),
                                   col = list(group=c(H="#3D7DAE",P="#EAC450"))) 

pdf("Fig 3d.pdf",width = 4, height = 3)
Heatmap(t(scale(t(df))),name = " ",
        col = col_fun,
        top_annotation = top_annotation,
        row_split = rep(c("down in PRA","up in PRA"),c(10,12)),
        column_split = substring(colnames(df),1,1),
        cluster_columns = F,na_col = "#EEEEEE",
        cluster_rows = F,show_heatmap_legend = T,
        border = F,
        show_column_names = F,
        show_row_names = F,
        column_title = NULL)
dev.off()



rm(list = ls())
df = read.csv("Fig 3f.csv", row.names = 1)

col_fun = colorRamp2(c(-1, 1), c("#fbeae8","#b13835"))
top_annotation = HeatmapAnnotation(df=data.frame(group=substring(colnames(df),1,1)),
                                   col = list(group=c(H="#3D7DAE",A="#D72E2A"))) 

pdf("Fig 3f.pdf",width = 4, height = 3)
Heatmap(t(scale(t(df))),name = " ",
        col = col_fun,
        top_annotation = top_annotation,
        row_split = rep(c("down in RAA","up in RAA"),c(1,4)),
        column_split = substring(colnames(df),1,1),
        cluster_columns = F,na_col = "#EEEEEE",
        cluster_rows = F,
        show_heatmap_legend = T,
        border = F,
        show_column_names = F,
        show_row_names = F,
        column_title = NULL)
dev.off()



