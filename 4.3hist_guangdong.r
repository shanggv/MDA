setwd("E:\\data\\气候\\广东站点")
obs <- read.csv("gd_obs.csv")
obs[obs==-9999]<- NA

mode1 <- function(x)
  
{
  x<-round(x)
  
  return(as.numeric(names(table(x))[table(x) == max(table(x))]))
  
}
mode2 <- function(x)
  
{
  return(as.numeric(names(table(x))[table(x) == max(table(x))]))

}



hist(obs[,4], breaks = 90, freq=F,main=NULL,xlab="Wind speed at 10m",xlim=quantile(obs[,4],probs=c(0,0.99),na.rm=T))
summary(obs[,4])
mode1(obs[,4])
mode2(obs[,4])

hist(obs[,5], breaks = 30, freq=F,main=NULL,xlab="Temperature",xlim=quantile(obs[,5],probs=c(0,0.99),na.rm=T))
summary(obs[,5])
mode1(obs[,5])
mode2(obs[,5])

hist(obs[,6], breaks = 200, freq=F,main=NULL,xlab="Precipitation",xlim=quantile(obs[,6],probs=c(0,0.99),na.rm=T))

summary(obs[,6])
mode1(obs[,6])
mode2(obs[,6])


#no 0 P
pn0<-obs[,6]
pn0[pn0==0] <- NA
hist(pn0, breaks = 100, freq=F,main=NULL,xlab="Precipitation",xlim=quantile(pn0,probs=c(0,0.99),na.rm=T))

summary(pn0)
mode1(pn0)
mode2(pn0)



pn1<-pn0^(1/3)

hist(pn1, breaks = 100, freq=F,main=NULL,xlab="Precipitation",xlim=quantile(pn0,probs=c(0,0.99),na.rm=T))

t<-obs[obs$STACODE==57988,c(3,5)][1:30,]
plot(1:30,t[,2],ylim=c(-10,12))
t2<-t[2:30,2]-t[1:29,2]
lines(2:30,t2)
