#Importing libraries
  install.packages(c("doParallel", "foreach"))
  library(doParallel)
  library(foreach)
  
#Method #1 (Rbind)
  placeholder <- data.frame()
  start <- Sys.time()
  for(i in 1:1000){
    print(i)
    n <- 10000
    df <- data.frame(y = rnorm(n, 10, 100), x = rnorm(n, 10, 100))
    obj <- lm(y ~ x, data = df)
    yhat <- predict(obj, df)
    temp <- data.frame(iteration = i, y = df$y, yhat = yhat)
    placeholder <- rbind(placeholder, temp)
  }
  end <- Sys.time()
  
  
#Method #2 (List -- FASTER)
  placeholder <- list()
  start <- Sys.time()
  for(i in 1:1000){
    print(i)
    n <- 10000
    df <- data.frame(y = rnorm(n, 10, 100), x = rnorm(n, 10, 100))
    obj <- lm(y ~ x, data = df)
    yhat <- predict(obj, df)
    temp <- data.frame(iteration = i, y = df$y, yhat = yhat)
    placeholder[[i]] <- temp
  }
  end <- Sys.time()
  
  
#Method #3  (Parallel -- FASTER)
  cl <- makeCluster(detectCores()-1)
  registerDoParallel(cl)
  start <- Sys.time()
  result <- foreach(i = 1:1000, .combine = list) %dopar% {
    n <- 10000
    df <- data.frame(y = rnorm(n, 10, 100), x = rnorm(n, 10, 100))
    obj <- lm(y ~ x, data = df)
    yhat <- predict(obj, df)
    temp <- data.frame(iteration = i, y = df$y, yhat = yhat)
    
    return(list(reg_obj = obj, df_obj = temp))
  }
  
  end <- Sys.time()
  stopCluster(cl)
  