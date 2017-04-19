############
#LECTURE 10#
############

##GOAL: Merge US and UK sanction lists to find overlaps

#Data obtained from:
##UK:https://www.gov.uk/government/publications/financial-sanctions-consolidated-list-of-targets/consolidated-list-of-targets
##US: http://2016.export.gov/ecr/eg_main_023148.asp
##Data used for lecture is pre-processed. See "scripts/prep-us-uk.R" for details 

#Working Drive
  setwd("/Users/jeff/Documents/Github/data-science/lecture-10/data")
  load("lec10.Rda")

#load library
##SQLDF is used to run SQL commands
  library(sqldf)

########
#SELECT#
########
#Get comfortable with sqldf
  
#Basic select: 1 field
  out <- sqldf('SELECT names 
                FROM us')
  head(out)

#Basic select: 2 fields
  out <- sqldf('SELECT names, dates_of_birth as DOB
                FROM us')

#Basic select: 3 fields but first 10 records
  out <- sqldf('SELECT names, dates_of_birth as dob, nationalities as nat 
               FROM us
               limit 10')

#Basic select: All fields, first 10 records
# The asterisk is the 'wildcard'
    out <- sqldf('SELECT *
                 FROM us
                 limit 10')
  
  #This is the equiv as head(elec, 10)
  out
  head(us, 10)

#Get unique people in US file
  out <- sqldf('SELECT DISTINCT person
               FROM us')

#Get unique people in US file after turning person name into lower case
  out <- sqldf('SELECT DISTINCT LOWER(person)
               FROM us')
  #command in R
  out2 <- unique(tolower(us$person))
  
#####################
#STRING MANIPULATION#
#####################
  
  #Check UK file
  sqldf('SELECT *
         FROM uk
         limit 3')
  
  #Concatenate example
  sqldf('SELECT "Name.6", "Name.1" 
         FROM uk
        LIMIT 3')
  
  sqldf('SELECT ("Name.6" || "Name.1" ) as name
         FROM uk
         LIMIT 3')
  
  #Concatenate to create full name 
  out <- sqldf('SELECT Nationality, ("Name.6" ||", " || "Name.1" ||" "|| "Name.2"  ||" "|| "Name.3"  ||" "|| "Name.4"  ||" "|| "Name.5") as name
         FROM uk')
  
  #Concatenate and lower the cases
  out <- sqldf('SELECT Nationality, LOWER("Name.6" ||", " || "Name.1" ||" "|| "Name.2"  ||" "|| "Name.3"  ||" "|| "Name.4"  ||" "|| "Name.5") as name
               FROM uk')

  #Create cleaned up UK file
  uk2 <- sqldf('SELECT Nationality, DOB, LOWER("Name.6" || ", " || "Name.1" ||" "|| "Name.2"  ||" "|| "Name.3"  ||" "|| "Name.4"  ||" "|| "Name.5") as names
               FROM uk') 
  
###########
#GROUP BY #
###########
#Group by is the equivalent to aggregate()
    
    
  #Unique list of person
    unique(us$person)
    out <- sqldf('SELECT person
                 FROM us
                 GROUP BY person')
    out
    
  #Count number of records per person
    agg <- aggregate(us$person, by = list(person = us$person), length)
    
    us.entities <- sqldf('SELECT person, COUNT(*) as count
                 FROM us
                 GROUP BY  person')

    uk.entities <- sqldf('SELECT "Group.ID" as person, COUNT(*) as count
                       FROM uk
                       GROUP BY  person')
    
##################
#  SUMMARY STATS #
##################
  
  #AVG: Get average number of entities per person
    sqldf('SELECT AVG(count) as avg
           FROM entities')
    
  #SUM: Get total number of electrical permits
    sqldf('SELECT SUM(count) as sum
           FROM entities')
    
  #SD: Get SD 
    sqldf('SELECT STDEV(count) as sd
           FROM entities')

  #Get all together as well as MIN and MAX
    sqldf('SELECT SUM(count) as sum, AVG(count) as avg, STDEV(count) as sd, MIN(count) as min, MAX(count) as max
          FROM entities')
    
    
##################
#  CONDITIONAL  #
##################
    
    #WHERE: Get Nationality like 'United States' from the UK list
    out <- sqldf('SELECT *
                  FROM uk2
                  WHERE Nationality like "%United States%"')
    
    #WHERE: Get Americans from UK list 
    out <- sqldf('SELECT *
                 FROM uk2
                 WHERE Nationality like "%United States%" OR Nationality like "%America%"')
    
    #COUNT WHERE: Count Americans from UK list 
    sqldf('SELECT count(*) count
           FROM uk2
           WHERE Nationality like "%United States%" OR Nationality like "%America%"')
    
    #COUNT WHERE: Count where nationality is missing
    sqldf('SELECT count(*) count
          FROM uk2
          WHERE Nationality == ""')

##########
#  JOIN  #
##########
# Same as merge()
    
  ##1) Get distinct names from both lists
    uk_out <- sqldf('SELECT DISTINCT LOWER(names) names, Nationality as uk_nat, count(*) uk_cnt
                        FROM uk2
                        GROUP BY LOWER(names)')
    uk_out$names <- trimws(uk_out$names)
    
    us_out <- sqldf('SELECT DISTINCT LOWER(names) names, nationalities as us_nat, count(*) us_cnt 
                        FROM us
                        GROUP BY LOWER(names)')

    
    #INNER JOIN summary tables together
    comb_out <- sqldf('SELECT us_out.names, us_out.us_nat, uk_out.uk_nat, us_out.us_cnt, uk_out.uk_cnt
                       FROM us_out
                       INNER JOIN uk_out ON us_out.names = uk_out.names')
    
##########
#  VISUALS  #
##########
    #Visuals
    library(VennDiagram)
    grid.newpage()
    draw.pairwise.venn(nrow(uk_out), nrow(us_out), nrow(comb_out), 
                       category = c("UK List", "US List"), 
                       fill = c("pink", "turquoise"), 
                       alpha = rep(0.5, 2),
                       cat.dist = rep(0.025, 1),cat.pos = rep(0.24,2) )
    
   
    #Frequency of multiples
    library(ggplot2)
    entities <- rbind(data.frame(source = "uk", uk.entities), data.frame(source = "us", us.entities))
    ggplot(entities, aes(x = count)) + 
      geom_density(aes(group = source, colour = source, fill = source), alpha = 0.4) + 
      scale_x_log10()
      
    #Barplot
    uk.blank <- sqldf('SELECT count(*) count
                    FROM uk2
                    WHERE Nationality == ""')
    us.blank <- sqldf('SELECT count(*) count
                    FROM us
                      WHERE nationalities == ""')
    
    dat <- data.frame(UK = c(uk.blank[1,1], nrow(uk)-uk.blank[1,1]),
                      US = c(us.blank[1,1], nrow(us)- us.blank[1,1]))
    barplot(as.matrix(dat), main = "Missing nationality data", col = c("pink","lightblue"))
    