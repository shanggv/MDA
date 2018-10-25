

#code from https://www.statmethods.net/advgraphs/probability.html

# Display the Student's t distributions with various
# degrees of freedom and compare to the normal distribution

x <- seq(-4, 4, length=100)
hx <- dnorm(x)
degf <- c(2, 3, 5, 30)
colors <- c("red", "blue", "darkgreen", "gold", "black")
labels <- c("df=2", "df=3", "df=5", "df=30", "normal")

plot(x, hx, type="l", lty=2, xlab="x value",
     ylab="Density", main="Comparison of t Distributions")
for (i in 1:4){
  lines(x, dt(x,degf[i]), lwd=2, col=colors[i])
}
legend("topright", inset=.05, title="Distributions",
       labels, lwd=2, lty=c(1, 1, 1, 1, 2), col=colors)

########################################################
### statistic tests
#equal to a value
x1 <- c(1:20)

t.test(x1,mu=7)

t.test(x1,mu=8)

# tow samples are equal

set.seed(1)
x1 <- rnorm(30, mean = 896.8, sd = 1780.84)
x2 <- rnorm(20, mean = 726.4, sd = 585.64)
t.test(x1,x2)

#correlation test
set.seed(1)
x1 <- rnorm(200, mean = 896.8, sd = 1780.84)
x2 <- rnorm(200, mean = 726.4, sd = 585.64)
cor.test(x1,x2)

x1 <- 1:10
x2<- 2:11
cor.test(x1,x2)

#variance equal test
#https://www.cnblogs.com/ywliao/p/6724334.html
X<-c(78.1,72.4,76.2,74.3,77.4,78.4,76.0,75.5,76.7,77.3)
Y<-c(79.1,81.0,77.3,79.1,80.0,79.1,79.1,77.3,80.2,82.1)  
var.test(X,Y)


#联立表检验独立性检验(不要求掌握)
#http://www.r-tutor.com/elementary-statistics/goodness-fit/chi-squared-test-independence
chisq.test(X,Y)




####################################################
#distribution test
library(car)
x<-rnorm(x)#random generation for the normal distribution
qqPlot(x)
qqPlot(x,dist="t",df=2)# freedom is so good to meet :)

x<-rchisq(100, df=2) #random generation for the chi-squared (chi^2) distribution
qqPlot(x)
qqPlot(x,dist="chisq",df=3)

set.seed(1)
x<-rnorm(x)#random generation for the normal distribution
shapiro.test(x)

x<-rchisq(100, df=2)
shapiro.test(x)