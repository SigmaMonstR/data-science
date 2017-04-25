##########################
##LECTURE 12: EFFICIENCY ##
##########################

#Which is faster? lapply, for, or parallel processing?

#First, set up an example of image downloads from NASA GIBS API
nasaGIBS <- function(inputs){
  # Args:
  #     inputs should include:
  #       timeindex = time index in YYYYJJJ (Y = year, J is day of the year)
  #       extent = list of values of bounding box
  #       dims =  dimensions of width 
  #     
  
  require(jpeg) 
  url <- paste0("https://gibs.earthdata.nasa.gov/image-download?TIME=",
                inputs$timeindex, 
                "&extent=", paste(inputs$left, inputs$bottom, inputs$right, inputs$upper,sep=","),
                "&epsg=4326&layers=VIIRS_SNPP_CorrectedReflectance_TrueColor&opacities=1&worldfile=false&format=image/jpeg&",
                "width=",inputs$width,"&height=", round(inputs$width * abs(inputs$upper - inputs$bottom)/ abs(inputs$left - inputs$right) ))
  temp <- tempfile()
  download.file(url,  temp, mode = "wb")
  return(temp)
}

#How to use Example
  inputs = list(timeindex = 2017002,
                left = -83.81310347041976,
                bottom = 31.625676874986674,
                right = -72.47521284541976,
                upper = 40.133489374986674,
                width = 5000)
  example_out <- nasaGIBS(inputs)
  trans <- t(as.vector(example_out))
  
  #visualize
  library(grid)
  grid.raster(example_out)

#RANGE OF VALUES TO BE LOOPED
  dates <- expand.grid(year = seq(2013,2016,1), 
                        month = seq(1,12,1),
                        day = c(1, 14))
  date <- paste0(dates[,c(1,2,3)])
  example_list <- paste0(2017,sprintf("%03d", seq(1,70,7)))
  

#LAPPLY 
 


#FORLOOP



#FOREACH
  
