
#Data from: https://www.bls.gov/cew/datatoc.htm
  source("https://raw.githubusercontent.com/SigmaMonstR/qcew_unpack/master/qcew_unpack.R")
  
  dir <- "/Users/jeff/Downloads/"
  lists <- c("2016.q1-q2.by_area", "2012.q1-q4.by_area","2013.q1-q4.by_area",
            "2014.q1-q4.by_area","2015.q1-q4.by_area")
  
  output <- data.frame()
  for(k in lists){
    setwd(paste0(dir, k))
    files <- list.files(pattern = "*Maryland.csv")
    print(k)
    for(i in files){
      temp <- tot.emp(i)
      output <- rbind(output, temp)
      print(i)
    }
  }

  