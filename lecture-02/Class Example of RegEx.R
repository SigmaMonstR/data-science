

df <- data.frame(
          id = seq(1,3,1),
          name = c("George Costanza et al. v. Fire Dept", 
                   "Elaine Benes vs. Health Dept.",
                   "Umbrella Corp. versus Health Dept."),
          amount = c("$100k","10,000","No Payout"),
          comments = c("Plaintiff keeps angrily referring to Festivus and Toms Diner. He also saw 1 protestor.",
                       "Expressed discontent about food at Tom's Diner",
                       "10 protestors seen having food near Toms' Diner")
                       )

##Amount -- Replacement
  df$amount <- gsub("[[:punct:]]","",df$amount)
  df$amount <- gsub("k","000",df$amount)
  df$amount <- gsub("No Payout",NA,df$amount)
  df$amount <- as.numeric(df$amount)
  
  
##Name
  df$name <- as.character(df$name)
  gsub("vs\\.", "versus",df$name)
  gsub("v\\.", "versus",df$name)
  df$name <- gsub("vs\\.| v\\.", "versus",df$name)
  b <- strsplit(df$name,"versus")
  matrix(unlist(b), nrow=nrow(df), byrow=T)
  df <- cbind(data.frame(matrix(unlist(b), nrow=3, byrow=T)), df)

  
##Comments -- New Features
  df$comments <- gsub("[[:punct:]]","",df$comments)
  df$comments <- tolower(df$comments)
  df$bin_tomsdiner[grep("toms diner", df$comments)] <- 1
  df$bin_food[grep("food", df$comments)] <- 1
  
  #extract protestors
  regmatches(df$comments[3], regexpr("\\d+ protestor+",df$comments[3]))
  found <- regexpr("\\d+ protestor+",df$comments)
  out <- rep(NA,length(found))
  out[found!=-1] <- regmatches(df$comments, found)
  out

