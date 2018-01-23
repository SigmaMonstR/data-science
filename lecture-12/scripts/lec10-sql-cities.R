############
#LECTURE 10#
############

#"https://data.sfgov.org/Housing-and-Buildings/Electrical-Permits/ftty-kx6y"
#"https://data.sfgov.org/Housing-and-Buildings/Plumbing-Permits/a6aw-rudh"

#WD
  setwd("/Users/jeff/Documents/Github/data-science/lecture-10/data")
  elec <- read.csv("Electrical_Permits.csv")
  plumb <- read.csv("Plumbing_Permits.csv")

#load library
  library(sqldf)

########
#SELECT#
########

#Basic select: 1 field
  out <- sqldf('SELECT Block 
                FROM elec')

#Basic select: 3 fields
  out <- sqldf('SELECT Block, Lot, "Permit.Number" as permitNumber 
                FROM elec')

#Basic select: 3 fields but first 10 records
  out <- sqldf('SELECT Block, Lot, "Permit.Number" as permitNumber
               FROM elec
               limit 10')

#Basic select: All fields, first 10 records
# The asterisk is the 'wildcard'
    out <- sqldf('SELECT *
                 FROM elec
                 limit 10')
  
  #This is the equiv as head(elec, 10)
  out
  head(elec, 10)
  
  
###########
#GROUP BY #
###########
#Group by is the equivalent to aggregate()
    
  #Unique list of Block and Lot
    out <- sqldf('SELECT Zipcode
                 FROM elec
                 GROUP BY  Zipcode')
    out
    
  
  #Count number of records in each zipcode
    out <- sqldf('SELECT Zipcode, COUNT(*) as count
                 FROM elec
                 GROUP BY  Zipcode')
    out
    
  #Count Block and Lot
    results <- sqldf('SELECT Zipcode, Block, Lot, COUNT(*) as count
                 FROM elec
                 GROUP BY  Zipcode, Block, Lot')
    results
    
    
##################
#  SUMMARY STATS #
##################
  
  #AVG: Get average number of electrical permits
    sqldf('SELECT AVG(count) as avg
           FROM results')
    
  #SUM: Get total number of electrical permits
    sqldf('SELECT SUM(count) as sum
           FROM results')
    
  #SD: Get SD 
    sqldf('SELECT STDEV(count) as sd
           FROM results')

  #Get all together as well as MIN and MAX
    sqldf('SELECT SUM(count) as sum, AVG(count) as avg, STDEV(count) as sd, MIN(count) as min, MAX(count) as max
          FROM results')
    
  #Get all together  by zipcode
    sqldf('SELECT Zipcode, SUM(count) as sum, AVG(count) as avg, STDEV(count) as sd, MIN(count) as min, MAX(count) as max
          FROM results
          GROUP BY Zipcode') 
    
    
##################
#  CONDITIONAL  #
##################
    
    #WHERE: Get only records in zipcode 94102 
    out <- sqldf('SELECT *
                  FROM elec
                  WHERE Zipcode = 94102')
    
    #WHERE: Get only records in zipcode 94102, 94127, 94109
    out <- sqldf('SELECT *
                 FROM elec
                 WHERE Zipcode IN (94102, 94127, 94109)')
    
    #COUNT WHERE: Count records in zipcode list of 94102, 94127, 94109
    sqldf('SELECT count(*) count
           FROM elec
           WHERE Zipcode IN (94102, 94127, 94109)')
    
    #COUNT WHERE: Count records < 94127
    sqldf('SELECT count(*) count
          FROM elec
          WHERE Zipcode > 94127')
    
    #WHERE: Two conditions - Zipcode 9419 and Status is complete
    out <- sqldf('SELECT *
                  FROM elec
                  WHERE Zipcode = 94109 AND Status = "complete"')

##########
#  JOIN  #
##########
# Same as merge()
    
  ##1) Join two aggregate tables
    #Pre-Prep
    elec_out <- sqldf('SELECT Zipcode, count(*) elec_cnt
                        FROM elec
                        GROUP BY Zipcode')
    plumb_out <- sqldf('SELECT Zipcode, count(*) plumb_cnt 
                        FROM plumb
                        GROUP BY Zipcode')
    
    #INNER JOIN summary tables together
    comb_out <- sqldf('SELECT elec_out.Zipcode, elec_out.elec_cnt, plumb_out.plumb_cnt
                       FROM elec_out
                       INNER JOIN plumb_out ON elec_out.Zipcode = plumb_out.Zipcode')
    
   
    
    