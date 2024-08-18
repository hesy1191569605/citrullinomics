library(dplyr)
library(glmnet)

rm(list = ls())
dat1 = data.table::fread("eFig 4k,4l.csv")
Y=dat1[dat1$`Responder-HM`==1,]
N=dat1[dat1$`Responder-HM`==0,]

result=NULL
list_train=list()
list_test=list()
coef_all=NULL
i=1
for(i in 1:100){
  set.seed(i)
  train=rbind(Y[sample(1:nrow(Y),9,replace = F),],N[sample(1:nrow(N),24,replace = F),])
  test=dat1[!c(dat1$ID%in%train$ID),]
  y=train$`Responder-HM`
  y_test <- test$`Responder-HM`
  
  x <- cbind(train[,c("TJC","DAS28-CRP-HM")])
  x_test <- cbind(test[,c("TJC","DAS28-CRP-HM")])
  
  cvfit=cv.glmnet(as.matrix(x), y, nfolds = 10,family="binomial",alpha=0)
  ridge <- glmnet(as.matrix(x),y, family="binomial", lambda=cvfit$lambda.min, alpha=0)
  coef=data.frame(ID=colnames(x),i=rep(i,ncol(x)),coef=coef(ridge)@x[2:(ncol(x)+1)])
  
  train_y <- predict(ridge,as.matrix(x), type="response") 
  df=data.frame(y,train_y=as.numeric(train_y))
  train_auc=multipleROC(y~train_y,data=df,plot =F)[["auc"]]
  
  
  test_y <- predict(ridge,as.matrix(x_test), type="response") 
  df1=data.frame(y_test,test_y=as.numeric(test_y))
  test_auc=multipleROC(y_test~test_y,data=df1,plot =F)[["auc"]]
  
  result=rbind(result, data.frame(i,train_auc, test_auc))
  
  coef_all=rbind(coef_all,coef)
  
  list_train[[i]]=multipleROC(y~train_y,data=df,plot =F)
  list_test[[i]]=multipleROC(y_test~test_y,data=df1,plot =F)
}


re=reshape2::melt(result,id.vars=1)
ggplot(re,aes(value, fill=variable))+
  geom_density(alpha=.5)+
  geom_vline(xintercept = c(median(result$train_auc), median(result$test_auc)), linetype=2, color=c("#AF322F","#5D669F"))+
  scale_fill_manual(values = c("#AF322F","#5D669F"),name="", label=c("Train","Test"))+
  theme_minimal()+
  labs(x="AUROC",y="Density")+
  scale_y_continuous(expand = c(0,0))+
  theme(axis.line = element_line(color="black"),
        axis.ticks = element_line(color="black"),
        axis.text = element_text(color="black", size=13),
        axis.title = element_text(color="black", size=13),
        legend.position = "bottom")
ggsave("eFig 4k (left).pdf",  width = 3, height = 3.4)


range(result$train_auc);range(result$test_auc)
median(result$train_auc);median(result$test_auc)

plot_ROC(list_train,show.AUC = F,show.points = F,
         show.eta=FALSE,
         show.sens=FALSE 
)+scale_color_manual(values = rep(rgb(93,102,159,20, maxColorValue = 255),100))+
  theme(axis.text = element_text(color="black", size=13),
        axis.title = element_text(color="black", size=13),
        panel.grid = element_blank())+
  annotate("text",x=0.65,y=0.2, label="AUROC range: 0.65-0.94", size=4)+
  annotate("text",x=0.65,y=0.1, label="Median AUROC: 0.80", size=4)
ggsave("eFig 4k (middle).pdf", width = 3.2, height = 3)



plot_ROC(list_test,show.AUC = F,show.points = F,
         show.eta=FALSE,
         show.sens=FALSE 
)+scale_color_manual(values = rep(rgb(175,50,47,20, maxColorValue = 255),100))+
  theme(axis.text = element_text(color="black", size=13),
        axis.title = element_text(color="black", size=13),
        panel.grid = element_blank())+
  annotate("text",x=0.65,y=0.2, label="AUROC range: 0.61-0.93", size=4)+
  annotate("text",x=0.65,y=0.1, label="Median AUROC: 0.77", size=4)
ggsave("eFig 4k (right).pdf", width = 3.2, height = 3)



ggplot(coef_all, aes(x = coef, y = ID)) +
  geom_density_ridges_gradient(aes(fill = stat(x)), scale = 1.2, size = 0.5, rel_min_height = 0.01) +  
  geom_vline(xintercept = 0, linetype=2)+
  scale_fill_gradient2(high="#AF322F", low="#5D669F", limits=c(-4.5,4.5), breaks=c(-3,0,3))+
  coord_cartesian(xlim=c(-5,4))+
  theme_classic()+
  theme(axis.line = element_line(color="black"),
        axis.ticks = element_line(color="black"),
        axis.text = element_text(color="black", size=13),
        axis.title = element_text(color="black", size=13),
        legend.position = "bottom")
ggsave("Fig 4l.pdf", width = 6, height = 5)