### Intro to Data Science
### Quick introduction to ggplot for static visualizations

  library(ggplot2)
  library(dplyr)

  degrees <- read.csv("https://github.com/GeorgetownMcCourt/data-science/blob/master/lecture-11/All%20Degrees%20Data.csv")

### Part 1: Exploratory Data Anlysis ####

  hist(degrees$total.awarded.Female)

  plot(x = degrees$year, y = degrees$total.awarded.Female)


### Part 2: Visualizing a single category ####

  aerospace <- subset(degrees, discipline == "Aerospace Engineering")

  plot <- ggplot(aerospace, aes(x = year, y = female.ratio))
  plot

  plot <- plot + geom_line()
  plot

  plot <- plot + theme_classic()
  plot


### Part 3: Visualizign all categories ####

  plot <- ggplot(degrees, aes(x = year, y = female.ratio, color = discipline)) + 
            geom_line() +
            theme_classic()
  plot


### Part 4: Simplify! ####

  selected.degrees <- c("Aerospace Engineering", "Computer Science",
                        "Chemistry", "Health Technologies", "Law",
                        "Business and Management", "Psychology")

  degrees.small <- subset(degrees, discipline %in% selected.degrees)

  plot <- ggplot(degrees.small, aes(x = year, y = female.ratio, color = discipline)) +
          geom_line() + 
          theme_classic()
  plot


### Part 5: Add polish ####

  plot + ggtitle("Changes in STEM degree gender parity") +
    xlab("Graduating Year") +
    ylab("Percent of Bachelor Degrees awarded to Women")


### Part 6: Same data, different geoms ####

  plot <- ggplot(degrees.small, aes(x = year, y = female.ratio, color = discipline))

  plot + geom_point(aes(size = total.awarded.Female))
  # Note that the aes parameter is passed straight to the geom itself



### Part 7: Try some things out: the ever-famous iris dataset ####
  data(iris)
  summary(iris)
  
  plot(iris$Sepal.Length, iris$Sepal.Width)
  