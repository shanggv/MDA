#############################################################################################
### A brief introduction to R - v.1.3
### Dr. B. Kempen, ISRIC - World Soil Information
### May 6, 2016
### Based on: 
###   Introduction to the R Project for Statistical Computing for use at ITC 
###   by Dr. David G. Rossiter (http://www.css.cornell.edu/faculty/dgr2/)
#############################################################################################


# NOTE: R is case-sensitive!


### Loading packages, getting help, saving (NOT IN THE TUTORIAL)
#############################################################################################

# set the working directory
# example only; the code below will not work on your computer unless you have a similar folder structure

setwd("D:/SpringSchool/Workingdir") # use one forward slash
setwd("D:\\SpringSchool\\Workingdir") # use double back slashes

# adapt the file path below so that it points to the folder that contains the 'Guided Self Study'materials 
setwd("D:/ISRIC/Training/SpringSchool/Introduction_to_R/RIntro") # REPLACE THE DOTS WITH THE FILE PATH



### 3 R console GUI
### 3.2 Working with the R command line
#############################################################################################

# Enter the code in section 3.2 manually using in the R command line to practice
# Use Rstudio for this (first read section 3.3)


### 3.5 Working with the R command line (p.14)
#############################################################################################

# Prepare an R script following the instructions in the tutorial.


### 3.7 Loading optional packages (p.17)
#############################################################################################

# check which packages are installed in the system
library()

# install gstat and sp package (NOT IN TUTORIAL)
install.packages("gstat")
install.packages("sp")
# alternatively use Rstudio: Tools -> Install packages

# lookup functions included in a package
library(help=gstat)

# load a package; ignore possible warning messages
require(gstat) # or library(gstat)

# getting help on a function (in this case the function 'variogram')
?variogram

### EXERCISE ###
# Load the sp package and get help on function spplot 


### 3.8 Sample data sets (p.18)
#############################################################################################

# see list of installed datasets
data()

# see datasets in single add-in package (here gstat)
data(package="gstat")

# load a dataset
data(iris)


### EXERCISE ###
# Check which datasets are included in the sp package.
# Load the 'meuse' dataset that is included in the sp package.
# Use the 'str'function to display the structure of the meuse dataset.
# How many rows and columns does the meuse data set have?



### 4 The S language
### 4.1 Command-line calculator and mathematical operators (p. 19)
#############################################################################################

# use R as a calculator
2*pi/360

3 / 2^2 + 2 * pi

((3 / 2)^2 + 2) * pi

log(10); log10(10); log2(10)

round(log(10))

sqrt(5)

sin(45 * (pi/180))

(asin(1)/pi)*180


### EXERCISE ###
# Compute the volume of a sphere with radius 5: 
# the volume of a sphere is 4/3 times pi times the radius to the third power


### 4.2 Creating new objects: the assignment operator (p. 20)
#############################################################################################

# use the assignment operator
mu <- 180 

mu = 180 # in R it is preferred to use <- instead of =

# print to the console
print(mu)

# or even easier:
mu

# using an object in an expression
mu/pi

# create a more complex object
s <- seq(10) # creates a vector sequence of numbers with length 10
s

# multiple assignments in the same expression
(mu <- theta <- pi/2) 
# note that theta is now added to the workspace, the value of theta is assigned to mu

# remove object from the workspace
rm(s)


### 4.3 Methods and their arguments (p. 21)
#############################################################################################

# show objects in workspace
ls()


# optional arguments
s <- seq(from = 20, to = 0, by = -2)
s


# arguments are positional and the command separator (;)
s <- seq(20, 0, by=-2); s


### EXERCISE ###
# Create object 's1'that stores a sequence from 2000 to 2050 with an increment of 5.


# use parentheses to display the object
(s <- seq(from=20, to=0, by=-2))


# named arguments give flexibility, these can be used in any order
(s <- seq(to=0, from=20, by=-2))


# online help on function seq
? seq

# accessig vector elements using []
# Note that the tutorial uses the object 'samp'
# 'samp', however, does not exist (check your workspace)
# So here we use object 's'
s[1]

s[1:3] # ':' is the sequence operator

s[c(1,10)] # c is the catenate function; it makes a chain, in this case a vector storing the numbers 1 and 10

s[c(1:3,10)] # NOT IN TUTORIAL


### 4.4 Vectorized operations and re-cycling (p. 22)
#############################################################################################

# arithmetic operations on vectors (NOT IN TUTORIAL)
s*10 # multiply with scalar

s*s # multiply with itself

s+s # sum

s%*%s # inner product


# generate a sequence (note that the output differs from the numbers in the tutorial). Do you know why?
(sample <- seq(1, 10) + rnorm(10)) # rnorm simulates from the normal distribution; here it simulates 10 numbers


# the 5 randomly generated numbers are re-cycled (used twice)
(samp <- seq(1, 10) + rnorm(5)) # output differs from output in tutorial


#  re-cycling of vector elements
(sample <- seq(1:8))
(sample - mean(sample)) 
# subtracts a scalar (the mean) from each vector element; the scalar is 're-cycled'

# compute the variance
(sample - mean(sample))^2 # squared errors

sum((sample - mean(sample))^2) # sum of squared errors

sum((sample - mean(sample))^2)/(length(sample)-1) # this is the variance of the sample

# or way easier use the var function
var(sample)


# explore the 'sort' and 'rank' functions using the 'trees' dataset
data(trees)

# inspect (NOT IN TUTORIAL)
str(trees)

# access the Volume attribute (column)
trees$Volume

sort(trees$Volume)

rank(trees$Volume)


### EXERCISE ###
# Compute the mean and variance of the tree volume and tree height



### 4.5 Vector and list data structures (p. 24)
#############################################################################################

# sorting a vector
ss <- sort(samp, index=TRUE)

str(ss) # str displays the object data structure; output differs from tutorial


# access list objects using [[]] (NOT IN TUTORIAL)
length(ss) # gives the number of objects in the list
ss[[1]] # first object in list
ss[[2]] # second object in list


# instead, one can display just one element by:
ss$ix # the $ operator is used to access components of lists or data.frames


# combine this with the vector indexing operation:
ss$ix[length(ss$ix)] 
# largest value in the sample sequence is found in the ninth position 
# note that this can also be the tenth depending on the numbers in the samp object
# this is an example of an expression containing another expression


# get the actual value of this maximum from the samp object
samp[ss$ix[length(ss$ix)]] # output may differ from tutorial


### 4.6 Arrays and matrices (p. 25)
#############################################################################################

# generate a numeric vector
cm <- c(35,14,11,1,4,11,3,0,12,9,38,4,2,5,12,2)
cm

# display vector dimensions
dim(cm)

# add dimensions (make 4x4 matrix)
dim(cm) <- c(4, 4)
cm

# access matrix element (NOT IN TUTORIAL)
cm[3,4]

# get the matrix dimensions
dim(cm)

# get the matrix attributes
attributes(cm)  # all attributes
attr(cm, "dim") # one specific attribute


# transpose a matrix
cm <- t(cm)
cm


# create a matrix with the matrix function
(m <- matrix(data = 0, nrow = 5, ncol = 3))


# data argument may also be a vector (in this case a sequence of 1 to 15)
(m <- matrix(1:15, 5, 3, byrow = T))

# the 1:5 vector is recycled (used to fill each column)
(m <- matrix(1:5, 5, 3))


# col function
col(m)


# retrieve the matrix diagonal
(d <- diag(cm))


# create a matrix from a vector that is created with the seq function
(d <- diag(seq(1:4)))


# a matrix can also be created from a scalar argument
(d <- diag(3))


# arithmetic operations on matrices
cm*cm # multiply with the matrix elements

cm+10 # add scalar (NOT IN TUTORIAL)

cm*10 # multiply with scalar (NOT IN TUTORIAL)

cm%*%cm # matrix multiplication

cm%*%c(1,2,3,4) # multiplying matix with a vector


### EXERCISE ###
# Create an empty 3 by 4 matrix (3 rows, 4 columns). Name the matrix object 'cm1'
# Assign '1' to the element of the first row and first column 


# NOTE: script for the more advanced matrix inversion, solving linear equations, 
# apply and scale functions not included in this script (p. 28,29,30)


# The 'apply' function applies a function to the rows or columns of a matrix (p. 29)
?apply # NOT IN TUTORIAL
(rsum <- apply(X = cm, MARGIN = 1, FUN = sum))
(csum <- apply(X = cm, MARGIN = 2, FUN = sum))
# MARGIN = 1 applies the function to rows, MARGIN = 2 to columns

(rsum <- apply(X = cm, MARGIN = 1, FUN = sum))

### EXERCISE ###
# Compute the mean of the rows of matrix 'cm' using the apply function


### 4.7 Data frames (p. 30)
#############################################################################################

# load data.frame
?trees # retrieve information on the tree dataset

data(trees) # load the trees dataset

str(trees) # inspect the structure


# with the 'names' function the names of the attributes of a dataframe can be retrieved
(saved.names <- names(trees))

# with the 'paste' function we can build names; try to understand how the function works 
(names(trees) <- paste("Var", 1:dim(trees)[2], sep = ".")) # pastes vectors

# name the first attribute of the 'trees' dataframe 'Perimeter'
names(trees)[1] <- "Perimeter"

# check the new attribute names
names(trees)

# assign the names stored in object saved.names to the 'trees' dataframe
(names(trees) <- saved.names)

# objects can be removed from the workspace using the 'rm' function
rm(saved.names)


# accessing data.frames
trees$Height 
# the $ operator can be used to selected a named field (column) from the dataframe

# select the first five elements of the 'height' attribute
trees$Height[1:5]

# double brackets are used to access columns (here the second)
trees[[2]]

# access first five elements of second column
trees[[2]][1:5]

# select by row (here the first row)
trees[1,]

# ... then by column
trees[,2]

# get one element (first row, second column)
trees[1,2]

# alternatively, attribute names can be used directly for selection
trees[,"Height"] #(NOT IN TUTORIAL)

# select Height from first row
trees[1,"Height"]

# or alternatively 
trees[1,]$Height

# display top 6 rows (NOT IN TUTORIAL)
head(trees)

# bottom 6 rows (NOT IN TUTORIAL)
tail(trees)


## attaching dataframes to the search path (p. 32)
attach(trees)

# now the attributes can be accessed directly, so without writing trees$
Height[1:5]

# 'detach' cancels the attach function (NOT IN TUTORIAL)
detach(trees)
Height[1:5] # returns an error; Height is not not available anymore in the memory


## building a data frame (p. 32)
# generate three attributes (use the help to find out what the rep function does)
x <- rep(seq(182,183, length = 5), 2)*1000 # rep generates a repeated sequence
y <- rep(c(381000, 310300), 5)
n.trees <- c(10, 12, 22, 4, 12, 15, 7, 18, 2, 16)

# build data frame with the 'data.frame' function
(ds <- data.frame(x, y, n.trees))


## adding rows to a data frame (p. 33)
# using rbind function
(ds <- rbind(ds, c(183500, 381000, 15)))


# this can also be done as follows:
ds[12,] <- c(183400, 381200, 18)
ds

# clean up the workspace (NOT IN TUTORIAL)
rm(x,y,n.trees)


## adding a fields to a dataframe (p. 33) 
attach(trees)

# compute new attribute: height/girth ratio
HG.Ratio <- Height/Girth

# append new attribute to dataframe
trees <- cbind(trees, HG.Ratio) 

# display dataframe structure
str(trees)

# clean up
rm(HG.Ratio)


# summary statistics. This gives an error because height/girth is not visible
summary(HG.Ratio)

# detach and attach to make HG.ratio available in the memory
detach(trees) ; attach(trees)

# now HG.Ratio can be displayed
summary(HG.Ratio)
detach(trees)


## sorting a data.frame (p. 33)
trees[order(trees$Height, trees$Girth),]


### EXERCISE ###
# Select the field 'Volume' from trees
# Change the name of the second field to 'Size'
# Access the value of the 10th row and 2nd column


### 4.8 Factors (p. 34)
#############################################################################################

# create a new data frame with student scores
student <- rep(1:3, 3)
score <- c(9, 6.5, 8, 8, 7.5, 6, 9.5, 8, 7)
tests <- data.frame(cbind(student, score))
str(tests)

# clean up the workspace (NOT IN TUTORIAL)
rm(student,score)


# using a simple linear model to predict the scrore from the student produces nonsense
lm(score ~ student, data = tests) # lm fits a linear regression model


# to get more logical resutls, student has to be converted to factor
tests$student <- as.factor(tests$student)
str(tests)

# display the factor levels (NOT IN TUTORIAL)
levels(tests$student)

# compute scores from the student
lm(score ~ student, data = tests)


# assigning factor names
tests$student <- factor(tests$student, labels = c("Harley", "Doyle", "JD"))
str(tests)

# tabulate
table(tests)


# recoding factor levels
tests$student <- factor(tests$student, labels=c("John", "Paul", "George"))
str(tests)

# tabular format
table(tests)


# ordering factor levels with the 'levels' function
tests$student <- factor(tests$student, levels=levels(tests$student)[c(3,1,2)])
str(tests)
table(tests)


### EXERCISE ###
# Change the factor levels of attribute 'students' in object 'test' to Gerard, Tom, Bas


### 4.9 Selecting subsets (p. 36)
#############################################################################################

data(trees)

## selecting known elements
# first three rows
trees[1:3,]

# rows 1, 3 and 5
trees[c(1, 3, 5),]

# subset rows based on a sequence
trees[seq(1, 31, by = 10),]


# the minus sign can be used to exclude rows
trees[-(1:27),] 


## selecting with a logical expression
attach(trees)
sort(Volume) # orders the volume values, note there is one value larger than 60, and this is the 31st value in the vector


# select trees with volume smaller than 60
tr <- trees[Volume < 60,]


# check which rows satisfy a specific condition
which(trees$Volume > 60)

# select using the 'which' function 
trees[which(trees$Volume > 60),]

# though use of 'which' is not strictly necessary (NOT IN TUTORIAL)
trees[trees$Volume > 60,] # gives the same result

# to clarify: 
# when attach is used, one can use:
# trees[Volume > 60,]
# to select

# when 'attach' is not used, one needs to use:
# trees[trees$Volume > 60,]
# to select


# combining logical expressions
tr <- trees[Volume >=20 & Volume <= 40,] # AND


# it is better to use parentheses
tr <- trees[(Volume >=20) & (Volume <= 40),]


# the more elegant 'subset' function to select elements
(tr.small <- subset(trees, Volume < 18))


# create a new attribute using the ifelse function (NOT IN TUTORIAL)
trees$size <- ifelse(test = trees$Height <= 76, yes = 1, no = 0)
str(trees)

trees$size <- ifelse(test = trees$Height <= 76, yes = "small", no = "large")
str(trees)


# NOTE: selecting random elements of an array, splitting on a factor (p.38) and section 4.9.1 
# (p. 39) not included in this script.


### EXERCISE ###
# Select elements from tree with a Girth smaller than 10
# Select elements from three with a Height equal to 70 OR 75
# the OR operator: |
# the equal sign: ==


# detach trees object
detach(trees)


### 4.10 Rearranging data
#############################################################################################

# NOT INCLUDED IN THIS SCRIPT


### 4.11 Character strings
#############################################################################################

# NOT INCLUDED IN THIS SCRIPT


### 4.12 Character strings (p.43)
#############################################################################################

# create a string, store in object 'label'
(label <- "A good graph")


# build string from pieces with the 'paste' function
paste(label, ":", 15, "x", 20, "cm")

(labels <- paste("B", 1:8, sep=""))

# extract a part of a string with 'substring'function
?substring # check help on 'substring' function
substring(label, 1, 4)

# extract a part from label and replace with "nice"
substring(label, 3) <- "nice"  
# selects the third and following charcters; replace the first charcters with nice 
label

# split a string with the 'strsplit' function
?strsplit
strsplit(label, " ")

unlist(strsplit(label, " "))

unlist(strsplit(label, " "))[3]


### 4.13 Objects and classes (p.44)
#############################################################################################

# display object classes
class(lm)

class(letters)

class(seq(1:10))

class(seq(1,10, by=.01))

class(diag(10))

class(iris)

class(iris$Petal.Length)

class(iris$Species)

class(iris$Petal.Length > 2)

class(lm(iris$Petal.Width ~ iris$Petal.Length))

class(hist(iris$Petal.Width))

class(table(iris$Species))


# dislay data summaries
# summary of attributes
summary(iris$Petal.Length)
summary(iris$Species)

# summary of a linear regression model
summary(lm(iris$Petal.Width ~ iris$Petal.Length))

# summary of a table
summary(table(iris$Species))


# test if object is of certain class of mode
is.factor(iris$Petal.Width)

is.factor(iris$Species)

# convert class or mode
as.factor(iris$Petal.Width)

as.numeric(iris$Species)


### 4.13.1 S3 and S4 classes (p.45)
#############################################################################################

# NOTE: this is important for spatial data analysis!

# load sp package
require(sp)

# load meuse dataset
data(meuse)

# display class
class(meuse)

# show data structure
str(meuse)


# make the spatial nature of the data explicit by specifying the coordinates
coordinates(meuse) <- ~ x + y
# alternate command format: coordinates(meuse) <- c("x", "y")

# display class
class(meuse)

# show data structure
str(meuse) # the @ are called 'slots'


# examine class hierarchy
getClass("SpatialPointsDataFrame")


# display slot names
slotNames(meuse)


# get helop on a class
?"SpatialPointsDataFrame-class"

# display classes of slots
class(meuse@bbox)

class(meuse@data)


# access slot with the @ operator
meuse@bbox

# extract elements of slot
meuse@bbox["x","min"]


# alternatively use access methods
bbox(meuse)


# get help on methods that can be applied to a class
class?SpatialPointsDataFrame
class?SpatialPoints
class?Spatial


# display classes that can be used by 'spplot' function
showMethods(spplot)


### 4.14 Descriptive statistics (p.48)
#############################################################################################

# load data and attach
data(trees) ; attach(trees)

# summary statistics
min(Volume); max(Volume); median(Volume);mean(Volume); length(Volume)

# rounding values (NOT IN TUTORIAL)
round(mean(Volume), digits = 1)


# another descriptive function is quantile
quantile(Volume)
quantile(Volume, probs = .1) # for a specific probability
quantile(Volume, probs = seq(0, 1 , by = .1))


# descriptive statistics for one field
summary(Volume)


# some summary functins are vectorized and can be applied to an entire data frame
colMeans(trees) # in tutorial 'mean(trees)'; does not work anymore
summary(trees)


# apply a function to all columns in a data frame
apply(X = trees, MARGIN = 2, FUN = median) # MARGIN = 2 indicates columns


# compute skewness and kurtosis (e1071 package must be used for this)
require(e1071)
skewness(trees$Volume)
kurtosis(trees$Volume)

detach(trees) # NOT IN TUTORIAL


### 4.15 Classification tables (p.50)
#############################################################################################

# load data
require(sp) ; data(meuse) ; str(meuse)
attach(meuse)

# tabulate
table(ffreq) # one attribute

# express in percentages
round(100*table(ffreq)/length(ffreq), 1)

# tabulate two variables
table(ffreq, landuse)


# chi-square test for conditional independence
chisq.test(ffreq, lime)

detach(meuse) # NOT IN TUTORIAL


### 4.16 Sets (p.51)
#############################################################################################

# NOT INCLUDED IN THIS SCRIPT


### 4.17 Statistical models in S
#############################################################################################

# fit a linear regressin model
(model <- lm(trees$Volume ~ trees$Height))


# scripting is easier when object is attached
attach(trees)

model <- lm(Volume ~ Height)


# or more properly scripted:
model <- lm(Volume ~ Height, data=trees)

# additive effects (multiple linear regression)
model <- lm(Volume ~ Height + Girth, data=trees)


# include interaction terms
model <- lm(Volume ~ Height + Girth + Height:Girth, data=trees)


model <- lm(Volume ~ Height * Girth, data=trees)


model <- lm(Volume ~ (Height + Girth)^2, data=trees)

detach(trees) # NOT IN TUTORIAL


# NOTE: scripts for 'Removing terms' (p.53), 'Nested models', 'No intercept', 
# 'Arithmetic operations in formulas' (p.54), 'The design matrix'(p.55) not included here

# NOTE: take a closer look at sections 4.17.1 and 4.17.2 after having finished the guided self-study 
# Scripts for these sections not included here.


### 4.18 Model output (p.57)
#############################################################################################

# fit linear regression model
model <- lm(Volume ~ Height * Girth, data=trees)

# extract model coefficients
coefficients(model)

# display fitted values
fitted(model)

# display model residuals
residuals(model) # OR: resid(model)

# extract model formula
formula(model)


# model summary
summary(model)


# compute Akaike's Information Criterion; useful for model selection 
attach(trees) # NOT IN TUTORIAL

AIC(lm(Volume ~ Height * Girth))

AIC(lm(Volume ~ Height + Girth))

AIC(lm(Volume ~ Girth))

AIC(lm(Volume ~ 1))

detach(trees) # NOT IN TUTORIAL

# Question: based on AIC, which model is best?

# NOTE: more information on model diagnostics and model predicton are found in sections 4.18.1 and 4.18.2
# You may want to take a closer look at this after finishing the guided self-study
# Scripts for sections 4.18.1 and 4.18.2 are not included here

### EXERCISE ### 
# Load the meuse dataset of the sp package
# fit a linear regression model use:
  # 'zinc' on log-scale [log(zinc)] as dependent (target) variable and 
  # 'ffreq' and 'dist' as independent variables (covariates)
# store the model in object named 'meuse.lm'
# summarize the model; how much of the variation is explained by the model?
# plot a histogram of the model residuals using the 'hist' function 


### 4.19 Advanced statistical modelling (p.62)
#############################################################################################

# Read section 4.19. There is no associated R code.


### 4.20 Missing values (p.63)
#############################################################################################

# add a missing value to data
trees$Volume[1] <- NA
str(trees)

# summary of Volume attribute
summary(trees$Volume)


# function produces an error because of a missing value
cor(x = trees$Volume, y = trees$Girth) # cor computes the correlation coefficient
mean(trees$Volume) # NOT IN TUTORIAL


# solutions:
cor(x = trees$Volume, y = trees$Girth, use = "complete.obs")
mean(trees$Volume, na.rm = TRUE) # NOT IN TUTORIAL


# check for missing values with the complete.cases function
complete.cases(trees)

# remove cases (data frame rows) with a missing value in any variable
trees.complete <- na.omit(trees)
str(trees.complete)


### 4.21 Control structures and looping (p.64)
#############################################################################################

# 'for' loop
cmp <- cm

for (i in 1:length(cm)) cmp[i] <- cm[i]/sum(cm)

cmp


# same result can be obtained with a vectorized operation (which is much more efficient!)
cmp <- cm/sum(cm)


## an example of the if ... else control structure (more advanced stuff):
## the aim is to find the point that is closest to a target point

# simulate x and y coordinate of ten sample points, store in data frame
n.pts <- 10
sample.pts <- data.frame(x = runif(n.pts), y = runif(n.pts))

# simulate the target point (generated numbers can differ from those in tutorial)
new.pt <- data.frame(x = runif(1), y = runif(1))
print(paste("Target point: x=", round(new.pt$x,4), ", y=", round(new.pt$y,4)))


# the distance to the nearest point can't be further than sqrt(2) on a 1x1 grid
# (note the use of '{}')
min.dist <- sqrt(2); close.pt <- NULL

# to run the for loop select all lines form line 1026 to 1039
# the foor loop runs through the 10 simulated points. 
# for each point it evaluates if the distance from the point to the target point is the smallest distance found so far

for (pt in 1:n.pts){
  
  d <- sqrt((sample.pts[pt,"x"] - new.pt$x)^2 + (sample.pts[pt,"y"] - new.pt$y)^2)

  if (d < min.dist){
    min.dist <- d
    closest.pt <- pt
    
    print(paste("Point ",pt," is closer: d=", round(d,4)))
  
  } else {
    print(paste("Point ",pt,"is not closer"))
  }
}

print(paste("Closest point: x=", round(sample.pts[closest.pt,"x"],4), ",y=", round(sample.pts[closest.pt,"y"],4)))

plot(sample.pts, xlim=c(0,1), ylim=c(0,1), pch=20, col=ifelse(row.names(sample.pts) == closest.pt, "red", "green"), main="Finding the closest point")

text(sample.pts, row.names(sample.pts), pos=3)
points(new.pt, pch=20, col="blue", cex=1.2)
text(new.pt, "target point", pos=3, col="blue")
arrows(new.pt$x, new.pt$y, sample.pts[closest.pt,"x"], sample.pts[closest.pt,"y"], length=0.05)


### 4.22 User-defined functions (p.65)
#############################################################################################

# NOT INCLUDED IN THIS SCRIPT


### 4.23 Computer on the languate (p.68)
#############################################################################################

# NOT INCLUDED IN THIS SCRIPT


### 5. Graphics (p.69)
#############################################################################################

demo(graphics)
demo(image)

library(lattice)
demo(lattice)


### 5.1 Base graphics (p.69)
#############################################################################################

# load data
data(iris)

str(iris)

attach(iris)

# plot two variables
plot(x = Petal.Length, y = Petal.Width)


# alternatively, one can use (y~x)
plot(Petal.Width ~ Petal.Length)


# produce a cutomized plot (select lines 987 to 994 and then run the selected code)
plot(x = Petal.Length, y = Petal.Width, 
     pch = (21:23)[as.numeric(Species)], # plotting symbols
     cex = 1.2,                          # size, value for magnification
     xlab = "Petal length (cm)",         # title x-axis
     ylab="Petal width (cm)",            # title y-axis
     main = "Anderson Iris data",        # plot title
     col = c("slateblue", "firebrick", "darkolivegreen")[as.numeric(Species)] # colours
)

?par # gives overview of graphical parameters; NOT IN TUTORIAL


# adding lines for means or medians
abline(v=mean(Petal.Length), lty=2, col="red")
abline(h=mean(Petal.Width), lty=2, col="red")
abline(v=median(Petal.Length), lty=2, col="blue")
abline(h=median(Petal.Width), lty=2, col="blue")


# add a grid to the plot
grid()


# add mean and median centroids
points(mean(Petal.Length), mean(Petal.Width), cex=2, pch=23, col="black", bg="red")
points(median(Petal.Length), median(Petal.Width), cex=2, pch=23, col="black", bg="blue")

# add subtitle
title(sub="Centroids: mean (green) and median (gray)")


# add text to plot
text(1, 2.4, "Three species of Iris", pos=4, col="navyblue")


# add legend
legend(1, 2.4, levels(Species), pch=21:23, bty="n", col=c("slateblue", "firebrick", "darkolivegreen"))


# add a line based on a model
abline(lm(Petal.Width ~ Petal.Length), lty="longdash", col="red")

# repeat with robust regression from the MASS package
require(MASS) # for lqs function
abline(lqs(Petal.Width ~ Petal.Length), lty=2, col="blue")

# plot a histogram (NOT IN TUTORIAL)
hist(Petal.Width)
hist(Petal.Width, col = "lightblue", border="blue")

# undo attach 
detach(iris) #NOT IN TUTORIAL


# NOTE: Scripts for sections 5.1.1, 5.1.2, 5.1.3, 5.1.4 are not included here


### 5.2 Trellis graphics (p.77)
#############################################################################################

# load the lattice package (NOT IN TUTORIAL)
require(lattice)


## 5.2.1 Univariate plots
densityplot(~ Petal.Length, data = iris)
densityplot(~ Petal.Length | Species, data = iris)


## 5.2.2 Bivariate plots
xyplot(Petal.Width ~ Petal.Length, data = iris, groups = Species, auto.key=T)
xyplot(Petal.Width ~ Petal.Length | Species, data = iris, groups = Species)


## 5.2.3 Trivariate plots
# 3D scatter plot (select lines 1051 to 1057, run selected code)
pl1 <- cloud(Sepal.Length ~ Petal.Length * Petal.Width,
  groups = Species,
  data = iris, 
  pch=20, 
  main="Anderson Iris data, all species",
  screen=list(z=30, x=-60)
)
pl1


# 3D wireframe surface plot
data(volcano)
pl2 <- wireframe(volcano,
  shade = TRUE, aspect = c(61/87, 0.4),
  light.source = c(10, 0, 10), zoom=1.1, box=F,
  scales=list(draw=F), xlab="", ylab="", zlab="",
  main="Wireframe plot, Maunga Whau Volcano, Auckland"
)
pl2


# level plot
pl3 <- levelplot(volcano,
  col.regions=gray(0:16/16),
  main="Levelplot, Maunga Whau Volcano, Auckland"
)
pl3


# contour plot
pl4 <- contourplot(volcano, 
  at = seq(floor(min(volcano)/10)*10, ceiling(max(volcano)/10)*10, by=10),
  main = "Contourplot, Maunga Whau Volcano, Auckland",
  sub = "contour interval 10 m",
  region = TRUE,
  col.regions=terrain.colors(100)
)
pl4

# display all plots together
print(pl1, split=c(1,1,2,2), more=T)
print(pl2, split=c(2,1,2,2), more=T)
print(pl3, split=c(1,2,2,2), more=T)
print(pl4, split=c(2,2,2,2), more=F)

# clean-up
rm(pl1, pl2, pl3, pl4)

# note that volcano is just a matrix of numbers (in this case elevations)
str(volcano)
class(volcano) # NOT IN TUTORIAL


# plot point data using a colour ramp; NOT IN TUTORIAL
require(sp)
data(meuse)
xyplot(y ~ x , data = meuse, asp = "iso", pch = 20, cex = 2, col = topo.colors(length(meuse$cadmium))[rank(meuse$cadmium)])


# NOTE: Scripts for sections 5.2.4, 5.2.5, 5.2.6 are not included here


### 6. Preparing your own data for R
### 6.1 Preparing data directly in R (p.91)
#############################################################################################

# generate a vector
yr <- seq(1900,2004,4) # produces 1900, 1904, 1908, ... 2004

# to run: select lines 1114-1116 and then run the selected code
men <- c(11, 11, 10.8, 10.8, NA, 10.8, 10.6, 10.8, 10.3,
10.3, NA, NA, 10.3, 10.4, 10.5, 10.2, 10, 9.95, 10.14, 10.06, 10.25, 9.99, 9.92, 9.96, 9.84, 9.87, 9.85
)


women <- scan()
NA NA NA NA NA NA NA
12.2 11.9 11.5 NA NA
11.9 11.5 11.5 11 11.4 11.08 11.07 11.08 11.06 10.97
10.54 10.82 10.94 10.75 10.93
# press enter when 28: is displayed
str(women) # NOT IN TUTORIAL


# now combine the men and women data in one dataframe
oly.100 <- data.frame(year=yr, men, women)
str(oly.100)


# now enter a matrix
cm <- scan()
35 14 11 1 4 11 3 0 12 9 38 4 2 5 12 2
# press enter when 17: is displayed

# generate a matrix from the vector
cm <- matrix(cm, 4, 4, byrow=T)
cm

# give row and column names
colnames(cm) <- c ("A", "B", "C", "D")
rownames(cm) <- LETTERS[1:4]
cm

# access the matrix
cm[1, ]
cm["A", "C"]


### 6.2 A GUI data editor (p.92)
#############################################################################################

# NOT INCLUDED IN THIS SCRIPT


### 6.3 Importing data from a CSV file (p.93)
#############################################################################################

# two CSV files have already been prepared and are supplied with the course materials (example.csv, cm.csv)

# read example.csv (NOT IN TUTORIAL)
ds <- read.csv("example.csv")
str(ds)


# assign proper class to the attributes 
ds$soil <- as.factor(ds$soil)
ds$ffreq <- as.ordered(ds$ffreq)

ds$lime <- as.logical(ds$lime)
str(ds)


# read a matrix
cm <- as.matrix(read.csv("cm.csv", row.names=1))
cm

# display matrix properties
class(cm)

attributes(cm)


### 6.4 Importing images (p.96)
#############################################################################################

# NOT INCLUDED IN THIS SCRIPT


### 7. Exporting from R
#############################################################################################

# load sp and gstat packages
library(sp); library(gstat)

# load meuse data (data.frame and grid)
data(meuse)
data(meuse.grid)

# CODE BELOW DIFFERS FROM THE CODE IN THE TUTORIAL

# write txt table; the '.'in the path name represents your working directory (getwd())
write.table(meuse, file = "./meuse.txt", sep = "\t", row.names = FALSE, col.names = TRUE)

# write csv table
write.csv(meuse, file = "./meuse.csv", row.names = FALSE)

# read tables
meuse.txt <- read.table("./meuse.txt", header = TRUE)
str(meuse.txt)
meuse.csv <- read.csv("./meuse.csv")
str(meuse.txt)

# write ascii grids
gridded(meuse.grid) <- ~x+y # coverts to SpatialPixelsDataFrame
fullgrid(meuse.grid) <- TRUE # converts to SpatialGridDataFrame

write.asciigrid(meuse.grid, fname = "./meuseDist.asc", attr = "dist")

# read ascii grid
meuseDist <- read.asciigrid(fname = "./meuseDist.asc")
str(meuseDist)

# save plots (default resolution is 96 dpi)
png("histogram.png", width = 1800, height = 1200)
hist(meuse$zinc)
dev.off()

pdf("histogram.pdf", width = 6,  height = 6)
hist(meuse$zinc)
dev.off()

## saving your workspace environement
# save a specific object
save(meuse, file = "meuse.RDATA")

# save complete workspace
save.image("meuse.RDATA")


### 8. Reproducible data analysis (p.101)
#############################################################################################

# NOT INCLUDED IN THIS TUTORIAL


### 9. Learning R (p.105)
#############################################################################################

# Read the tutorial. There is no R code associated to this chapter.

# end of script;