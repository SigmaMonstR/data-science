#PRE-PORCESSING
##GOAL: Merge US and UK sanction lists
#UK:https://www.gov.uk/government/publications/financial-sanctions-consolidated-list-of-targets/consolidated-list-of-targets
#US: http://2016.export.gov/ecr/eg_main_023148.asp

#WD
  setwd("/Users/jeff/Documents/Github/data-science/lecture-10/data")
  uk <- read.csv("uk-sanctionsconlist.csv")
  us <- read.csv("us_screening_list-consolidated_2017-03-31.csv")

#Create a US Alt names file
  us2 <- strsplit(as.character(us$alt_name), ";")
  alt_id <- data.frame()
  for(i in 1:nrow(us)){
    if(length(unlist(us2[[i]]))>0){
      temp <- data.frame(person = as.character(us$name)[i], 
                         names = unlist(us2[[i]]),
                         dates_of_birth =  as.character(us$dates_of_birth)[i],
                         nationalities =  as.character(us$nationalities)[i])
      temp2 <- data.frame(person = as.character(us$name)[i], 
                         names = as.character(us$name)[i],
                         dates_of_birth =  as.character(us$dates_of_birth)[i],
                         nationalities =  as.character(us$nationalities)[i])
      alt_id <- rbind(alt_id, temp, temp2)
      print(i)
    }
  }
  us <- alt_id
  us$person <- as.character(us$person)
  us$names <- as.character(us$names)
  us$names <- trimws((us$names))
#Clean up UK File
  uk <- uk[,c(1:6,8,11,29)]
  for(k in 1:ncol(uk)){
    uk[,k] <- trimws(uk[,k])
  }

#Save file
  save(us, uk, file = "lec10.Rda")
  
  
  