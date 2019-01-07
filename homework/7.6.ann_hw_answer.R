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

pred1 <- predict ( model1 , testx ) # predixtion is a matrix
#R2
tse <- sum((test$SWC_F_MDS_1-mean(test$SWC_F_MDS_1,na.rm=T))^2,na.rm=T)
sse <- sum((test$SWC_F_MDS_1-pred1)^2,na.rm=T)
1-sse/tse
#0.3403406
r <- 1 / max ( abs ( trainx) ) 
model2 <- nnet ( trainx , trainy , decay = 5e-4 , maxit = 1000 , size = 2 , rang = r )
summary ( model2 )
pred2 <- predict ( model2 , testx )    
#R2
sse <- sum((test$SWC_F_MDS_1-pred2)^2,na.rm=T)
1-sse/tse
#0.3712787


# library ( neuralnet ), not working for data(AT_Neu_Jul_2010)
#install.packages("neuralnet")
library ( grid ) 
library ( MASS )
library ( neuralnet )

###backprop
model0 <- neuralnet ( f1 , data = train , hidden = 1 , learningrate = 0.08 , 
                      algorithm = "backprop" , linear.output = F )   
( train.error <- model0 $ result.matrix [ 1 , 1 ] )
( steps <- model0 $ result.matrix [ 3 , 1 ] )
predm0 <- compute ( model0 , test[ , 1 : 8 ] ) $ net.result
( test.error <- sum ( ( predm0 - test [ , 9 ] ) ^ 2 ) / 2 )
#R2
sse <- sum((test$SWC_F_MDS_1-predm0)^2,na.rm=T)
1-sse/tse
#-1.650416045


##Rprop
library ( grid )
model00 <- neuralnet ( f1 , data = train , hidden = 1 )   
model00 $ result.matrix
( train.error <- model00 $ result.matrix [ 1 , 1 ] )
predm00 <- compute ( model00 , test[ , 1 : 8 ] ) $ net.result
( test.error <- sum ( ( predm00 - test [ , 9 ] ) ^ 2 ) / 2 )
#R2
sse <- sum((test$SWC_F_MDS_1-predm00)^2,na.rm=T)
1-sse/tse
#0.3580461447

#try to establish 5 models with differnt parameters
model01 <-neuralnet ( f1 , data = train , hidden = 4 )   
( train.error <- model01 $ result.matrix [ 1 , 1 ] )
predm01 <- compute ( model01 , test[ , 1 : 8 ] ) $ net.result
( test.error <- sum ( ( predm01 - test [ , 9 ] ) ^ 2 ) / 2 )
#R2
sse <- sum((test$SWC_F_MDS_1-predm01)^2,na.rm=T)
1-sse/tse
#0.4019136648
#hidden=6 failed to get a model

model02 <-neuralnet ( f1 , data = train , hidden = c(2,1) )   
( train.error <- model02 $ result.matrix [ 1 , 1 ] )
predm02 <- compute ( model02 , test[ , 1 : 8 ] ) $ net.result
( test.error <- sum ( ( predm02 - test [ , 9 ] ) ^ 2 ) / 2 )
#R2
sse <- sum((test$SWC_F_MDS_1-predm02)^2,na.rm=T)
1-sse/tse
#0.3781135721

model03 <-neuralnet ( f1 , data = train , hidden = c(3,1) )   
( train.error <- model03 $ result.matrix [ 1 , 1 ] )
predm03 <- compute ( model03 , test[ , 1 : 8 ] ) $ net.result
( test.error <- sum ( ( predm03 - test [ , 9 ] ) ^ 2 ) / 2 )
#R2
sse <- sum((test$SWC_F_MDS_1-predm03)^2,na.rm=T)
1-sse/tse
# 0.4130243133

model04 <-neuralnet ( f1 , data = train , hidden = c(2,1,1) ) 
( train.error <- model04 $ result.matrix [ 1 , 1 ] )
predm04 <- compute ( model04 , test[ , 1 : 8 ] ) $ net.result
( test.error <- sum ( ( predm04 - test [ , 9 ] ) ^ 2 ) / 2 )
#R2
sse <- sum((test$SWC_F_MDS_1-predm04)^2,na.rm=T)
1-sse/tse
#0.378189816


model05 <-neuralnet ( f1 , data = train , hidden = c(3,1,1) ) 
( train.error <- model05 $ result.matrix [ 1 , 1 ] )
predm05 <- compute ( model05 , test[ , 1 : 8 ] ) $ net.result
( test.error <- sum ( ( predm05 - test [ , 9 ] ) ^ 2 ) / 2 )
#R2
sse <- sum((test$SWC_F_MDS_1-predm05)^2,na.rm=T)
1-sse/tse
#0.4051951445
#takes more than ten minutes and failed when  hidden = c(3,2)
save.image("D:/working/teaching/气象数据分析与应用/code/ann_hw.RData")

