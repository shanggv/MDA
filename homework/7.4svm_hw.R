library(e1071)

#you need to change to your own working directory
setwd("D:/working/teaching/气象数据分析与应用/code")
#descriotion of the data is here: http://fluxnet.fluxdata.org/data/fluxnet2015-dataset/subset-data-product/
#lae <- read.csv("./data/FLX_CH-Lae_FLUXNET2015_SUBSET_DD_2004-2014_1-3.csv")
#blo <- read.csv("./data/FLX_US-Blo_FLUXNET2015_SUBSET_DD_1997-2007_1-3.csv")
kru <- read.csv("./data/FLX_ZA-Kru_FLUXNET2015_SUBSET_DD_2000-2010_1-3.csv")

# get out irrelavant variables
#kru <- kru[,1:36]
kru <- kru[,-grep("_QC",names(kru))]
names(kru)

#set -9999 to NA
kru[kru==-9999] <-NA
summary(kru)

#seprate the dataset into training and testing dataset
set.seed ( 1 )
#use only 350 sample to save time
index <- sample ( nrow (kru ) , 1000) 
train <- kru [...]
test <- kru [ ... ]

#formular to be used
#use only atmospere forcing
f1 <- SWC_F_MDS_1 ~TA_F+SW_IN_POT+SW_IN_F+LW_IN_F+VPD_F+PA_F+P_F+WS_F
#adding co2, GPP and soil temperature
f2 <-  SWC_F_MDS_1 ~ TA_F+SW_IN_POT+SW_IN_F+LW_IN_F+VPD_F+PA_F+P_F+WS_F+CO2_F_MDS +GPP_DT_VUT_REF+ TS_F_MDS_1


# only use varibales without too many NA, as many as possible
summary(kru)
f3 <-  SWC_F_MDS_1 ~ TA_F+SW_IN_POT+SW_IN_F+LW_IN_F+VPD_F+PA_F+P_F+WS_F+CO2_F_MDS + TS_F_MDS_1+  LE_F_MDS + H_F_MDS+  NEE_VUT_REF +NEE_VUT_25+NEE_VUT_50+ NEE_VUT_75+RECO_NT_VUT_REF+RECO_NT_VUT_25+RECO_NT_VUT_50+RECO_NT_VUT_75+GPP_NT_VUT_REF+GPP_NT_VUT_25+GPP_NT_VUT_50+GPP_NT_VUT_75+RECO_DT_VUT_REF+RECO_DT_VUT_25 +RECO_DT_VUT_50+RECO_DT_VUT_75+GPP_DT_VUT_REF+ GPP_DT_VUT_25+GPP_DT_VUT_50 +GPP_DT_VUT_75 

#############################################
#the flowing use f1  as an example, you may try f2,f3 
########################
train_d <- na.omit(train[,c("SWC_F_MDS_1","TA_F","SW_IN_POT","SW_IN_F","LW_IN_F","VPD_F","PA_F", "P_F", "WS_F")])
test_d <- na.omit(test[,c("SWC_F_MDS_1","TA_F","SW_IN_POT","SW_IN_F","LW_IN_F","VPD_F","PA_F", "P_F", "WS_F")])

###support vector classifier
tune1 <- tune ( svm , f1 , 
                data = train_d , kernel = "linear" , 
                ranges = list ( cost = c ( 0.01 , 0.1 , 0.5 , 1 , 5 , 10 , 50 , 100 ) ) )
summary ( tune1 )
best1 <- ...
summary ( best1 )
pred1 <- predict ( ... )
#R2
tse <- ...
sse <- ...
1-sse/tse



tune2 <- tune ( svm , f1 , 
                data = train_d , kernel = "radial" , 
                ranges = list ( cost = c ( 0.1 , 1 , 5 , 10 , 50 , 100 ) , gamma = c ( 0 , 1 , 2 , 5 , 10 ) ) )
best2 <- ...
summary ( best2 )
pred2 <- predict ( ... )
#R2
sse <- ...
1-sse/tse



