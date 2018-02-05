###################################################
##Lecture 3: Codealong -- Collaborative Filtering##
###################################################

####################
##PART 1 -- Set up##
####################

  #Set your WD
  setwd("/Users/jeff/Documents/Github/data-science/lecture-03/data/ready")
  
  #transactions
  df <- read.table("user_artists.dat", sep="\t", header = TRUE)
  
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

#################################
##PART 2 - Item-Item Filtering##
################################

#Step 1: Create cosine similarity function
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
  
#Try out the cosine similarity
  cosSim(mat[,2], mat[,5])
  
#Step 2: Set up data 
  
  #Convert data frame into matrix of items only (drop ID)
  items <- as.matrix(mat[,2:ncol(mat)])
  
  #Test the function. How similar are...
  print(grep("metallica",colnames(items)))
  print(grep("red hot chili peppers",colnames(items)))
  
  metallica <- items[, grep("metallica",colnames(items))]
  peppers <- items[,grep("red hot chili peppers",colnames(items))]
  
  cosSim(metallica, peppers)
  
#Step3: Populate similarity matrix -- pairwise calculation
  
  #Set up placeholder matrix -- Note that R is faster if the matrix is preset
  score  <- matrix(NA, 
                   ncol = ncol(items), 
                   nrow = ncol(items), 
                   dimnames = list(colnames(items),
                                   colnames(items)))
    
  #Loop through each artist combination
    #log the start time
    a <- proc.time()[3]
    
    #Loop through combinations
    for(i in 1:ncol(items)) {
      print(paste("Progress:", i))
    for(j in 1:ncol(items)) {
      if(is.na(score[j,i])){
        score[i,j] <- cosSim(items[, i], items[, j])
        score[j,i] <- score[i,j]
      }
      }
    }
    
    #calculate duration
      proc.time()[3]-a 
      
    #Save results
      save(score, file = "rec_matrix.Rda")
      
#######################################
##PART 3 - Analyze Matrix of Results##
######################################
      
## Write functions to help navigate the matrix
  findArtist <- function(art.name){
    #
    # Desc: 
    #   Search for artist names in data
    # 
    # Args:
    #   art.name = term to be searched
    #
    # Returns: 
    #   Vectors of matching names
    
    return(grep(art.name, colnames(score), value = TRUE))
  }
  
  
  getRec <- function(art.name, lens = 10){
    #
    # Desc: 
    #   Returns top X most co-listened to artists
    # 
    # Args:
    #   art.name = artist name to be searched
    #   len = number of matched results (default = 10)
    #
    # Returns: 
    #   Data frame of matches
    
    index <- findArtist(art.name)[1]
    print(paste0("Closest match = ", index))
    results <- data.frame(artists = row.names(score), scores = score[, index])
    results <- results[order(-results[, 2]),]
    row.names(results) <- (1:nrow(results))-1
    return(results[2:(lens + 1),])
    }

#Try out results
  getRec("kylie")
  getRec("avril")
  getRec("arcade")
    
