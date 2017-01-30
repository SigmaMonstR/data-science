
health <- data.frame(syringe = c(1,1,0,0), 
           alc = c(0,1,1,1),
           band = c(0,0,1,1),
           insul = c(1,1,0,0),
           neo = c(0,0,0,1))
cor(health)

cosSim <- function(a, b){
  z <- sum(a * b) / (sqrt(sum(a^2)) * sqrt(sum(b^2)))
  return(z)
}

mat <- matrix(NA, ncol = ncol(health), nrow = ncol(health), dimnames = list(colnames(health),colnames(health)))
for(i in 1:5){
  for(k in 1:5){
    mat[i,k] <- cosSim(as.matrix(health[,i]), as.matrix(health[,k]))
  }
}

write.csv(mat,"health.csv", row.names=FALSE)
