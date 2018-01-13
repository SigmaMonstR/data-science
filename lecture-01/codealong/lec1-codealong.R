#################################
##Fundamentals of R programming##
#################################

#Lecture 1

# Use carrots to assign values

  people <- 10 #Set x as a single value
  print(people)
  
  #string
  people <- "people"
  
  #FACTOR
  people <- factor("people")
  
  #BOOLEAN
  people <- FALSE
  
  #DATES
  people <- as.Date("12/6/2016","%m/%d/%Y")


# VECTORS
  people <- c(134, 542, 324, 102, 402, 383, 853) #set x as a vector
  print(people)
  asd <- c(1,2,3)
  
# PASTE
  tot_people <- sum(people) #Sum of x
  num_offices <- length(people) #count number of elements
  units1 <- "satisfied constituents served" #string variable
  units2 <- "field offices!" #another string variable
  
  statement <- paste(tot_people, units1, "in", num_offices, units2, sep = " llama ")
  print(statement)


# NUMERIC or ARITHMETIC operators

  4 + 2  #Addition
  4 - 2  #Substraction
  4 * 2  #Multiplication
  4 / 2  #Division
  4 ** 2 #Exponent
  4 %% 2 #Modulus 

##################
# Quick Exercise #
##################
# (1) Using the `people` and `units` variables, write a print statement that
# provides the average number of people served.
# (2) What would the total number of staff be if doubled? How about halved?

# Double
  doubled <- people * 2
  print(doubled)

# Half
  halved <- people / 2
  print(halved)


#######################
## LOGICAL OPERATORS ###
#######################
# Let's say that you need to  flag values based on specific values or specific thresholds. 
# This task would require the use of logical operators, which evaluate a statement and return 
# a boolean that indicates if a statement is `TRUE`. Below, we compare two quantities: `y` and `x`
  
  x <- 10
  y <- 2
  
  x > y   #4 is greater than 2
  x >= y  #4 greater than or equal to 2
  
  x < y   #4 is less than 2 
  x <= y  #4 less than or equal to 2
  
  x != y  #4 is not equal to 2
  x == y  #4 is equal to 2


#Using the operators, we can also see how many elements in a vector meet a specific criterion. 
#For example, to flag which records in `people` are over 200, we can do the following:
  above <- people>200
  print(above)

# Notice that the logical operator returned a vector that evaluate the statement for 
# each element in `people`. To see the split of `TRUE` vs. `FALSE`, we an use the `table()` 
# function to tabulate the number of records in each unique data value. 
  table(above)

#####################
###Data Structures###
#####################
# Data structures are ways to store data in an efficient and usable manner within the R programming environment. 
# These differ from data storage formats (e.g. CSV, JSON), which are widely used 
# regardless of programming language. Each data structure is designed with different functions 
# in mind and make certain tasks more efficient. In this section, we'll cover vectors, lists,
# matrices, and data frames. 

# VECTORS
# As mentioned previously, *vectors* are sequences of data elements of the 
# same data type. Below, there are three vectors: `cities` is a string vector whereas `pop` and 
# `area` are numeric vectors.

  cities <- c("New York","Los Angeles","Chicago","Houston","Philadelphia")
  pop <- c(8175133, 3792621, 2695598, 2100263, 1526006)
  area <- c(302.6, 468.7, 227.6, 599.6, 134.1)


# Index positions: Each element in a vector can be extracted based on its position in the vector
# Index start from 1 until lenght(vector)
# Example: Extract the first elemtn in each of the above vectors
  cities[1]
  pop[1]
  area[1]


# Using the index values to extract values is quite useful and can be combined in many ways:
# Obtain first and fourth cities
  cities[c(1,4)]

#Obtain the third through fifth cities
  cities[3:6]

##**EXERCISE**: How to get cities with populations of > 2 million



# MATRICES
#Vectors can be combined into into a *matrix* using `cbind()`. 
#Matrices are data elements arranged into a `n` row by `m` column rectangular layout that allow 
#for easier multi-dimensional data manipulation. Note that all data elements, regardless of the 
#location in a matrix, are of the same data type (e.g. numeric, string, boolean) and take on the 
#data type of the first column of data unless specified otherwise.
  mat <- cbind(cities, pop, area)

#Extract first row
  mat[1,]

#Extract second column
  mat[,2]

#Extract 2nd to 3rd rows and the 1st and 3rd column
mat[2:3,c(1,3)]

# Data frames
#If a dataset will have more than one data type, consider using data frames. To create a data frame, use the `data.frame()` to put two or more vectors together. 

  df <- data.frame(city = cities, 
                   population = pop, 
                   area = area)

#Being able to call a variable by name using the compact $ operator
    df$city
    df$population

#Check column names
  colnames(df)

#Reassign column names using a vector of 
  colnames(df) <- c("city_name","pop","area")

#Create a new boolean variable for populations greater than 2.5m and store into data frame
  df$over_2m <- df$pop > 2500000

#View results
  print(df)

#If there is a existing matrix object, `as.data.frame()` an be used to convert the objet into a data frame. However, this method will preserve the uniform data type of the matrix, which would require manually setting the data type for each variable.

new_df <- as.data.frame(mat)


#####Other helpful tips
#We can check the structure of any data object in R using the `str()` method, which returns the following for a given data object:
#- the data format if vector, or class if matrix or data frame
#- dimensions of the data: number of rows if vector, matrix dimensions [rows, columns], or number of variables and rows if data frames
#- the first 5 values of the object along with the data format

#vector
  str(cities)
  str(pop)

#matrix
  str(mat)

#data frame
  str(df)


#Other tools include `dim()`, `class()`, and `typeof()`, which provide the object dimensions, the class of data object and the type of data objet, respectively. These are handy for understanding basic attributes of any data and can inform the architecture of your data science approach.
  dim(df)
  class(df)
  typeof(df)

##################
### Libraries ###
##################
#While R comes pre-packaged with a lot of basic functionality as described above, it is often necessary to install and load code libraries that contain higher-level functionality. As R is an open source language, anyone can write and contribute code libraries for general public use. In fact, as of Dec 2016, there are 9,749 contributed packages on the [Comprehensive R Archive Network (CRAN)](https://cran.r-project.org). Some of the most used libraries include:
# - ggplot2 -- a graphing visualization library
# - dplyr -- a data manipulation and processing library
# - caret -- a multifaceted machine learning library
# - stringr -- a library for character or string processing
# - lubridate -- a library to handle date data
# - sqldf -- a library to write SQL code

###Install and load
# To start, we will install, load and demonstrate how to use *ggplot2*. Installation is simple enough, using the `install.packages()` method:

  install.packages("ggplot2")

#To use the library, use `library()` to load *ggplot2*.

  library(ggplot2)

#Upon doing so, all is needed is the data in the right form and a basic understanding of ggplot2 syntax ([take a look here](http://docs.ggplot2.org/current/)).

##################
###An easy demo###
##################
  
#For an initial demo, we will learn to load in a Comma Separated Values (CSV) file containing energy data from the [National Institute of Standards and Technology Net Zero Residential Test Facility](https://pages.nist.gov/netzero) -- a laboratory that produces as much energy as it uses and is a testbed for sustainable and efficient home technologies. The specific dataset that will be used is the hourly photovoltaic sensor dataset [https://s3.amazonaws.com/net-zero/2015-data-files/PV-hour.csv](https://s3.amazonaws.com/net-zero/2015-data-files/PV-hour.csv), which contains hourly estimates of solar energy production and exposure on the Net Zero home's solar panels. From a sustainability perspective, this data can eventually be used to inform home efficiency policies, solar panel siting, among other things. Our goal in this demonstration is to plot sun exposure by month to see the relative differences. 
#To start, we'll use the `read.csv()` function to import the object at the `url` destination that contains the the CSV dataset and assign the resulting dataframe to the object `df`.

  url <- "https://s3.amazonaws.com/nist-netzero/2015-data-files/PV-hour.csv"
  df <- read.csv(url)

#With the dataset imported, we will now check the data by using `head()` to print the first three lines of data, `colnames()` to see the names of all variables, and `str()` to look at the data structure.
  head(df,3)
  str(df)


#Based on initial examination, the dataset contains 34 variables with over 8,000 observations where *Timestamp* is the only date variable. However, while the variable contains information on dates, R treats the *Timestamp* as a factor. In order to accomplish the goal of this demo, we would need to: 
#(1) convert the *Timestamp* variable into a date-time object using `strptime()`, which requires the user to identify the date pattern so that R can extract the right information. In the case of the PV data, the format is in "%Y-%m-%d %H:%M:%S" or "Year-Month-Day Hour:Minute:Second". 
#(2) extract the month from the date object using `format()`, which only requires the date object and the desired output format. In this case, the output format is "%m"

  df$Timestamp <- strptime(df$Timestamp, "%Y-%m-%d %H:%M:%S")
  df$month <- format(df$Timestamp, "%m")

#Upon doing so, we can now graph the data. Of particular relevance to our analysis is the *PV_PVInsolationHArray* variable that contains an estimate of amount of sunlight that impacting the solar array during the last hour. R has a number of rudimentary graphing capabilities such as `plot()`, which accepts two vectors of data and renders a scatter plot. Below, `plot()` outputs a scatter plot where *month* is the x or horizontal axis variable and *PV_PVInsolationHArray* as the y or vertical axis variable.
  plot(df$month,df$PV_PVInsolationHArray)

#The result is not particularly compelling or meaningful as the points are too many and too dense to discern a pattern. The graph could use use style enhancements. Perhaps boxplot would be more suitable to summarize the shape of the PV distribution for each month.
#Enter *ggplot2*.

  library(ggplot2)

#Upon loading the *ggplot2* library, we can quickly get to work. The bare minimum syntax to render a stylized boxplot:

  print('ggplot([dataframe goes here], aes([x value here], [y value here])) + 
        geom_boxplot(colour = "[colour]", fill = "[colour]")')


#Putting this into action yields the following:

  ggplot(df, aes(factor(month),PV_PVInsolationHArray)) + 
  geom_boxplot(colour = "grey", fill = "navy")  

#From this graph, we can see the peak sunlight months are between May and August where May and August. 
#The third quartile (the upper end of each box) is protracted in May and August, indicating that there 
#are hourly periods where the light is more intense during those months. 

