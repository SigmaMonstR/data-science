############################
##K-Folds Cross Validation##
############################

#Function to shuffle data and cut into folds
kfolds.index <- function(n, k, random = TRUE){
  # Returns a vector of labels for each of k-folds. 
  # Useful for setting up k-folds cross validation
  #
  # Args:
  #       n: data size
  #       k: k-folds
  #       random: whether folds should be sequential or randomized (default)
  #
  # Returns:
  #       Vector of numeric labels
  
  #create row index
  row.id <- 1:n
  
  #Decide splits
  break.id <- cut(row.id, breaks = k, labels = FALSE)
  
  #Randomize
  if(random == TRUE){
    row.id <- row.id[sample(row.id, replace = FALSE)]
  }
  
  #Package up
  out <- data.frame(row.id = row.id, folds = break.id)
  out <- out[order(out$row.id), ]
  return(out[,2])
}

######################################
##Example using built in iris data##
######################################

#Goal of this example is to show how the value of k is inversely proportional to error
#First, we'll show an example where k = n, using a data the "iris" dataset

#Part 1: Demo
  data(iris)
  
  #k = n
  k <- nrow(iris)
  n <- nrow(iris)
  
  #Set folds
  iris$folds <- kfolds.index(n, k)
  
  #Set placeholder
  error.train <- c()
  error.test <- c()
  
  #Run kfolds
  for(k in unique(iris$folds)){
    
    #Cut train/test
    train <- iris[iris$folds != k, ]
    test <- iris[iris$folds == k, ]
    
    #estimate model
    fit <- lm(Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width + Species, data = train)
    
    #calc error, log it
    error.train <- c(error.train, abs(predict(fit, newdata = train)/train$Sepal.Length - 1))
    error.test <- c(error.test, abs(predict(fit, newdata = test)/test$Sepal.Length - 1))
  }
  
  #Comparison
    mean(error.train, na.rm = T)
    mean(error.test, na.rm = T)
    

##########################    
#Part 2: Find optimal K##
########################## 
    
  n <- nrow(iris)
  
  #Empty data frame for append 
  cross.res <- data.frame()
    
  #iterate from k= 2 to k = n
    for(j in 2:n){
      
      print(j)
      
      #Start time
      start.time <- proc.time()[3]
      
      #Set folds
      iris$folds <- kfolds.index(n, j)
      
      #Set placeholder
      error.train <- c()
      error.test <- c()
      
      #Run kfolds
      for(k in unique(iris$folds)){
        
        #Cut train/test
        train <- iris[iris$folds != k, ]
        test <- iris[iris$folds == k, ]
        
        #estimate model
        fit <- lm(Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width + Species, data = train)
        
        #calc error, log it
        error.train <- c(error.train, abs(predict(fit, newdata = train)/train$Sepal.Length - 1))
        error.test <- c(error.test, abs(predict(fit, newdata = test)/test$Sepal.Length - 1))
      }
      
      #duration
      times <- proc.time()[3]- start
      
      #Comparison
      cross.res <- rbind(cross.res, 
                         data.frame(k = k, 
                                    train = mean(error.train, na.rm = T),
                                    test = mean(error.test, na.rm = T),
                                    time = times))
    }
  
  #plots
  cross.res <- cross.res[order(cross.res$k), ]
  cross.res$smooth <- NA
  for(k in 4:(nrow(cross.res)-3)){ cross.res$smooth[k] <- mean(cross.res$test[(k-3):(k+3)])}
  
  plot(cross.res$k, cross.res$test, main = "Cross validation", xlab = "k", ylab = "MAPE", pch = 19, cex = 0.5)
    lines(cross.res$k, cross.res$smooth, col="red")
  