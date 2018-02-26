##########################
##LECTURE 5: OLS Example##
##########################

#EXAMPLE 1 -- OLS 

#Read in file
  dir <- "/Users/jeff/Documents/Github/data-science/lecture-05/data"
  setwd(dir)
  df <- read.csv("tollroad_ols.csv")

#Check file
  str(df[1:3,])
  df$date <- as.Date(df$date, "%Y-%m-%d")
  df$fips <- factor(df$fips)
  
#Check correlations
  tab <- cor(log(df[,c(4:8)]), use = "complete")

#Set training/testing
  df$flag <- 0
  df$flag[df$year >= 2015] <- 1
  
#Run LM, v1
  fit <- lm( log(transactions) ~ log(emp), data = df[df$flag == 0,])
  summary(fit)
  
#Check coefficient
  summary(fit)$coef
  summary(fit)$r.squared
  str(summary(fit))
  
#Check errors
  library(ggplot2)
  x <- data.frame(resid = fit$residuals)
  set.seed(50)
  x$norm <- rnorm(nrow(x), mean(x$resid), sd(x$resid))
  
#Graph errors to check for normality
  ggplot(x, aes(resid)) + 
    geom_density(aes(norm), alpha = 0.4, fill = "yellow") + 
    geom_density(fill = "navy", alpha = 0.6) 
  
#LM v2
  fit <- lm(log(transactions) ~ log(emp) + log(bldgs) + log(wti_eia) + fips, 
            data = df[df$flag == 0,])
  summary(fit)
  
#Check errors
  x <- data.frame(resid = fit$residuals)
  set.seed(50)
  x$norm <- rnorm(nrow(x), mean(x$resid), sd(x$resid))
  ggplot(x, aes(resid)) + 
    geom_density(aes(norm), alpha = 0.4, fill = "yellow") + 
    geom_density(fill = "navy", alpha = 0.6) 
  
#Predict
  df$yhat <- predict(fit, newdata = df) 
  mape <- function(y_hat, y){
    
    return(100*mean(abs(y_hat/y-1), na.rm = T))
  }
  
#Check train versus test
  #train error
  train_error <- mape(df[df$flag == 0, "yhat"], log(df[df$flag == 0, "transactions"]))
  
  #test error
  test_error <- mape(df[df$flag == 1, "yhat"], log(df[df$flag == 1, "transactions"]))
