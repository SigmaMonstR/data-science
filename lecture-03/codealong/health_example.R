###################################################
##Lecture 3: Simplified Example of CF Item-Item  ##
###################################################

# Underlying data for class slides example of Collaborative Filtering

#Write a cosine function
  cosSim <- function(a, b){
    #
    # Desc: 
    #   Calculates cosine similarity for two numeric vectors
    # 
    # Args:
    #   a, b = numeric vectors
    #
    # Returns: 
    #   Score between 0 and 1
    
    z <- sum(a * b) / (sqrt(sum(a^2)) * sqrt(sum(b^2)))
    return(z)
  }

# Set up the data
  health <- data.frame(syringe = c(1,1,0,0), 
                       alc = c(0,1,1,1),
                       band = c(0,0,1,1),
                       insul = c(1,1,0,0),
                       neo = c(0,0,0,1))
  
# Create matrix
  mat <- matrix(NA, 
                ncol = ncol(health), 
                nrow = ncol(health), 
                dimnames = list(colnames(health),colnames(health)))
  
  #Loop through data
  for(i in 1:5){
    for(k in 1:5){
      mat[i,k] <- cosSim(as.matrix(health[,i]), 
                         as.matrix(health[,k]))
    }
  }

#Write results out
write.csv(mat, "health.csv", row.names=FALSE)
