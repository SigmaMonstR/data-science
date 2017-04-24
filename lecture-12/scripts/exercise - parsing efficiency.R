
#Exercise - Parsing efficiency
#Create a dummy variable matrix from each of the terms that are separated by a pipe delimiter

  set.seed(123)
  combo <-  paste(letters[sample(1:26,1000, replace = T)], 
                  LETTERS[sample(1:26,1000, replace = T)], 
                  c(rep(NA,500),c(0:9)[sample(1:10,500, replace = T)]), sep = "|")
