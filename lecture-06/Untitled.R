census_geocoder <- function(address,type,secondary,state){
  
  library(RCurl)
  library(jsonlite)
  
  addy <- paste("street=",gsub(" ","+",address),sep="")
  if(type=="z"){
    wild <- paste("zip=",gsub(" ","+",secondary),sep="")
  }else{
    wild <- paste("city=",gsub(" ","+",secondary),sep="")
  }
  
  state <- paste("state=",gsub(" ","+",state),sep="") 
  string <-  paste("https://geocoding.geo.census.gov/geocoder/geographies/address?",addy,"&",wild,"&",state,"&benchmark=4&vintage=4&format=json",sep="")
  json_file <- fromJSON(string)
  
  #Check if there are results
  if(nrow(json_file$result$addressMatches$coordinates)>0){
    
    #If not, kick back an empty dataframe
    if(is.null(json_file$result$addressMatches$coordinates$x[1])==TRUE){
      print("no result")
      return(data.frame(
        address="",
        lat = "",
        lon= "",
        tract = "",
        block = ""))
      
    } else{
      
      #Address,lat,lon,tract, block
      return(data.frame(
        address=as.character(data.frame(json_file$result$addressMatches)[1,1]),
        lat = as.character(json_file$result$addressMatches$coordinates$y[1]),
        lon= as.character(json_file$result$addressMatches$coordinates$x[1]),
        tract = data.frame(json_file$result$addressMatches$geographies$`Census Tracts`)$GEOID[1],
        block = data.frame(json_file$result$addressMatches$geographies$`2010 Census Blocks`)[1,c("GEOID")]))
      
    }
  }
}