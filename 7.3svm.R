library(e1071)
set.seed ( 123 )
x <- matrix ( rnorm ( 40 * 2 ) , ncol = 2 )
y <- rep ( c ( -1 , 1 ) , each = 20 )
x [ y == 1 , ] <- x [ y == 1 , ] + 3
plot ( x , col = y + 5 , xlab = "x1" , ylab = "x2" )
y <- as.factor ( y )
dat <- data.frame ( x = x , y = y )
svm1 <- svm ( y ~. , data = dat , kernel = "linear" , cost = 1 )
summary ( svm1 )
svm1 $ index
plot ( svm1 , dat )
svm2 <- svm ( y~ ., data = dat , kernel = "linear" , cost = 0.1 )
summary ( svm2 )
plot ( svm2 , dat )
svm3 <- svm ( y ~. , data = dat , kernel = "linear" , cost = 1e5 )
summary ( svm3 )
plot ( svm3 , dat )
set.seed ( 1234 )
tune1 <- tune ( svm , y ~. , data = dat , kernel = "linear" , 
                  ranges = list ( cost = c ( 0.01 , 0.1 , 1 , 10 , 50 ) ) )
summary ( tune1 )
best <- tune1 $ best.model
set.seed ( 1 )
xt <- matrix ( rnorm ( 40 * 2 ) , ncol = 2 )
yt <- rep ( c ( -1 , 1 ) , each = 20 )
xt [ yt == 1 , ] <- xt [ yt == 1 , ] + 3
yt <- as.factor ( yt )
datt <- data.frame ( x = xt , y = yt )
pred1 <- predict ( best , datt )
table ( predict = pred1 , true = yt )
pred2 <- predict ( svm3 , datt )
table ( predict = pred2 , true = yt )

#svm
set.seed ( 123 )
x <- matrix ( rnorm ( 100 * 2 ) , ncol = 2 )
y <- rep ( c ( -1 , 1 ) , each = 50 )
x [ y == -1 , ] <- 2 * x [ y == -1 , ]
x [ y == 1 , ] <- 0.8 * x [ y == 1 , ]
plot ( x , col = y + 5 , xlab = "x1" , ylab = "x2" )
y <- as.factor ( y )
dat <- data.frame ( x = x , y = y )
svm4 <- svm ( y ~. , data = dat , kernel = "radial" , gamma = 1 , cost = 1 )
summary ( svm4 )
plot ( svm4 , dat )
set.seed ( 1234 )
tune2 <- tune ( svm , y~. , data = dat , kernel = "radial" , ranges = 
                        list ( cost = c ( 0.01 , 0.1 , 1 , 10 , 50 ) , gamma = c ( 0.1 , 0.5 , 1 , 3 , 5 ) ) )
summary ( tune2 )
best2 <- tune2 $ best.model
xt <- matrix ( rnorm ( 100 * 2 ) , ncol = 2 )
yt <- rep ( c ( -1 , 1 ) , each = 50 )
xt [ yt == -1 , ] <- 2 * xt [ yt == -1 , ]
xt [ yt == 1 , ] <- 0.8 * xt [ yt == 1 , ]
yt <- as.factor (yt )
datt <- data.frame ( x = xt , y = yt )
pred3 <- predict ( best2 , datt )
table ( predict = pred3 , true = yt )

# example
#install.packages("ISLR")
library ( ISLR )
data ( Auto )
attach ( Auto )
Auto $ level <- as.factor ( ifelse ( mpg > median ( mpg ) , 1 , 0 ) )
detach ( Auto )
set.seed ( 123 )
n <- dim ( Auto ) [ 1 ]
train <- sample ( n , 0.7 * n )
train_d <- Auto [ train , ]
test_d <- Auto [ - train , ]
tune1 <- tune ( svm , level ~ cylinders + displacement + horsepower + weight + acceleration , 
                data = train_d , kernel = "linear" , 
                ranges = list ( cost = c ( 0.01 , 0.1 , 0.5 , 1 , 5 , 10 , 50 , 100 ) ) )
best1 <- tune1 $ best.model
summary ( best1 )
plot ( best1 , train_d , horsepower ~ weight )
pred1 <- predict ( best1 , test_d )
table ( true = test_d $ level , predict = pred1 )
( 8 + 3 ) / length ( test_d $ level ) 
tune2 <- tune ( svm , level ~ cylinders + displacement + horsepower + weight + acceleration , 
                data = train_d , kernel = "radial" , 
                ranges = list ( cost = c ( 0.1 , 1 , 5 , 10 , 50 , 100 ) , gamma = c ( 0 , 1 , 2 , 5 , 10 ) ) )
best2 <- tune2 $ best.model
summary ( best2 )
pred2 <- predict ( best2 , test_d )
table ( true = test_d $ level , predict = pred2 )
( 8 + 4 ) / length ( test_d $ level )
tune3 <- tune ( svm , level ~ cylinders + displacement + horsepower + weight + acceleration ,
                data = train_d , kernel = "polynomial" ,
                ranges = list ( cost = c ( 0.1 , 1 , 5 , 10 , 50 ) , 
                                gamma = c ( 0 , 1 , 2 , 5 ) , degree = c ( 2 , 3 ) ) )
best3 <- tune3 $ best.model
summary ( best3 )
pred3 <- predict ( best3 , test_d )
table ( true = test_d $ level , predict = pred3 )
( 6 + 5 ) / length ( test_d $ level )

