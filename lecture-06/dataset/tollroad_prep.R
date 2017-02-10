#Lecture 6: Tollroad example prep
  setwd("/Users/jeff/Documents/Github/data-science/lecture-06")
  
  #Load in libraries
    library(ggplot2)
    source("https://raw.githubusercontent.com/SigmaMonstR/census-geocoder/master/wrapper.R")
    lead02 <- function(m,pad_val, pad_len){
      m <- as.character(m)
      for(k in 1:(pad_len-1)){
        m[nchar(m)==k] <- paste0(paste(rep(pad_val,pad_len - k), collapse = ""), m[nchar(m)==k])
      }
      return(m)
    }
  
  #READ IN DATA
    library(gdata)
    eia <- read.xls("dataset/PET_PRI_SPT_S1_D.xls", sheet = 2, skip=2)
    data <- read.csv("dataset/maryland_tolls.csv")
    zipcounty <- read.csv("dataset/ZIP_COUNTY_HUD.csv")
    fips <- read.csv("dataset/county_to_msa.csv", header = FALSE)
    
    colnames(fips) <- c("fips.msa","name.msa","fips.county","name.county")

    
  #GET HOUSING PERMITS
    #Prep time codes to be looped
    month <- lead02(as.character(seq(1,12,1)),"0",2)
    year <- lead02(as.character(seq(11,16,1)),"0",2)
    comb <- expand.grid(year,month)
    period <- paste0(comb[,1],comb[,2])
    period <- sort(period)
    
    permits <- function(vec){
      master <- data.frame()
      
      for(k in vec){
        print(k)
        temp <- tempfile()
        download.file(paste0("http://www2.census.gov/econ/bps/County/co",k,"c.txt"), 
                      temp, mode="wb")
        df <- read.csv(temp, skip=1)
        df <-  df[,c(1, 2, 3, 7)]
        colnames(df)<-c("date", "fips.st", "fips.county","bldgs")
        master <- rbind(master,df)
      }
      return(master)
    }

    housing <- permits(period)
    for(k in 1:4){
      housing <- housing[!is.na(housing[,k]),]
    }
    housing$fips <- as.numeric(paste0(housing$fips.st, lead02(housing$fips.county,"0",3)))
    housing <- housing[,c(1,5,4)]
    
  #GET BLS DATA
    #Data from: https://www.bls.gov/cew/datatoc.htm
    source("https://raw.githubusercontent.com/SigmaMonstR/qcew_unpack/master/qcew_unpack.R")
    
    dir <- "/Users/jeff/Downloads/"
    lists <- c("2016.q1-q2.by_area", "2012.q1-q4.by_area","2013.q1-q4.by_area",
               "2014.q1-q4.by_area","2015.q1-q4.by_area")
    
    bls_emp <- data.frame()
    for(k in lists){
      setwd(paste0(dir, k))
      files <- list.files(pattern = "*Maryland.csv")
      print(k)
      for(i in files){
        temp <- tot.emp(i)
        bls_emp <- rbind(bls_emp, temp)
        print(i)
      }
    }
    bls_emp$date <- paste0(bls_emp$year, lead02(bls_emp$month,"0",2))
    bls_emp <- bls_emp[,c("date","area_fips","emp")]
    
    
    
  #GET ZIPCODES
    loc <-  as.character(unique(data$Location))
    output <- data.frame()
    for(k in loc){
     addy <- unlist(strsplit(k,"\n|,|MD\\s+"))
     zip <- addy[4]
     out <- zipcounty[zipcounty$ZIP == zip,2][1]
     if(length(out)>0){
       output <- rbind(output, data.frame(Location = k, fips = out))
     }
     print(k)
    }

    fips$fips.msa <- as.numeric(as.character(fips$fips.msa))
    fips <- fips[,c(1,3)]
    fips <- fips[!duplicated(fips$fips.county),]
    
  #GET EIA
    eia$Date <- as.Date(as.character(eia$Date), "%b %d, %Y")
    eia$date <- paste0(format(eia$Date,"%Y"),format(eia$Date, "%m"))
    eia <- eia[,c(5,2)]
    eia <- aggregate(eia[,2], by = list(date = eia$date), FUN = mean)
    colnames(eia) <- c("date","wti_eia")

   
  #MERGE DATA 
    fips <- merge(output,fips, by.x = "fips", by.y = "fips.county")
    data <- merge(data, fips, by= "Location" )
    data$Date <- strptime(as.character(data$Date),"%m/%d/%y %H:%M")
    data$date <- paste0(format(data$Date,"%Y"),format(data$Date,"%m"))
    data$Date <- NULL
    
    data3 <- aggregate(data$Total.Transactions, by = list(fips = data$fips, date = data$date), FUN = sum)
    colnames(data3) <- c("fips","date","transactions")
    
    data2 <- aggregate(data$Transponder.Transactions, by = list(fips = data$fips, date = data$date), FUN = sum)
    colnames(data2) <- c("fips","date","transponders")
    
    data <- merge(data3, data2, by = c("fips", "date"))
    
    data <- merge(data, bls_emp, by.x = c("fips", "date"), by.y = c("area_fips","date"))
    data <- merge(data, housing, by.x = c("fips", "date"), by.y = c("fips","date"))
    tollroad <- merge(data, eia, by = "date")
    tollroad$date <- as.Date(paste0(substr(tollroad$date, 5, 6),"/1/",substr(tollroad$date, 1, 4)), "%m/%d/%Y")
    tollroad$year <- as.numeric(format(tollroad$date, "%Y"))
    tollroad <- tollroad[,c(1,8,2,3,4,5,6,7)]
    write.csv(tollroad, "/Users/jeff/Documents/Github/data-science/lecture-06/dataset/tollroad_ols.csv",row.names=F)
  
    