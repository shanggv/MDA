a <- c(116,156,181,128,237,257,321,386,379,411,
       420,389,399,425,471,504,509,497,493,498)
b <- c(122,171,169,159,306,262,279,347,335,371,
       402,377,346,364,419,499,445,454,449,432)

#显著差异
t.test(a,b)
#p value >0.05, so true difference in means is 0

#相关关系
cor.test(a,b)
#p value <0.05, so true correlation is not equal to 0

#方差相等检验
var.test(a,b)
#p value >0.05, so true ratio of variances is equal to 1

#是否符合正态
#method 1
?shapiro.test
shapiro.test(a)
#p value <0.1, so a is not a normal distribution
shapiro.test(b)
#p value >0.1, so b is a normal distribution

#method 2
library(car)
qqPlot(a)
#all points are within the confidence envelope, so a is a normal distribution
qqPlot(b)
#all points are within the confidence envelope except that one point is nearly out of it, so b is nearly a normal distribution

