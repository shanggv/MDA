#intall package mlbench: Machine Learning Benchmark Problems
#data from http://rstatistics.net
install.packages("mlbench",repos ="https://mirrors.tuna.tsinghua.edu.cn/CRAN/")
library(mlbench)
#you need to change to your own working directory
setwd("D:/working/teaching/气象数据分析与应用/code")

#load ozone data
data(Ozone)
#look at the data description
?Ozone
#look at the data content
View(Ozone)
#assign names to each varibale
names(Ozone) <- c("Month", "Day_of_month", "Day_of_week", "ozone_reading", "pressure_height", "Wind_speed", "Humidity", "Temperature_Sandburg", "Temperature_ElMonte", "Inversion_base_height", "Pressure_gradient", "Inversion_temperature", "Visibility") 
#inversion base height is 逆温层高度
#covert factors to integer for time varibles
Ozone[,1] <- as.integer(Ozone[,1])
Ozone[,2] <- as.integer(Ozone[,2])
Ozone[,3] <- as.integer(Ozone[,3])

#calculate correlation between varibalesm, take a look at r
r<-cor(Ozone,use="complete.obs")
r
#calculate the autocorrlation of ozone_reading, fill the ... with the right code
ar <- acf(...,na.action = na.pass)
ar



#fit a linear model, you can use any variable as the predicted, here take ozone as a example, fill the ... with the right code
lm1 <- lm(ozone_reading~Month+Day_of_month+Day_of_week+pressure_height+Wind_speed+Humidity+Temperature_Sandburg+Temperature_ElMonte+Inversion_base_height+Pressure_gradient+Inversion_temperature+Visibility, data=...)
summary(lm1)



#stepwise regression using mode backward, fill the ... with the right code
lm2 <- step(...,direction="backward")
summary(lm2)

#stepwise regression using mode forward, fill the ... with the right code
#currently, step() can not treat variable with NA value, the following model fails
lm3 <- step(...)
summary(lm3)

#stepwise regression using mode both, is this one the best model?
lm4 <- step(...)
summary(lm4)



# try get the best model
lm5 <- lm(...)
summary(lm5)
#maybe more steps?
lm6 <- lm(...)
summary(lm6)


# take a look at correlation again, are the variables with high correlation is the best model? why?
r

# what does these figure means?? Any way to improve the model?
plot(lm6)

