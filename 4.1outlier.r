#see the web for explaination
#https://www.r-bloggers.com/outlier-detection-and-treatment-with-r/
#outlier detection and treatment


setwd("D:/working/teaching/气象数据分析与应用/code") # use one forward slash

# Inject outliers into data.
cars1 <- cars[1:30, ]  # original data
cars_outliers <- data.frame(speed=c(19,19,20,20,20), dist=c(190, 186, 210, 220, 218))  # introduce outliers.
cars2 <- rbind(cars1, cars_outliers)  # data with outliers.

# Plot of data with outliers.
par(mfrow=c(1, 2))
plot(cars2$speed, cars2$dist, xlim=c(0, 28), ylim=c(0, 230), main="With Outliers", xlab="speed", ylab="dist", pch="*", col="red", cex=2)
abline(lm(dist ~ speed, data=cars2), col="blue", lwd=3, lty=2)

# Plot of original data without outliers. Note the change in slope (angle) of best fit line.
plot(cars1$speed, cars1$dist, xlim=c(0, 28), ylim=c(0, 230), main="Outliers removed \n A much better fit!", xlab="speed", ylab="dist", pch="*", col="red", cex=2)
abline(lm(dist ~ speed, data=cars1), col="blue", lwd=3, lty=2)

dev.off()


#Univariate approach
outlier_values <- boxplot.stats(cars2$dist)$out  # outlier values.
boxplot(cars2$dist, main="distance", boxwex=0.1)
mtext(paste("Outliers: ", paste(outlier_values, collapse=", ")), cex=0.6)



#Bivariate approach
#url <- "http://rstatistics.net/wp-content/uploads/2015/09/ozone.csv"
#ozone <- read.csv(url)    # not good speed to read from webstie. Download it instead
ozone <- read.csv("./data/ozone.csv")

# For categorical variable
boxplot(ozone_reading ~ Month, data=ozone, main="Ozone reading across months")  # clear pattern is noticeable.
boxplot(ozone_reading ~ Day_of_week, data=ozone, main="Ozone reading for days of week")  # this may not be significant, as day of week variable is a subset of the month var.

# For continuous variable (convert to categorical if needed.)
boxplot(ozone_reading ~ pressure_height, data=ozone, main="Boxplot for Pressure height (continuos var) vs Ozone")
boxplot(ozone_reading ~ cut(pressure_height, pretty(pressure_height)), data=ozone, main="Boxplot for Pressure height (categorial) vs Ozone", cex.axis=0.5)

#Cook’s Distance
mod <- lm(ozone_reading ~ ., data=ozone)
cooksd <- cooks.distance(mod)
plot(cooksd, pch="*", cex=2, main="Influential Obs by Cooks distance")  # plot cook's distance
abline(h = 4*mean(cooksd, na.rm=T), col="red")  # add cutoff line
text(x=1:length(cooksd)+1, y=cooksd, labels=ifelse(cooksd>4*mean(cooksd, na.rm=T),names(cooksd),""), col="red")  # add labels

#Outliers Test
library(car)
car::outlierTest(mod)

#Outliers package
library(outliers)
set.seed(1234)
y=rnorm(100)
outlier(y)
outlier(y,opposite=TRUE)

dim(y) <- c(20,5)  # convert it to a matrix
outlier(y)
outlier(y,opposite=TRUE)



set.seed(1234)
x = rnorm(10)
scores(x)  # z-scores => (x-mean)/sd
scores(x, type="chisq")  # chi-sq scores => (x - mean(x))^2/var(x)
scores(x, type="t")
scores(x, type="chisq", prob=0.9)  # beyond 90th %ile based on chi-sq
scores(x, type="chisq", prob=0.95)  # beyond 95th %ile
scores(x, type="z", prob=0.95)  # beyond 95th %ile based on z-scores
scores(x, type="t", prob=0.95)  # beyond 95th %ile based on t-scores
