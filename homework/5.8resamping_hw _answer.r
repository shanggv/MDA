
library(mlbench)
data(Ozone)
names(Ozone) <- c("Month", "Day_of_month", "Day_of_week", "ozone_reading", "pressure_height", "Wind_speed", "Humidity", "Temperature_Sandburg", "Temperature_ElMonte", "Inversion_base_height", "Pressure_gradient", "Inversion_temperature", "Visibility") 
atn <- na.omit(Ozone[, 4:13])
dim(atn)

# 7.5.1 holdout method
set.seed ( 1 )
train1 <- sample ( 203 , 203 / 2 )
lmfit1 <- lm ( ozone_reading ~. , data = atn , subset = train1 )
attach ( atn )
pred1 <- predict ( lmfit1 , atn [ - train1 , ] )
mean ( ( ozone_reading [ - train1 ] - pred1 ) ^ 2 )


# 7.5.2 leave one out cross validation
#install.packages("boot")
library ( boot )
glmfit1 <- glm ( ozone_reading ~. , data = atn )
cv.err1 <- cv.glm ( atn , glmfit1 )
cv.err1 $ delta

# 7.5.3 K-fold cross validation
set.seed ( 3 )
glmfit2 <- glm ( ozone_reading ~. , data = atn )
cv.err2 <- cv.glm ( atn , glmfit2 , K = 10 )
cv.err2 $ delta

# 7.5.4 Bootstrap
boot.f <- function ( data , index ){
  fit <- lm ( ozone_reading ~ Temperature_ElMonte , data = data , subset = index )
  return ( coef ( fit ) )
}
set.seed ( 4 )
boot ( atn , boot.f , 1000 )
fit <- lm ( ozone_reading ~ Temperature_ElMonte , data = atn )
summary ( fit ) $ coef

