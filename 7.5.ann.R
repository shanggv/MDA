

# library(nnet)
#class.ind
#install.packages("nnet",repos ="https://mirrors.tuna.tsinghua.edu.cn/CRAN/")
library(nnet)
#class.ind() generates a class indicator function from a given factor.
v1 <- c ( "a" , "b" , "c" , "a" )
v2 <- c ( 1 , 2 , 2 , 3 )
class.ind ( v1 )
class.ind ( v2 )
?class.ind
#also check the following functions
?nnet
?predict.nnet

# predict rainy day or no rain use ANN
library(bigleaf)
#Halfhourly eddy covariance Data of the site AT-Neu, a mountain meadow in Austria from bigleaf
data(AT_Neu_Jul_2010)
?AT_Neu_Jul_2010
#Vapour-pressure deficit, or VPD, is the difference (deficit) between the amount of moisture in the air and how much moisture the air can hold when it is saturated. 
at <- AT_Neu_Jul_2010
#get a subset
at5 <- at[,c("Tair","VPD","pressure","precip", "wind")]
#add a variable indicating wheter it is a rainy day
at5$p01 <-as.factor(as.integer(at5$precip>0))
at5$precip <- NULL #delete precip
summary(at5)
table ( at5 $p01)
regular <- function ( x ) { # define regular() to standadize the data
        ncol <- dim ( x ) [ 2 ] - 1 
        nrow <- dim ( x ) [ 1 ] 
        new <- matrix ( 0 , nrow , ncol ) 
        for ( i in 1:ncol ) {
                max = max ( x [ , i ] )
                min = min ( x [ , i ] )
                for ( j in 1 : nrow )
                { new [ j , i ] = ( x [ j , i ] - min ) / ( max-min ) }
        }
        x [ , 1 : ( dim ( x ) [ 2 ] - 1 ) ] <- new
        return(x)
}
#nnet need to standize the data
at5s <- regular ( at5 ) 

library ( nnet )
set.seed ( 11 ) 
# 75% for training and 25% for testing
index <- sample ( 1 : nrow ( at5s ) , round ( 0.75 * nrow ( at5s ) ) )   
train <- at5s [ index , ]
test <- at5s [ - index , ]
trainx <- train [ , 1 : 4 ]
trainy <- train [ , 5 ]
trainy <- class.ind ( trainy ) # transfrom the data to class.ind
testx <- test [ ,1 : 4 ] 
testy <- test [ , 5 ]
model1 <- nnet ( trainx , trainy , size = 0 , skip = T ) # nnet without hidden nodes
summary ( model1 )
model1$value   #value of fitting criterion plus weight decay term

pred1 <- predict ( model1 , testx ) # predixtion is a matrix
name <- c ( "0" , "1" ) # assign the two classes
pred <- name [ max.col ( pred1 ) ]  # convert to classes
table ( testy , pred )

r <- 1 / max ( abs ( train [ , 1 : 4 ] ) ) 
model2 <- nnet ( trainx , trainy , decay = 5e-4 , maxit = 1000 , size = 2 , rang = r )
summary ( model2 )
pred2 <- predict ( model2 , testx )    
name <- c ( "0" , "1" )    
pred <- name [ max.col ( pred2 ) ]    
table ( testy , pred )

# library ( neuralnet ), not working for data(AT_Neu_Jul_2010)
#install.packages("neuralnet")

#anylysis of white wine's quality
setwd("D:/working/teaching/气象数据分析与应用/code")
wwine1 <- read.table ( "./data/wwine.txt" )
names ( wwine1) <- c ( "fixedacidity" , "volatileacidity" , "citricacid" , "residualsugar" , 
                       "chlorides" , "freesulfurdioxide" , "totalsulfurdioxide" , "density" ,
                       "pH" , "sulphates" , "alcohol" , "quality" )
dim ( wwine1 )
head ( wwine1 )
summary ( wwine1 )
normalize <- function ( x ) { return ( ( x - min ( x ) ) / ( max ( x ) - min ( x ) ) ) } # normalize the dataa
wwine1 <- as.data.frame ( lapply ( wwine1 , normalize ) )
set.seed ( 11 ) 
index <- sample ( 1 : nrow ( wwine1 ) , round ( 0.75 * nrow ( wwine1 ) ) ) 
#75% for training and 25% for testing
train <- wwine1 [ index , ]
test <- wwine1 [ - index , ]
library ( grid ) 
library ( MASS )
library ( neuralnet )
formula <- ( quality ~ fixedacidity + volatileacidity + citricacid + 
               residualsugar + chlorides + freesulfurdioxide + 
               totalsulfurdioxide + density + pH + sulphates + alcohol )
###backprop
model0 <- neuralnet ( formula , data = train , hidden = 1 , learningrate = 0.08 , 
                      algorithm = "backprop" , linear.output = F )   
( train.error <- model0 $ result.matrix [ 1 , 1 ] )
( steps <- model0 $ result.matrix [ 3 , 1 ] )
( test.error <- sum ( ( compute ( model0 , test[ , 1 : 11 ] ) $ net.result - test [ , 12 ] ) ^ 2 ) / 2 )

##Rprop
library ( grid )
model00 <- neuralnet ( formula , data = train , hidden = 1 )   
model00 $ result.matrix
( test.error <- sum ( ( compute ( model00 , test [ , 1 : 11 ] ) $ net.result - test [ , 12 ] ) ^ 2 ) / 2 ) 
model06 <- neuralnet ( formula , data = train , hidden = c ( 3 , 2 ) )   
model06 $ result.matrix
( test.error <- sum ( ( compute ( model06 , test [ , 1 : 11 ] ) $ net.result - test [ , 12 ] ) ^ 2 ) / 2 )
plot ( model06 , information = F )



