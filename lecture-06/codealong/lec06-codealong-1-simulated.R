########################################
##LECTURE 6: Example 1 - LASSO Example##
########################################

#Set up target
  n <- 100
  k <- 2000
  alpha.param <- 1
  select.k <- 3
  train.prop <- 0.7
  train.max <- round(n * train.prop)
  test.min <- train.max + 1
  
#MAPE
  mape <- function(y, x){
   return(100 * mean(abs(y / x - 1)))
  }
  
#Set up target
  y <- 10*sin(1:n) + cos((1:n)/10)*20 + 200
  plot(y, type = "l")

#Set up correlated inputs
  x <- matrix(NA, ncol = 0, nrow = n)
  for(i in 1:k){
    set.seed(i*i)
    rand1 <- runif(1)*1000
    rand2 <- runif(1)*1000
    over.under <- runif(1) > 0.5
    if(over.under == TRUE){ sign.val <- -1}else{ sign.val <- 1}
    x <- cbind(x, y + sign.val*runif(n)*rand1  -sign.val*rnorm(n, 1,10)  + cos((1:n)/5)*5 )
  }

#Split data into train and test
  y.train <- y[1:train.max]
  x.train <- x[1:train.max,]
  
  y.test <- y[test.min:n]
  x.test <- x[test.min:n,]
  
#Train LASSO
  library(glmnet)
  
  #CV
  a <- cv.glmnet(x.train, y.train, alpha = alpha.param)
  
  #Coef
  coef(a)
  plot(a)
  
  #Predict y
  yhat <- predict(a, x.test, s = "lambda.min")
  
  #Plot y
  err1 <- round(mape(yhat, y.test),2)
  
  par(mfrow=c(1,2))
  plot(y.test, type = "l", col = "grey", main = paste0("LASSO: ", err1))
  lines(yhat, col = "red")
  
#Compare against one lm
  rhos <- as.vector(cor(y.train, x.train))
  rhos <- data.frame(id = 1:length(rhos), rhos)
  rhos <- rhos[order(-rhos$rhos),]
  df.train <- data.frame(y.train, x.train[,rhos$id[1:select.k]])
  df.test <- data.frame(y.test, x.test[,rhos$id[1:select.k]])
  
  colnames(df.train) <- colnames(df.test) <- c("y", paste0("x",1:select.k))
  
  
  lm.obj <- lm(y~., data = df.train)
  yhat2 <- predict(lm.obj, newdata = df.test)
  
  #Plot y
  err2 <- round(mape(yhat2, y.test),2)
  plot(y.test, type = "l", col = "grey", main = paste0("Top ", select.k," Only: ", err2))
  lines(yhat2, col = "red")
