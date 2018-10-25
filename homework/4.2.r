#question 8
#check the number you typed twice. 
x <- c(401, 468.3, 638.7, 1181.7, 567.5, 862.5, 365.5, 584.1, 585.2, 
       508.8, 598.8, 396.7, 1047, 886.3, 332.6, 446.7, 627.1, 442.9,
       513.6, 525.5, 539.7, 226.1, 685.1, 345.1, 374.3,720.4, 686.8,
       525.7, 460.7, 443.8, 389.9)
?ecdf
t <- ecdf(x)
plot(t)
# take a look at the plot, it is estimate that the 85% rainfall is about 700mm
#but the exact value is get as follows
?quantile
quantile(t,probs=0.85)
#703.6

#question 10
n <- 7+31+26+21+11
rmean <- (0.5*7+ 2.5*31+4.5*26+6.5*21+9*11)/n
rainsd <- ((7*(0.5-rmean)^2+31*(2.5-rmean)^2+26*(4.5-rmean)^2+
             21*(6.5-rmean)^2+11*(9-rmean)^2)/(n-1))^0.5
#2.39017
rancv <- rainsd/rmean
#0.5293109


# a simpler answer with rep(),same results as above
?rep
rain <- c(rep(0.5,times=7),rep(2.5,times=31),rep(4.5,times=26),
          rep(6.5,times=21),rep(9,times=11))
rainsd <- sd(rain)
#2.39017
rancv <- sd(rain)/mean(rain)
#0.5293109

set.seed(1)
rnorm(30, mean = 896.8, sd = 1780.84)

