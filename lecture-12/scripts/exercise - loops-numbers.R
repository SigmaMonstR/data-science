
#Example of loops
#Create a data frame with a growing random number list

speed <- data.frame()

#For loop
  start <- proc.time()[3]
  out <- lapply(1:1000, function(x){ data.frame(id = x, res = runif(x))})
  out <- do.call("rbind", out)
  timed <- proc.time()[3] - start
  speed <- rbind(speed, data.frame(type = "lapply", time = timed))


#Forloop
  start <- proc.time()[3]
  out <- data.frame()
  for(x in 1:1000){
    out <- rbind(out, data.frame(id = x, res = runif(x)))
  }
  timed <- proc.time()[3] - start
  speed <- rbind(speed, data.frame(type = "for", time = timed))


#Parallel
  library(doParallel)
  library(foreach)
  
  cl <- makeCluster(2)
  registerDoParallel(cl)
  
  start <- proc.time()[3]
  
  out <- foreach( 1:1000, .combine = rbind) %dopar% {
    temp <- data.frame(id = x, res = runif(x))
    return(temp)
  }
  timed <- proc.time()[3] - start
  speed <- rbind(speed, data.frame(type = "for", time = timed))

#What did we learn?