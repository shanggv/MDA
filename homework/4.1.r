#####################################
# question 2
#make a vector
v1 <-  c(1150,982,1211,1142,1192,1129,1264,1265,1165,1335,1257,1464)

#method1, roughly a 95% confidence
boxplot.stats(v1)$out
#1464

#method2
#install.packages("outliers", repos ="https://mirrors.tuna.tsinghua.edu.cn/CRAN/")
library(outliers)
?outlier
outlier(v1)
#1464

#method3
#¡°z¡±, ¡°t¡±, ¡°chisq¡±, "iqr"
library(outliers)
v1
#at 0.05 level
scores(v1,prob= 0.95)
#FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
#the result is number 2 (982) and number 12(1464)

#at 0.01 level
scores(v1,prob= 0.99)
# FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#the result is none

#method 4, follow the textbook, not shown
#......


#################################################
# question 4
a <- c(10.7,10.9,11.2,11.3,11.1,11.0,11.2,11.6,11.4,10.8,
       11.2,11.9,10.4,11.3,11.7,12,11.7,11.8,11.9,20.2)
b <- c(14.9,14.6,14.9,15.1,14.9,14.8,14.5,14.1,15.1,14.1)
ma <- mean(a[1:10])
mb <- mean(b)
#difference method
k <-1
b2 <- mb+k*(a[11:20]-ma)
b2
bout <- c(b,b2)
mean(b2)


#ratio method
k <- mb/ma
b2 <- mb+k*(a[11:20]-ma)
b2
bout <- c(b,b2)
mean(b2)


#wild method
k <- sd(b)/sd(a[1:10])
b2 <- mb+k*(a[11:20]-ma)
b2
bout <- c(b,b2)
mean(b2)

