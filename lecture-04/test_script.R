
###Extract
str(acs)
colnames(acs)

var_list <- c("HICOV","RAC1P","MAR","SEX","ESR","CIT","AGEP","PINCP","POVPIP","WKHP","SCHL","DDRS","DEAR","DEYE")
df_extract <- acs[acs$AGEP>=16, var_list]

###Statistical check
summary(df_extract)

###Clean up
df_extract$hs <- 0
df_extract$hs[df_extract$SCHL>=21] <- 1

##Comparisons relative to target variable
prop.table(table(df_extract$hs, df_extract$HICOV),1)

# RAC1P		1	
# Recoded detailed race code
# 1 .White alone		
# 2 .Black or African American alone	
# 3 .American Indian alone		
# 4 .Alaska Native alone		
# 5 .American Indian and Alaska Native tribes specified; or American
# .Indian or Alaska Native, not specified and no other races
# 6 .Asian alone		
# 7 .Native Hawaiian and Other Pacific Islander alone
# 8 .Some Other Race alone		
# 9 .Two or More Races		
prop.table(table(df_extract$RAC1P, df_extract$HICOV),1)

# Employment status recode
# b .N/A (less than 16 years old)
# 1 .Civilian employed, at work
# 2 .Civilian employed, with a job but not at work
# 3 .Unemployed
# 4 .Armed forces, at work
# 5 .Armed forces, with a job but not at work
# 6 .Not in labor force
prop.table(table(df_extract$ESR, df_extract$HICOV),1)

#Marital status
#1 .Married
#2 .Widowed
#3 .Divorced
#4 .Separated
#5 .Never married or under 15 years old
prop.table(table(df_extract$MAR, df_extract$HICOV),1)


#Marital status
#1 .Married
#2 .Widowed
#3 .Divorced
#4 .Separated
#5 .Never married or under 15 years old
prop.table(table(df_extract$MAR, df_extract$HICOV),1)

ggplot(data=df_extract, aes(x=AGEP, y=log(PINCP), group = HICOV, colour = HICOV)) +
  geom_line() +
  geom_point( size=4, shape=21, fill="white")


df_extract$coverage <- NA
df_extract$coverage[df_extract$HICOV == 2] <- 1
df_extract$coverage[df_extract$HICOV == 1] <- 0

library(gridExtra)

p1 <- ggplot(df_extract, aes(x=AGEP, y=coverage))+
      geom_smooth()

p2 <-ggplot(df_extract, aes(x=log(PINCP), y=coverage))+
  geom_smooth()

p3 <- ggplot(df_extract, aes(x=WKHP, y=coverage))+
  geom_smooth()

p4 <-  ggplot(df_extract, aes(x=POVPIP, y=coverage))+
  geom_smooth()

grid.arrange(p1,p2,p3,p4, ncol=3)
