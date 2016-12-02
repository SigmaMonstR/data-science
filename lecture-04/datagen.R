
datagen <- function(n,p){
  
  theta <- acos(p)             # corresponding angle
  x1    <- rnorm(n, 1, 1)        # fixed given data
  x2    <- rnorm(n, 2, 0.5)      # new random data
  X     <- cbind(x1, x2)         # matrix
  cent  <- scale(X, center=TRUE, scale=FALSE)   # centered columns (mean 0)
  
  Id   <- diag(n)                               # identity matrix
  Q    <- qr.Q(qr(cent[ , 1, drop=FALSE]))      # QR-decomposition, just matrix Q
  P    <- tcrossprod(Q)          # = Q Q'       # projection onto space defined by x1
  x2o  <- (Id-P) %*% cent[ , 2]                 # x2ctr made orthogonal to x1ctr
  Xc2  <- cbind(cent[ , 1], x2o)                # bind to matrix
  Y    <- Xc2 %*% diag(1/sqrt(colSums(Xc2^2)))  # scale columns to length 1
  
  x <- Y[ , 2] + (1 / tan(theta)) * Y[ , 1]     # final new vector
  cor(x1, x)    
  return(cbind(x,x1))
}
