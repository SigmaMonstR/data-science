#####################
# Example of RegEx #
#####################

#Create a hypothetical data frame 
df <- data.frame( id = seq(1,3,1),
                  name = c("George Costanza et al. v. Fire Dept", 
                           "Elaine Benes vs. Health Dept.",
                           "Umbrella Corp. versus Health Dept."),
                  amount = c("$100k","10,000","No Payout"),
                  comments = c("Plaintiff keeps angrily referring to Festivus and Toms Diner. He also saw 1 protestor.",
                               "Expressed discontent about food at Tom's Diner",
                               "10 protestors seen having food near Toms' Diner"))

##Use gsub() to replace certain characters
  df$amount <- gsub("[[:punct:]]","",df$amount)
  df$amount <- gsub("k","000",df$amount)
  df$amount <- gsub("No Payout",NA,df$amount)
  df$amount <- as.numeric(df$amount)
  
##Standardize "versus","vs.", "v."
  #Turn into characters
  df$name <- as.character(df$name)
  
  #Replace vs. and v. as versus
  df$name <- gsub("vs\\.|v\\.", "versus",df$name)
  
#Extract plaintiff and defendent, add to data frame
  b <- strsplit(df$name,"versus")
  temp <- matrix(unlist(b), nrow=nrow(df), byrow=T)
  colnames(temp) <- c("plaintiff","defendent")
  df <- cbind(temp, df)
  
##Extract new features from comments
  #replace punctuation with blanks, turn into lower case
  df$comments <- gsub("[[:punct:]]","",df$comments)
  df$comments <- tolower(df$comments)
  
  #Create binary for each toms diner and food
  df$bin_tomsdiner[grep("toms diner", df$comments)] <- 1
  df$bin_food[grep("food", df$comments)] <- 1
  
  #extract number of protestors
  regmatches(df$comments[3], regexpr("\\d+ protestor+",df$comments[3]))
  found <- regexpr("\\d+ protestor+",df$comments)
  out <- rep(NA,length(found))
  out[found!=-1] <- regmatches(df$comments, found)
  out

