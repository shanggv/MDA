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
summary(at5)
table ( at5 $p01)

#seprate the dataset into training and testing dataset
set.seed ( 1 )
index <- sample ( nrow ( at5 ) , 1000) 
train <- at5 [ index , ]
test <- at5 [ - index , ]
table ( train $ p01 )
table ( test $ p01 )


#decision tree
#install.packages("tree",repos ="https://mirrors.tuna.tsinghua.edu.cn/CRAN/")
library ( tree )
set.seed ( 1 )
tree.p01 <- tree ( p01 ~Tair+VPD+pressure+wind, train)
summary ( tree.p01 )
plot ( tree.p01 )
text ( tree.p01 , pretty = 0 )
tree.p01
set.seed ( 1 )
tree.pred <- predict ( tree.p01 , test , type = "class" )
table ( tree.pred , test $ p01 )
( 429 + 11 ) / dim(test)[1]

set.seed ( 1 )
cv.p01 <- cv.tree ( tree.p01 , FUN = prune.misclass )
cv.p01
plot ( cv.p01 $ size , cv.p01 $ dev , type = "b" , xlab = "Tree size" , ylab = "Error" )
prune.p01 <- prune.misclass ( tree.p01 , best = 8)
plot ( prune.p01 )
text ( prune.p01 , pretty = 0)
cv.tree.pred <- predict ( prune.p01 , test , type = "class" )
table ( cv.tree.pred , test $ p01 )
( 435 + 10 ) / dim(test)[1]

# Bagging
#install.packages("randomForest",repos ="https://mirrors.tuna.tsinghua.edu.cn/CRAN/")
library ( randomForest )
set.seed ( 1 )
bag.p01 <- randomForest ( p01~Tair+VPD+pressure+wind , data = train ,mtry=4, importance = TRUE )
bag.pred.p01 <- predict ( bag.p01 , newdata = test , type = "class" )
table ( bag.pred.p01 , test $ p01 )
( 437+ 20) / dim(test)[1]
varImpPlot ( bag.p01 )

# randomForest
set.seed ( 1 )
rf.p01 <- randomForest ( p01~Tair+VPD+pressure+wind , data = train , importance = TRUE )
rf.pred.p01 <- predict ( rf.p01 , newdata = test , type = "class" )
table ( rf.pred.p01 , test $ p01 )
( 436 + 19 ) / dim(test)[1]
importance ( rf.p01 )
varImpPlot ( rf.p01 )


# 9.6.6 Boosting
# Adaboost
#install.packages("gbm",repos ="https://mirrors.tuna.tsinghua.edu.cn/CRAN/")
library ( gbm )
#This version of AdaBoost requires the response to be in {0,1}
train.a <- train
train.a $ p01 <- as.numeric (train.a $ p01  )-1
test.a <- test
test.a $ p01 <- as.numeric (  test.a $ p01  )-1
set.seed ( 1 )
adaboost.p01 <- gbm ( p01~Tair+VPD+pressure+wind , data = train.a , distribution = "adaboost",
                        n.trees = 5000 , interaction.depth = 4 )
summary ( adaboost.p01 )
plot ( adaboost.p01 , i = "Tair" )
adaboost.pred.p01 <- predict ( adaboost.p01 , newdata = test.a, 
                                 n.trees = 5000 , type = "response" )
adaboost.pred.p01 <- ifelse ( adaboost.pred.p01 >0.5 , 1 , 0 )
table ( adaboost.pred.p01 , test $ p01 )
(423 + 18 ) / dim(test)[1]



# XGBoost
#install.packages("xgboost",repos ="https://mirrors.tuna.tsinghua.edu.cn/CRAN/")
library ( xgboost )
xgtrain_s <- Matrix::sparse.model.matrix ( p01 ~ Tair+VPD+pressure+wind-1 , data = train.a )
xgtest_s <- Matrix::sparse.model.matrix ( p01 ~Tair+VPD+pressure+wind-1 , data = test.a )
dtrain <- xgb.DMatrix ( data = xgtrain_s , label = train.a $ p01 )
dtest <- xgb.DMatrix ( data = xgtest_s , label = test.a $ p01 )
set.seed ( 1 )
xgb <- xgboost ( data = dtrain , 
                 max.depth = 10 , 
                 min_child_weight = 1 ,
                 gamma = 0.1 ,
                 colsample_bytree = 0.8 ,
                 subsample=0.8 ,
                 scale_pos_weight = 1 ,
                 eta = 0.1 , eval_metric = "auc" , 
                 nrounds = 10000 , 
                 objective = "binary:logistic",
                 verbose = 0)
predxgb_test <- predict ( xgb , xgtest_s )
xgbpt <- function ( p ) {
  prediction <- as.numeric ( predxgb_test > p )
  return ( table ( prediction , test.a $ p01 ) )
}
xgbpt ( 0.5 )
( 431 + 19 ) / dim(test)[1]
importance_matrix <- xgb.importance ( model = xgb )
print ( importance_matrix )
xgb.plot.importance ( importance_matrix = importance_matrix )


