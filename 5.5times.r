#install.packages("forecast",repos ="https://mirrors.tuna.tsinghua.edu.cn/CRAN/")
library(forecast)

#Average Monthly Temperatures at Nottingham (England), 1920–1939
data(nottem)
nottem
?nottem

#use only the first five years
nottem5 <- subset(nottem,start=1, end =12*5)

# moving average
plot(nottem5 ,type="l")
xf1<-filter(nottem5, rep(1/3,3))
lines(xf1,col="red")


xf2<-filter(nottem5, rep(1/5,5))
lines(xf2,col="green")
?filter

xf3<-filter(nottem5, c(-3/35,12/35,17/35,12/35,-3/35))
lines(xf3,col="blue")

library(forecast)
?ma
#same as xf2
xf4<- ma(nottem5,5)
lines(xf4,col="yellow")


#Average Yearly Temperatures in New Haven (USA)
data(nhtemp)
?nhtemp

#linear regression
nhtempd <- data.frame(t=1912:1971,nhtemp=nhtemp)
plot(nhtempd,type="l")
m1<-lm(nhtemp~t,data=nhtempd)
abline(coef(m1))
summary(m1)
 #多项式
m2<-nls(nhtemp~a*t+b*t^2+c,nhtempd,start=list(a=1,b=1,c=1))
lines(nhtempd$t, predict(m2), col = 2)
summary(m2)

#指数
m3<-nls(nhtemp~a+exp(b*t),nhtempd,start=list(a=1,b=0.01))
lines(nhtempd$t, predict(m3), col = 3)
summary(m3)




#detrend
install.packages("pracma")
library(pracma)
#the following two are equal
lhde <- detrend(as.vector(nhtemp))
lhde2 <- nhtemp-predict(m1)
lhde-lhde2 # near zero
mean(lhde) # near zero

plot(nhtempd,type="l")
abline(coef(m1))

plot(lhde2, col="red")
lines(data.frame(x=1910:1971,y=0))


#Finite difference 差分
xd0 <- nhtemp-mean(nhtemp)
plot( xd0 ,type="l", ylim= c(-5,5))
xd1 <-ts(xd0[-1]-xd0[1:(length(xd0)-1)],frequency=1,start=1912)
lines(xd1,col="red")

xd2 <-ts(xd1[-1]-xd1[1:(length(xd1)-1)],frequency=1,start=1912)
lines(xd2,col="green")

xd3 <-ts(xd2[-1]-xd2[1:(length(xd2)-1)],frequency=1,start=1912)
lines(xd3,col="blue")




#Extracting Seasonality and Trend from Data: Decomposition Using R
#https://anomaly.io/seasonal-trend-decomposition-in-r/
library(bigleaf)
data(AT_Neu_Jul_2010)
?AT_Neu_Jul_2010
tair <- ts(head(AT_Neu_Jul_2010[,5],48*7),frequency = 48,start=182)
plot(tair,type="l")

###################
#power spectrum 功率谱
#install.packages("TSA")
library(TSA)
#wrong!!!
p<-periodogram(tair)
#need to detrend fisrt and then find the periods
trend_air = ma(tair, order =48, centre = T)
detrend_air = tair - trend_air
p<-periodogram(detrend_air[49:(length(tair)-48)])
dd = data.frame(freq=p$freq, spec=p$spec)
#get the stongest two period
order = dd[order(-dd$spec),]
tops = head(order,3)
tops
1/tops[,1]#length of cycle

###########################
#6 steps to decompose time series
#1
data(AT_Neu_Jul_2010)
?AT_Neu_Jul_2010
tair <- ts(head(AT_Neu_Jul_2010[,5],48*7),frequency = 48,start=182)
plot(tair,type="l")

#2
#install.packages("forecast")
library(forecast)
trend_air = ma(tair, order = 48, centre = T)
plot(tair)
lines(trend_air)
plot(trend_air)

#3
detrend_air = tair - trend_air
plot(as.ts(detrend_air))



#4
m_air = t(matrix(data = detrend_air, nrow = 48))
seasonal_air = colMeans(m_air, na.rm = T)
plot(as.ts(rep(seasonal_air,7)))


#5
random_air = tair - trend_air - seasonal_air
plot(as.ts(random_air))

#6
recomposed_air = trend_air+seasonal_air+random_air
plot(as.ts(recomposed_air))


#decompose 
ts_air = ts(tair, frequency = 48)
decompose_air = decompose(ts_air, "additive")
plot(decompose_air)


ts_air = ts(tair, frequency = 48)
stl_air = stl(ts_air, "periodic")
plot(stl_air)

seasonal_stl_air   <- stl_air$time.series[,1]
trend_stl_air     <- stl_air$time.series[,2]
random_stl_air  <- stl_air$time.series[,3]
plot(ts_air)
plot(as.ts(seasonal_stl_air))
plot(trend_stl_air)
plot(random_stl_air)


#decompose again
decompose_air2 = decompose(random_stl_air, "additive")
plot(decompose_air2)

#autoregression
#default: method=“yule-walker”
a1<-ar(tair)
a1
#只有使用最小二乘法,即method = "ols"进行参数估计的时候，才会有截距。
a2<-ar(tair,method = "ols")
a2



tsp<-predict(a1,n.ahead=500)
plot(tair)
plot(tair,xlim=c(182,200),ylim=c(0,30))
lines(tsp$pred,col='red')  
lines(tsp$pred+2*tsp$se,col='blue')
lines(tsp$pred-2*tsp$se,col='blue')


tsp<-predict(a2,n.ahead=500)
plot(tair)
plot(tair,xlim=c(182,200),ylim=c(0,30))
lines(tsp$pred,col='red')  
lines(tsp$pred+2*tsp$se,col='blue')
lines(tsp$pred-2*tsp$se,col='blue')




#######################################
#the following code is optional
#decompose seasonal components one by one,
?lh
lhde <- detrend(as.vector(lh))

# find the strongest seasonal components
p <- periodogram(lhde)
dd = data.frame(freq=p$freq, spec=p$spec)
order = dd[order(-dd$spec),]
tops = head(order,2)
tops
1/tops

#decompose the first period
ts_lh = ts(lh, frequency = 8)
stl_lh = stl(ts_lh, "periodic")
plot(stl_lh)


#the second period
lh2 <- stl_lh$time.series[,3] # the noise left in the fisrt decompose
plot(lh2)
var(lh2)/var(lh)

p <- periodogram(lh2)
dd = data.frame(freq=p$freq, spec=p$spec)
order = dd[order(-dd$spec),]
tops = head(order,2)
tops
1/tops

ts_lh2 = ts(lh2, frequency = 6)
stl_lh2 = stl(ts_lh2, "periodic")
plot(stl_lh2)

#third period
lh3 <- stl_lh2$time.series[,3]
plot(lh3)
var(lh3)/var(lh)

p <- periodogram(lh3)
dd = data.frame(freq=p$freq, spec=p$spec)
order = dd[order(-dd$spec),]
tops = head(order,2)
tops
1/tops

ts_lh3 = ts(lh3, frequency = 5.333)
stl_lh3 = stl(ts_lh3, "periodic")
plot(stl_lh3)

#fourth period
lh4 <- stl_lh3$time.series[,3]
plot(lh4)
var(lh4)/var(lh)

p <- periodogram(lh4)
dd = data.frame(freq=p$freq, spec=p$spec)
order = dd[order(-dd$spec),]
tops = head(order,2)
tops
1/tops

ts_lh4 = ts(lh4, frequency = 4.36)
stl_lh4 = stl(ts_lh4, "periodic")
plot(stl_lh4)

#fifth period
lh5 <- stl_lh4$time.series[,3]
plot(lh5)
var(lh5)/var(lh)

