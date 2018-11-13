#intall package mlbench: Machine Learning Benchmark Problems
#data and methods from http://rstatistics.net
#install.packages("mlbench",repos ="https://mirrors.tuna.tsinghua.edu.cn/CRAN/")
library(mlbench)
#you need to change to your own working directory
#setwd("D:/working/teaching/气象数据分析与应用/code")

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

#calculate correlation between varibales 
r<-cor(Ozone,use="complete.obs")
r
#calculate the autocorrlation of ozone_reading
ar <- acf(Ozone$ozone_reading,na.action = na.pass)
ar

#fit a linear model, you can use any variable as the predicted, here take ozone as a example
lm1 <- lm(ozone_reading~., data=Ozone)
summary(lm1)


#stepwise regression using mode backward
lm2 <- step(lm1,direction="backward")
summary(lm2)

#stepwise regression using mode forward
#currently, step() can not treat variable with NA value, the following model fails
lm3 <- step(lm(ozone_reading~1,data=Ozone),scope=ozone_reading~pressure_height+Wind_speed+Humidity+Temperature_Sandburg+Temperature_ElMonte+Inversion_base_height+Pressure_gradient+Inversion_temperature+Visibility, direction="forward")
summary(lm3)

#stepwise regression using mode both, is this one the best model?
lm4 <- step(lm1,direction="both")
summary(lm4)



# try get out the Inversion_base_height with out significant coefficient based on lm4
lm5 <- lm(ozone_reading~Month+pressure_height+Humidity+Temperature_Sandburg+Temperature_ElMonte, data=Ozone)
summary(lm5)

# try get out varibles with out significant coefficient(<0.05), according to lm4, get pressure_height out first
lm6 <- lm(ozone_reading~Month+Humidity+Temperature_ElMonte+Temperature_Sandburg, data=Ozone)
summary(lm6)
#finnally all coefficients are significant, is this the best one? not sure. May use more options and cross validation to get one

# what does these figure means?? Any way to improve the model?
plot(lm6)

# take a look at correlation again, are the variables with high correlation in the best model? why?
r
# for ozone_reading,  variables with high absolut correlation (>0.5) are pressure_height, Humidity,Temperature_Sandburg, Temperature_ElMonte, Inversion_base_height, Inversion_temperature
# in model lm4, Inversion_temperature does not appeared, while Month appeared thouth it has a low correlation with ozone
#in model lm6,....


#########################################################
######the following is optional, looking for better regression
summary(lm6)
#the fisrt plot indicates that we need a squared term of a variable
plot(lm6)
# differnt methods for differnt objects in r
methods(plot)
#look at the first row of the following plot, we find squared Month and Temperature_ElMonte or Temperature_Sandburg can be used. Because Temperature_ElMonte and Temperature_Sandburg are highly correlated, use only Temperature_ElMonte^2
plot (Ozone[,c("ozone_reading","Month", "Humidity", "Temperature_ElMonte", "Temperature_Sandburg")])


#get rid of NA rows to avoid error in 
Ozone1 <- na.omit(Ozone[c("ozone_reading","Month", "Humidity", "Temperature_ElMonte", "Temperature_Sandburg")])
lms <- lm(ozone_reading ~ Month + Humidity + Temperature_ElMonte + 
            Temperature_Sandburg+I(Temperature_ElMonte^2)+I(Month^2),
          data = Ozone1)
lms1 <- step(lms, direction="both")
summary(lms1)

#get the unsignificant Month out
lms2 <- lm(ozone_reading ~ Humidity + Temperature_ElMonte + 
           I(Temperature_ElMonte^2)+I(Month^2),
          data = Ozone1)
summary(lms2)
plot(lms2)

#add inteaction terms based on lms2
lms2
lmi <- lm( ozone_reading ~  Humidity + Temperature_Sandburg +I(Temperature_ElMonte^2)+ I(Month^2) +  Humidity*Temperature_Sandburg, data = Ozone)
summary(lmi)
#nothing happened when step(), lmi1 and lmi is the same
lmi1 <- step(lmi,direction="both")
summary(lmi1)
plot(lmi1)
#however, this may still not be the best model

# fitting Visibility model
lm1 <- lm(Visibility~Month+Day_of_month+Day_of_week+pressure_height+ozone_reading+Humidity+Temperature_Sandburg+Temperature_ElMonte+Inversion_base_height+Pressure_gradient+Inversion_temperature+Wind_speed, data=Ozone)
#need the above process to get a better fit? you may try....
summary(lm1)



#############
#simple treatment of NA value
#to see which variable have NA value
summary(Ozone)
#repalce NA with mean value, a better way may be regression or interpolation
Ozone[, "pressure_height"][is.na(Ozone[, "pressure_height"])] = mean(Ozone[, "pressure_height"],na.rm=T)
Ozone[, "Humidity"][is.na(Ozone[, "Humidity"])] = mean(Ozone[, "Humidity"],na.rm=T)
Ozone[, "Temperature_Sandburg"][is.na(Ozone[, "Temperature_Sandburg"])] = mean(Ozone[, "Temperature_Sandburg"],na.rm=T)
Ozone[, "Temperature_ElMonte"][is.na(Ozone[, "Temperature_ElMonte"])] = mean(Ozone[, "Temperature_ElMonte"],na.rm=T)
Ozone[, "Inversion_base_height"][is.na(Ozone[, "Inversion_base_height"])] = mean(Ozone[, "Inversion_base_height"],na.rm=T)
Ozone[, "Pressure_gradient"][is.na(Ozone[, "Pressure_gradient"])] = mean(Ozone[, "Pressure_gradient"],na.rm=T)
Ozone[, "Inversion_temperature"][is.na(Ozone[, "Inversion_temperature"])] = mean(Ozone[, "Inversion_temperature"],na.rm=T)

#now we can do forward fitting
lm3 <- step(lm(ozone_reading~1,data=Ozone),scope=ozone_reading~pressure_height+Wind_speed+Humidity+Temperature_Sandburg+Temperature_ElMonte+Inversion_base_height+Pressure_gradient+Inversion_temperature+Visibility, direction="forward")
#but the model may be mislleading and is much worse than backword or both mode
summary(lm3)

