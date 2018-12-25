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


#formular to be used
#use only atmospere forcing
f1 <- SWC_F_MDS_1 ~TA_F+SW_IN_POT+SW_IN_F+LW_IN_F+VPD_F+PA_F+P_F+WS_F

# library(nnet)
#class.ind
#install.packages("nnet",repos ="https://mirrors.tuna.tsinghua.edu.cn/CRAN/")
library(nnet)
regular <- function ( x ) { # define regular() to standadize the data
        ncol <- dim ( x ) [ 2 ] - 1 
        nrow <- dim ( x ) [ 1 ] 
        new <- matrix ( 0 , nrow , ncol ) 
        for ( i in 1:ncol ) {
                max = max ( x [ , i ],na.rm=T )
                min = min ( x [ , i ],na.rm=T )
                for ( j in 1 : nrow )
                { new [ j , i ] = ( x [ j , i ] - min ) / ( max-min ) }
        }
        x [ , 1 : ( dim ( x ) [ 2 ] - 1 ) ] <- new
        return(x)
}
#nnet need to standize the data
krus <- regular ( kru ) 
#seprate the dataset into training and testing dataset
set.seed ( 1 )
index <- sample ( nrow (krus ) , 3500) 
summary(krus)
xs <- c("TA_F","SW_IN_POT","SW_IN_F","LW_IN_F","VPD_F","PA_F","P_F","WS_F")
train <- krus [ index , c(xs,"SWC_F_MDS_1")]
test <- krus [ - index , c(xs,"SWC_F_MDS_1")]
train <- na.omit(train)
test  <- na.omit(test)

trainx <- train [ , xs ]
trainy <- train [ , "SWC_F_MDS_1" ]
testx <- test [ ,xs ] 
testy <- test [ , 5 ]

model1 <- nnet ( trainx , trainy , size = 0 , skip = T ,na.action=na.omit) # nnet without hidden nodes
summary ( model1 )
model1$value   #value of fitting criterion plus weight decay term
pred1 <- predict ( ... ) # predixtion is a matrix
#R2
tse <- sum((test$SWC_F_MDS_1-mean(test$SWC_F_MDS_1,na.rm=T))^2,na.rm=T)
sse <- sum((test$SWC_F_MDS_1-pred1)^2,na.rm=T)
1-sse/tse

r <- 1 / max ( abs ( trainx) ) 
model2 <- nnet ( trainx , trainy , decay = 5e-4 , maxit = 1000 , size = 2 , rang = r )
summary ( model2 )
pred2 <- predict ( ... )    
#R2
sse <- sum((test$SWC_F_MDS_1-pred2)^2,na.rm=T)
1-sse/tse



# library ( neuralnet ), not working for data(AT_Neu_Jul_2010)
#install.packages("neuralnet")
library ( grid ) 
library ( MASS )
library ( neuralnet )

###backprop
model0 <- neuralnet ( f1 , data = train , hidden = 1 , learningrate = 0.08 , 
                      algorithm = ... , linear.output = F )   
( train.error <- ... )
( steps <- ... )
predm0 <- ...
( test.error <- sum ( ( predm0 - test [ , 9 ] ) ^ 2 ) / 2 )
#R2
sse <- sum((test$SWC_F_MDS_1-predm0)^2,na.rm=T)
1-sse/tse


##Rprop
library ( grid )
model00 <- neuralnet ( f1 , data = train , hidden = 1 )   
model00 $ result.matrix
( train.error <- ...)
predm00 <- ...
( test.error <- sum ( ( predm00 - test [ , 9 ] ) ^ 2 ) / 2 )
#R2
sse <- sum((test$SWC_F_MDS_1-predm00)^2,na.rm=T)
1-sse/tse


#try to establish 5 models with differnt parameters
model01 <-...
...



model02  <-...
...

model03  <-...
...

model04  <-...
...

model05  <-...
...