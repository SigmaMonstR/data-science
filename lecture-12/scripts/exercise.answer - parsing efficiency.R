
#Exercise/ANSWER - Parsing efficiency
#Create a dummy variable matrix from each of the terms that are separated by a pipe delimiter

  set.seed(123)
  combo <-  paste(letters[sample(1:26,10000, replace = T)], 
                  LETTERS[sample(1:26,10000, replace = T)], 
                  c(rep(NA,5000),c(0:9)[sample(1:10,5000, replace = T)]), sep = "|")

#Answer
  start <- proc.time()[3]
  mat <- do.call("rbind",strsplit(combo, "\\|"))
  mat <- as.data.frame(mat)
  out <- cbind(model.matrix( ~ 0 +  V1, mat), model.matrix( ~ 0 +  V2, mat), model.matrix( ~ 0 +  V3, mat))
  proc.time()[3] - start
  