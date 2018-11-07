# linear regression
#install.packages("bigleaf",repos ="https://mirrors.tuna.tsinghua.edu.cn/CRAN/")
library(bigleaf)
#Halfhourly eddy covariance Data of the site AT-Neu, a mountain meadow in Austria from bigleaf
data(AT_Neu_Jul_2010)
?AT_Neu_Jul_2010
at <- AT_Neu_Jul_2010
plot(at[,5],type="l")
#plot(at[,c("hour","Tair","pressure","VPD","ustar", "wind","Ca")])
#plot(at[,c("LW_up","Rn","LE", "H", "G","Tair")])


t <- lm(Rn~LE, at)
plot(at[,c("LE","Rn")])
abline(coef(t))
summary.lm(t)

#Regression diagnostic
plot(t)
library(car)
qqPlot(t)

# add a quadratic term
t2<- lm(Rn~LE+I(LE^2),at)
summary(t2)
plot(t2)



#https://www.tutorialspoint.com/r/r_multiple_regression.htm
input <- at[,c("Rn","Tair","VPD","pressure","precip", "wind")]
print(head(input))
# Create the relationship model.VPD is 蒸气压差
model <- lm(Rn~Tair+VPD+pressure+precip+wind, data = input)
# Show the model.
print(model)
summary.lm(model)
plot(model)

model2 <- lm(Rn~Tair+VPD+pressure+wind, data = input)
summary.lm(model2)
plot(model2)


p <- predict.lm(model2,input,se.fit=T)
plot(input[,"Rn"],p$fit)
abline(a=0,b=1)
?predict.lm

i <- predict.lm(model2,input, interval="confidence")
i
methods(predict)


 #stepwise regression
#delete records with NA to avoid error for step()
#stepwise regression
#mileage per gallon (mpg), cylinder displacement排气量("disp"), horse power("hp"), weight of the car("wt")，Rear axle ratio后桥比("drat") ,1/4 mile time 起步时间(qsec)

model3 <- lm(mpg~disp+hp+wt+drat+qsec,data=mtcars)

step(model3,direction="backward")#逐步剔除方案
step(lm(mpg~1,data=mtcars),scope=mpg~disp+hp+wt+drat+qsec,direction="forward")#逐步引进方案
step(model3,direction="both")#双重检验
model4 <- step(lm(mpg~1,data=mtcars),scope=mpg~disp+hp+wt+drat+qsec,direction="both")#双重检验
summary(model4)


#best subsets regression
install.packages("leaps")
library(leaps)
  subset.full <- regsubsets (mpg ~ disp+hp+wt+drat+qsec , data=mtcars, nvmax = 5)
full.summary <- summary ( subset.full )
names ( full.summary )
full.summary
which.max ( full.summary $ cp )
which.min ( full.summary $ bic )
which.max ( full.summary $ adjr2 )
which.max ( full.summary $ rss)
which.max ( full.summary $ rsq )

plot ( full.summary $ bic , xlab = "Number of Variables" , ylab = "BIC" , type =     "b" )
points ( 2 , full.summary $ bic [ 2 ] , col = "red" , cex = 2 , pch = 20 )






#step(lm(Fertility~1,data=swiss),scope=Fertility ~ Agriculture + Examination + Education + Catholic + Infant.Mortality, direction="both")

( npk.aov <- aov(yield ~ block + N*P*K, npk) )

npk.lm <- lm(yield ~ block + N*P*K, npk)

summary(npk.aov)
summary(npk.lm)
aov(npk.lm)

coefficients(npk.lm)
coefficients(npk.aov)

