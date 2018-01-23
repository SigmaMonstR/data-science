########################################
##LECTURE 6: Example 1 - LASSO FLU    ##
########################################


#Get Libraries
  library(glmnet)
  library(digIt)
  
#Get Data
  flu <- digIt("flu")
  sample(colnames(flu), 20, replace = FALSE)
  
#Calculate correlation matrix
  mat <- cor(flu[,ncol(flu):2])
  
  #Extract correlates with ILI
  top <- data.frame(query = row.names(mat), 
                    rho = mat[,1])
  top <- top[order(-top$rho),]
  
  #Show top ten
  head(top, 10)
  
#Set up train-test
  #Set sample partition parameters
  train.prop <- 0.75
  train.max <- round(nrow(flu) * train.prop)
  test.min <- train.max + 1
  
  #Train
  y.train <- flu$ili.rate[1:train.max]
  x.train <- flu[1:train.max,]
  x.train$date <- x.train$ili.rate <- NULL
  x.train <- as.matrix(x.train)
  
  #Test
  y.test <- flu$ili.rate[test.min:nrow(flu)]
  x.test <- flu[test.min:nrow(flu), ]
  x.test$date <- x.test$ili.rate <- NULL
  x.test <- as.matrix(x.test)
  
#Estimate CV lasso
  mod.lasso <- cv.glmnet(x.train, y.train, 
                         nfolds = 20,
                         alpha = 1, 
                         type.measure = "mse")
  

#Plot CV performance
  plot(mod.lasso)
  
#Coefficients
  coef(mod.lasso,  s = c("lambda.min") )
  coef(mod.lasso,  s = c( 0.01, 0.5), exact = TRUE )
  
#Predict values, get errors
  #Predict y
  yhat.train <- predict(mod.lasso, x.train, s = "lambda.min")
  yhat.test <- predict(mod.lasso, x.test, s = "lambda.min")
  
  #Calculate out of sample error
  rmse <- function(y, x){
    return(sqrt(mean((y - x)^2)))
  }
  err1 <- round(rmse(yhat.test, y.test),2)
  print(err1)
  
#Compare against plain vanilla OLS
  
  #Calculate correlation matrix using training data
  rhos <- as.vector(cor(y.train, x.train))
  rhos <- data.frame(id = 1:length(rhos), rhos)
  rhos <- rhos[order(-rhos$rhos),]
  
  #Set up a juxtaposed plot area for six graphs
  par(mfrow=c(2,3), 
      oma = c(5,4,0,0) + 0.5,
      mar = c(0,0,1,1) + 0.5)
  
  #Plot the LASSO
  plot(y.test, type = "l", col = "grey", main = paste0("LASSO: RMSE = ", err1), 
       cex.main = 1.2, ylab = "outcome", xaxt='n', yaxt = 'n')
  lines(yhat.test, col = "red")
  
  #Loop through and plot top X correlates using OLS
  for(i in c(1, 2, 3, 5, 10)){
    #Set up data
    df.train <- data.frame(y.train, x.train[,rhos$id[1:i]])
    df.test <- data.frame(y.test, x.test[,rhos$id[1:i]])
    colnames(df.train) <- colnames(df.test) <- c("y", paste0("x",1:i))
    
    #Model
    lm.obj <- lm(y~., data = df.train)
    yhat2 <- predict(lm.obj, newdata = df.test)
    
    #Plot y
    err2 <- round(rmse(yhat2, y.test),2)
    plot(y.test, type = "l", col = "grey", main = paste0("Top ", i," Only: RMSE = ", err2), 
         ylab = "outcome", cex.main = 1.2, xaxt='n', yaxt = 'n')
    lines(yhat2, col = "red")
  }
  