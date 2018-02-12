##########################
##LECTURE 5: OLS Example ##
##########################

#EXAMPLE 2 -- OLS from scratch
#Uses monthly 1-unit housing permits time series from the US Census Bureau

#Load library
  library(ggplot2)

#Load data
  dir <- "/Users/jeff/Documents/Github/data-science/lecture-05/data"
  setwd(dir)
  out <- read.csv("building_permits.csv")

#Check file
  str(out[1:3,])
  out$date <- as.Date(paste0(out$date,"01"), "%Y%m%d")
  
#DATA PREP -------------
#Monthly line plot
  ggplot(out, aes(date, x)) + geom_line()

#Monthly dummies
  month = format(out$date, "%m")
  dummies = model.matrix(~ month)
  colnames(dummies)

#Date Index
  date.index <- 1:nrow(out)

#Create matrix of input features
  X <- cbind(dummies[, -13], date.index)
  head(X)
  
#Get y as a vector
  y <- out$permits

#MATH -------------
#Matrix multiply XT by X
  a <- t(X) %*% X
  
#Solve for inverse of a
  w <- solve(a) %*% t(X) %*% y

#Compare w with lm() object 
  lm.obj <- lm(y ~ X[,-1])

#Consolidate and compare model coefficients
  comparison <- data.frame(`From Scratch` = w, 
                           `lm Function` = coef(lm.obj))

#Print
  print(comparison)
  