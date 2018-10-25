###########
### A brief introduction to R - v.1.1
# Wei Shangguan, SYSU
# NOTE: R is case-sensitive!


### Loading packages, getting help, saving (NOT IN THE TUTORIAL)
#############################################################################################

# set the working directory
# example only; the code below will not work on your computer unless you have a similar folder structure

setwd("D:/working/teaching/气象数据分析与应用/code") # use one forward slash
setwd("D:\\working\\teaching\\气象数据分析与应用\\code") # use double back slashes

# adapt the file path below so that it points to the folder that contains the 'Guided Self Study'materials 
setwd("...") # REPLACE THE DOTS WITH THE FILE PATH



# check which packages are installed in the system
library()

# install gstat and sp package (NOT IN TUTORIAL)
#install.packages("gstat", repos ="https://mirrors.tuna.tsinghua.edu.cn/CRAN/")

# alternatively use Rstudio: Tools -> Install packages

# lookup functions included in a package
library(help=gstat)

# load a package; ignore possible warning messages
require(gstat) # or library(gstat)

# data and function
d <- 10
d == 10
sq <- function(x){x*x}
sq(d)

#save objects
save.image("./data/try.rda")
save(d,file="./data/d.rda")

#get help
?save
??save
help.start()
RSiteSearch("save")


## Basic (atomic) data types


## Numerical
x <- 5.1
x
class(x)

## Numerical
x <- as.integer(5.1)
x
class(x)


## Logical
x <- T
z <- 1>2
x
class(x)
class(z)

## Character
z <- "Wei"
z
class(z)

#vector
wt <- c("rainny","sunny","cloudy","cloudy")
wt
class(wt)

#factor
wt.f <- as.factor(wt)
wt.f
class(wt.f)
levels(wt.f)
summary(wt.f)

#vectors
c(5.2, 1.7, 6.3)
c("rainny","sunny","cloudy","cloudy")

a <- c(5.2, 1.7, 6.3)
b <- c("rainny","sunny","cloudy","cloudy")
z <- c(a,b)
z
class(z)
length(z)

a <- c(1,2,3)
b <- c(4,5,6)
5*a
a+b

a <- c(1,2,3)
b <- c(4,5,6,7,8)
a+b
a-mean(a)

#data frame
library(climwin)
data("MassClimate")
str(MassClimate)
climate10 <- MassClimate[1:10,]

#selecting data
a
a[1]
a[-1]
a[c(1,3)]

climate10[1,]
climate10[2:5,]
climate10[,3]
climate10[1,3]
climate10$Rain
climate10[,"Rain"]


#function
sqrt(25)
#linear regression
t <- lm(Rain~Temp, data=MassClimate)


#import data
d <- read.csv("E:\\data\\气候\\广东站点\\gd_obs.csv")
str(d)
write.table(d[1:10,], file="E:\\data\\气候\\广东站点\\tmp.txt", sep = "\t")


#plot
d1 <- d[d$STACODE==57988,]
d1[d1 == -9999] <- NA
plot(d1$T,d1$F10S)
plot(d1$T,d1$F10S, xlab = "Temperature", ylab = "Wind Speed at 10 m", 
     main = "relation T and V", pch = 2, col = "blue")

#ggplots
library(ggplot2)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")+
  geom_smooth(mapping = aes(x = displ, y = hwy))


#save plot
png("scatterplot1.png",width=550, height=500)
plot(d1$T,d1$F10S, xlab = "Temperature", ylab = "Wind Speed at 10 m", 
     main = "relation T and V", pch = 2, col = "blue")
dev.off()

scatter <- ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

png("scatterplot2.png",width=550, height=500)
scatter
dev.off()

jpeg("scatterplot2.jpg",width=550, height=500)
scatter
dev.off()

pdf("scatterplot2.pdf")
scatter
dev.off()


#spatial data
s <- read.csv("E:\\data\\气候\\广东站点\\gd_site.csv")
str(s)
head(s)


#netcdf
library(RNetCDF)
library(raster)
#library(ncdf4)
setwd("D:\\working\\teaching\\气象数据分析与应用\\code\\data\\zhu")
pm <- open.nc("precip.mon.mean.nc")
print.nc(pm)

#2018.7
pm1 <- var.get.nc(pm,"precip", start =c(1,1,475), count=c(144,72,1))
r1 <- raster(nrows=72,ncols=144,xmn=-180,xmx=180,ymn = -90, ymx = 90)
values(r1) <- as.vector(pm1)
str(r1,2)
str(r1)
plot(r1)

#spplot
spplot(r1)
hist(r1,breaks=40)
hist(log(r1))
ramp =c(0,2,4,6,8,10,15,20,50)
spplot(r1, at = ramp, col.regions = rev(get_col_regions()),
       main="Mothly precipitation of July, 2018", scales = list(draw = TRUE))


#2018.1, not in  ppt
pm2 <- var.get.nc(pm,"precip", start =c(1,1,469), count=c(144,72,1))
r2 <- raster(nrows=72,ncols=144,xmn=-180,xmx=180,ymn = -90, ymx = 90)
values(r2) <- as.vector(pm2)
plot(r2)
s1 <- stack(r1,r2)
spplot(s1)
#get dimensions, not in ppt
time <- var.get.nc(pm,"time")
year <-1979+ floor((1:length(time)-1)/12)
month <- (1:length(time)-1)%%12+1
lat <- var.get.nc(pm,"lat")
range(lat)
lon <- var.get.nc(pm,"lon")
range(lon)

#geotiff
setwd("D:\\working\\teaching\\气象数据分析与应用\\code\\data\\albedo")
ab <- raster("RenderData.tiff")
values(ab)[values(ab)== 99999 ] <- NA
spplot(ab)

#grib
#library("rNOMADS")
#?ReadGrib
#fname <- "_mars-atls13-98f536083ae965b31b0d04811be6f4c6-9qkKLB.grib"
#ReadGrib(fname)
