##Data dictionary for ACS 2015

#Check for packages
  if("DT" %in% rownames(installed.packages()) == FALSE) {install.packages("DT")}
  library(DT)

#Read in dictionary
  rec <- readLines("http://www2.census.gov/programs-surveys/acs/tech_docs/pums/data_dict/PUMSDataDict15.txt")
  census_dict <- data.frame(rec)
  census_dict$var <- NA
  census_dict$rec_no <- NA
  census_dict$rec <- as.character(census_dict$rec)

#Format table
  for(k in 2:nrow(census_dict)){
    if(substr(census_dict$rec[k-1],1,1)=="" && substr(census_dict$rec[k],1,1)!=""){
      census_dict$var[k] <- substr(census_dict$rec[k],1,regexpr("\t",census_dict$rec[k])[1])
      census_dict$rec_no[k] <- 1
    }
    if(substr(census_dict$rec[k-1],1,1)!="" && substr(census_dict$rec[k],1,1)!="" ){
      census_dict$var[k] <- census_dict$var[k-1]
      census_dict$rec_no[k] <- census_dict$rec_no[k-1]+1
    }
  }
  
  census_dict <- census_dict[!is.na(census_dict[,3]) & census_dict[,3]!=1,c(2,3,1)]
  census_dict$rec_no <- census_dict$rec_no -1
  census_dict[,1]<- gsub("\t","",census_dict[,1])
  census_dict[,2]<- gsub("\t","",census_dict[,2])
  census_dict[,3]<- gsub("\t","",census_dict[,3])
  colnames(census_dict) <- c("Var", "Record No","Definition")

#Read in function
  check_dict <- function(var, asHTML = FALSE){
    if(asHTML==TRUE){
      datatable(census_dict[census_dict$Var == var,])
    } else{
      print(census_dict[census_dict$Var == var,], right=FALSE)
    }
  }
