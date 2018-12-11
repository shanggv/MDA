library(forecast)
?nhtemp
data(nhtemp)


#spectral anlysis
#need to detrend fisrt and then find the periods
library(pracma)
library(TSA)
detrend_air = detrend(as.vector(nhtemp))
detrend_air = as.ts(detrend_air, start=1912)
plot(detrend_air)
p<-periodogram(detrend_air)
dd = data.frame(freq=p$freq, spec=p$spec)
#get the stongest two period
order = dd[order(-dd$spec),]
tops = head(order,4)
tops
1/tops[,1]#length of cycle


#decompose the first cycle, i.e, frequency = 20
ts_air = ts(nhtemp, frequency = 20)
#method 1
decompose_air = decompose(ts_air, "additive")
plot(decompose_air)
#method2
stl_air = stl(ts_air, "periodic")
plot(stl_air)
#method3: step by step ....

#get values of components
seasonal_stl_air   <- stl_air$time.series[,1]
trend_stl_air     <- stl_air$time.series[,2]
random_stl_air  <- stl_air$time.series[,3]
plot(ts_air)
plot(as.ts(seasonal_stl_air))
plot(trend_stl_air)
plot(random_stl_air)




#autoregression
#default: method=“yule-walker”
a1<-ar(nhtemp)
a1
#只有使用最小二乘法,即method = "ols"进行参数估计的时候，才会有截距。
a2<-ar(nhtemp,method = "ols")
a2
#mehtod ="mle"
a3<-ar(nhtemp,method = "mle")
a3
#mehtod ="yw"
a4<-ar(nhtemp,method = "yw")
a4

#mehtod ="burg"
a5<-ar(nhtemp,method = "burg")
a5

#a2 has the best sigma^2 estimated as  0.9746

tsp<-predict(a2,n.ahead=28)
plot(nhtemp)
plot(nhtemp,xlim=c(1910,2000))
lines(tsp$pred,col='red')  
lines(tsp$pred+2*tsp$se,col='blue')
lines(tsp$pred-2*tsp$se,col='blue')
