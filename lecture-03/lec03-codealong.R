##Lecture 3: Codealong -- Collaborative Filtering

##PART 1 -- Set up
  #Set your WD
    setwd("/Users/jeff/Documents/Github/data-science/lecture-03/data/codealong")
  
  #transactions
    df <- read.table("user_artists.dat",sep="\t", header = TRUE)
  
  #Read in a ref table (need to use quote and fill due to spacing errors in data)
    ref <-  read.table("artists.dat",sep="\t", header = TRUE, quote = "", fill = TRUE)
    ref <- ref[, 1:2]
    
  #clean up table
    df <- merge(df, ref, by.x = "artistID", by.y = "id")
    df <- df[,c(2,4)]
    df$name <- as.character(df$name)
    df$flag <- 1
    
  #Keep only top occurring artists
    top <- 500
    count <- aggregate(df$flag, by = list(df$name), FUN=length)
    count <- count[order(-count$x),]
    count <- count[1:top, 1]  
    df <- df[df$name %in% count, ]
    
  #reshape
    mat <- reshape(df,
                   idvar = "userID",
                   timevar = "name",
                   direction = "wide")
    
  #Clean up of the mat
    colnames(mat) <- gsub("flag\\.", "", colnames(mat))
    colnames(mat) <- tolower(colnames(mat))
    mat[is.na(mat)] <- 0
    
  #Save values
    save(mat, file = "top.Rda")

##PART 2 - example
#Collaborative filtering: Item-based filtering
  
  #Cosine similarity -- create scoring function
  cosSim <- function(a, b){
      z <- sum(a * b) / (sqrt(sum(a^2)) * sqrt(sum(b^2)))
      return(z)
    }
  
  #Set up data
    items <- as.matrix(mat[,2:ncol(mat)])
    
  #Test the function. How similar are...
  print(grep("metallica",colnames(items)))
  print(grep("red hot chili peppers",colnames(items)))
  cosSim(items[, grep("metallica",colnames(items))], items[grep("red hot chili peppers",colnames(items))])
    
##Populate similarity matrix
  #Set up placeholder matrix -- Note that R is faster if the matrix is preset
  score  <- matrix(NA, ncol = ncol(items), nrow = ncol(items), 
                   dimnames = list(colnames(items),
                   colnames(items)))
      
a <- proc.time()[3]
  #Populate similarity matrix
  for(i in 1:ncol(items)) {
    print(paste("Progress:", i))
    for(j in 1:ncol(items)) {
      if(is.na(score[j,i])){
        score[i,j] <- cosSim(items[, i], items[, j])
        score[j,i] <- score[i,j]
      }
    }
  }
proc.time()[3]-a    

##Write functions to help navigate the matrix
  find.artist <- function(art.name){
    ##Search 'score' and returns names of matched artists
      return(grep(art.name, colnames(score), value = TRUE))
  }
  
  
  get.rec <- function(art.name, len = 10){
    ##Returns an ordered list of recommended artists based on cosine similarity
    index <- grep(art.name, colnames(score))[1]
    results <- data.frame(artists = row.names(score), scores = score[,index])
    results <- results[order(-results[,2]),]
    return(results[2:(len+1),])
  }

  
  #write.csv(score,"rec_matrix.csv",row.names = FALSE)
  save(score, file = "rec_matrix.Rda")
      
