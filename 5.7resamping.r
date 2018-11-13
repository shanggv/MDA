# 7.5.1 holdout method
library(bigleaf)
data ( AT_Neu_Jul_2010)
atn <-na.omit(AT_Neu_Jul_2010[,5:15])
dim (atn )

set.seed ( 1 )
train1 <- sample ( 1327 , 1327 / 2 )
lmfit1 <- lm ( Tair ~. , data = atn , subset = train1 )
attach ( atn )
pred1 <- predict ( lmfit1 , atn [ - train1 , ] )
mean ( ( Tair [ - train1 ] - pred1 ) ^ 2 )
err1 <- rep ( 0 , 10 )
for ( i in 1 : 10 ) {
  train2 <- sample (  1327 ,  1327 / 2 )
  lmfit2 <- lm ( Tair ~. , data = atn , subset = train2 )
  pred2 <- predict ( lmfit2 , atn [ - train2 , ] )
  err1 [ i ] <- mean ( ( Tair [ - train2 ] - pred2 ) ^ 2 , na.rm=T)
}
plot ( 1 : 10 , err1 , xlab = "" , ylim = c ( 5.5 , 6.5 ) , type = "l" ,main = "10 different holdout" )
detach ( atn )

# 7.5.2 leave one out cross validation
#install.packages("boot")
library ( boot )
glmfit1 <- glm ( Tair ~. , data = atn )
cv.err1 <- cv.glm ( atn , glmfit1 )
cv.err1 $ delta

# 7.5.3 K-fold cross validation
set.seed ( 3 )
glmfit2 <- glm ( Tair ~. , data = atn )
cv.err2 <- cv.glm ( atn , glmfit2 , K = 10 )
cv.err2 $ delta
err2 <- rep ( 0 , 10 )
for ( i in 1 : 10 ) {
  glmfit3 <- glm ( Tair ~. , data = atn )
  cv.err3 <- cv.glm ( atn , glmfit3 , K = 10 )
  err2 [ i ] <- cv.err3 $ delta [ 1 ]
}
plot ( 1 : 10 , err2 , xlab = "" , ylim = c ( 5.5 , 6.5) , type = "l" , 
       main = "10 times of 10-fold CV" )

# 7.5.4 Bootstrap
boot.f <- function ( data , index ){
  fit <- lm ( Tair ~ VPD , data = data , subset = index )
  return ( coef ( fit ) )
}
boot.f ( atn , 1 : 1327)
set.seed ( 4 )
boot.f ( atn , sample ( 1327 , 1327 , replace = T ) )
boot ( atn , boot.f , 1000 )
fit <- lm ( Tair ~ VPD , data = atn )
summary ( fit ) $ coef

