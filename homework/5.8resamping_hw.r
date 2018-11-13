
library(mlbench)
data(Ozone)
names(Ozone) <- c("Month", "Day_of_month", "Day_of_week", "ozone_reading", "pressure_height", "Wind_speed", "Humidity", "Temperature_Sandburg", "Temperature_ElMonte", "Inversion_base_height", "Pressure_gradient", "Inversion_temperature", "Visibility") 
atn <- na.omit(Ozone[, 4:13])
dim(atn)

# 7.5.1 holdout method
set.seed ( 1 )
train1 <- sample (...)
lmfit1 <- lm ( ...)
attach ( atn )
pred1 <- predict ( ...)
mean ( ( ozone_reading [ - train1 ] - pred1 ) ^ 2 )


# 7.5.2 leave one out cross validation
#install.packages("boot")
library ( boot )
glmfit1 <- glm ( ...)
cv.err1 <- cv.glm ( ... )
cv.err1 $ delta

# 7.5.3 K-fold cross validation
set.seed ( 3 )
glmfit2 <- glm ( ... )
cv.err2 <- cv.glm (... )
cv.err2 $ delta

# 7.5.4 Bootstrap
boot.f <- function ( data , index ){
  fit <- lm ( ozone_reading ~ Temperature_ElMonte , data = data , subset = index )
  return ( coef ( fit ) )
}
set.seed ( 4 )
boot ( ... )
fit <- lm ( ... )
summary ( fit ) $ coef

