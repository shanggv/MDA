library(forecast)
?nhtemp
data(nhtemp)


#spectral anlysis
#need to detrend fisrt and then find the periods
library(pracma)
detrend_air = detrend(as.vector(nhtemp))
detrend_air = as.ts(detrend_air, start=...)
plot(detrend_air)
p<-periodogram(...)
dd = data.frame(...)
#get the stongest two period
order = dd[order(-dd$spec),]
tops = head(order,4)
tops
1/tops[,1]#length of cycle


#decompose the first cycle
ts_air = ts(nhtemp, frequency = ...)
#method 1
decompose_air = decompose(...)
plot(decompose_air)
#method2
stl_air = stl(.__C__.externalptr)
plot(stl_air)


#get values of components
seasonal_stl_air   <- stl_air$time.series[,1]
trend_stl_air     <- stl_air$time.series[,2]
random_stl_air  <- stl_air$time.series[,3]
plot(ts_air)
plot(as.ts(seasonal_stl_air))
plot(trend_stl_air)
plot(random_stl_air)




#autoregression
...



tsp<-predict(...)
plot(nhtemp)
plot(nhtemp,xlim=c(...))
lines(tsp$pred,col='red')  
lines(tsp$pred+2*tsp$se,col='blue')
lines(tsp$pred-2*tsp$se,col='blue')
