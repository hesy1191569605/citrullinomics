library(dplyr)
library(glmnet)

rm(list = ls())

dat1 = data.table::fread("Fig 5a,5b.csv")
Y=dat1[dat1$`Responder-HM`==1,]
N=dat1[dat1$`Responder-HM`==0,]

result=NULL
list_train=list()
list_test=list()
coef_all=NULL
i=1
for(i in 1:100){
  set.seed(i)
  train=rbind(Y[sample(1:nrow(Y),round(nrow(Y)*0.5),replace = F),],N[sample(1:nrow(N),round(nrow(N)*0.5),replace = F),])
  test=dat1[!c(dat1$ID%in%train$ID),]
  y=train$`Responder-HM`
  y_test <- test$`Responder-HM`
  
  x <- cbind(train[,c("SJC","CRP","TJC","DAS28-CRP-HM")],train[,10:ncol(train)])
  x_test <- cbind(test[,c("SJC","CRP","TJC","DAS28-CRP-HM")],test[,10:ncol(test)])
  
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
ggsave("Fig 5a (left).pdf", width = 3, height = 3.3)


range(result$train_auc);range(result$test_auc)
median(result$train_auc);median(result$test_auc)

plot_ROC(list_train,show.AUC = F,show.points = F,
         show.eta=FALSE,
         show.sens=FALSE 
)+scale_color_manual(values = rep(rgb(93,102,159,20, maxColorValue = 255),100))+
  theme(axis.text = element_text(color="black", size=13),
        axis.title = element_text(color="black", size=13),
        panel.grid = element_blank())+
  annotate("text",x=0.65,y=0.2, label="AUROC range: 0.91-1", size=4)+
  annotate("text",x=0.65,y=0.1, label="Median AUROC: 0.99", size=4)

ggsave("Fig 5a (middle).pdf", width = 3.2, height = 3)


plot_ROC(list_test,show.AUC = F,show.points = F,
         show.eta=FALSE,
         show.sens=FALSE 
)+scale_color_manual(values = rep(rgb(175,50,47,20, maxColorValue = 255),100))+
  theme(axis.text = element_text(color="black", size=13),
        axis.title = element_text(color="black", size=13),
        panel.grid = element_blank())+
  annotate("text",x=0.65,y=0.2, label="AUROC range: 0.83-1", size=4)+
  annotate("text",x=0.65,y=0.1, label="Median AUROC: 0.95", size=4)
ggsave("Fig 5a (right).pdf", width = 3.2, height = 3)




coef_all$ID=ifelse(coef_all$ID=="DAS28-CRP-HM","A DAS28",
                   ifelse(coef_all$ID=="TJC","B TJC",
                          ifelse(coef_all$ID=="SJC","C SJC",
                                 ifelse(coef_all$ID=="CRP","D CRP",
                                        ifelse(coef_all$ID=="P35579_SR(pa)AIR(pa)QAK_","E P35579_SR(pa)AIR(pa)QAK_",
                                               ifelse(coef_all$ID=="P07355_IR(pa)SEFK_","F P07355_IR(pa)SEFK_",
                                                      ifelse(coef_all$ID=="P00966_SQER(pa)VEGK_","G P00966_SQER(pa)VEGK_",
                                                             ifelse(coef_all$ID=="P02671_CPSGCR(pa)MK_","H P02671_CPSGCR(pa)MK_",
                                                                    ifelse(coef_all$ID=="O00299_R(pa)R(pa)TETVQK_","I O00299_R(pa)R(pa)TETVQK_",
                                                                           ifelse(coef_all$ID=="P09669_FR(pa)VADQR(pa)K_","J P09669_FR(pa)VADQR(pa)K_",
                                                                                  ifelse(coef_all$ID=="P61981_R(pa)ATVVESSEK_","K P61981_R(pa)ATVVESSEK_",
                                                                                         ifelse(coef_all$ID=="P55084_TSNVAR(pa)EAALGAGFSDK_","L P55084_TSNVAR(pa)EAALGAGFSDK_",
                                                                                                ifelse(coef_all$ID=="P25705_R(pa)LTDADAMK_","M P25705_R(pa)LTDADAMK_",NA)))))))))))))

ggplot(coef_all, aes(x = coef, y = ID)) +
  geom_density_ridges_gradient(aes(fill = stat(x)), scale = 1.5, size = 0.5, rel_min_height = 0.01) +  
  geom_vline(xintercept = 0, linetype=2)+
  scale_fill_gradient2(high="#AF322F", low="#5D669F", limits=c(-4.4,3.7))+
  coord_cartesian(xlim=c(-5,4))+
  theme_classic()+
  theme(axis.line = element_line(color="black"),
        axis.ticks = element_line(color="black"),
        axis.text = element_text(color="black", size=13),
        axis.title = element_text(color="black", size=13),
        legend.position = "bottom")
ggsave("Fig 5b.pdf", width = 6, height = 5)
