# Classification Tree with rpart
library(rpart)
library(rattle)
library(rpart.plot)

temp <- tempfile()
download.file("https://www2.census.gov/programs-surveys/acs/data/pums/2015/1-Year/csv_pga.zip",temp, mode="wb")
unz <- unzip(temp, exdir=getwd())
df <- read.csv(unz[1])

df <- df[df$AGEP>=16,]
df$SCHL2[df$SCHL<16 ] <- "1 - Less than HS"
df$SCHL2[df$SCHL>=16 & df$SCHL<21] <- "2 - HS"
df$SCHL2[df$SCHL==21] <- "3 - Undergraduate Degree"
df$SCHL2[df$SCHL>21] <- "4 - Graduate Degree"

df$coverage <- NA
df$coverage[df$HICOV == 2] <- "No Coverage"
df$coverage[df$HICOV == 1] <- "Coverage"

df$CIT2 <- NA
df$CIT2[df$CIT != 5] <- "Citizen"
df$CIT2[df$CIT == 5] <- "Not citizen"

df$MAR2 <- NA
df$MAR2[df$MAR == 1] <- "Married"
df$MAR2[df$MAR == 2] <- "Widowed"
df$MAR2[df$MAR == 3] <- "Divorced"
df$MAR2[df$MAR == 4] <- "Separated"
df$MAR2[df$MAR == 5] <- "Never Married"



temp <- df[df$coverage=="Coverage",]
df_sub <- rbind(df[df$coverage=="No Coverage",], temp[sample(row.names(temp),sum(df$coverage == "No Coverage")),])
# grow tree 
fit <- rpart(factor(coverage) ~ AGEP+ factor(CIT2) +factor(MAR2)+ factor(SCHL2) +factor(RAC1P), method="class", data=df_sub)

tree.pred <- predict(fit, df_sub, type='class')
tab <- table(tree.pred, df_sub$coverage)
(tab[1] + tab[4])/nrow(df_sub)

# plot tree 
plot(fit, uniform=TRUE)
text(fit, use.n=TRUE, all=TRUE, cex=.5, pretty=0)

rpart.plot(fit,extra=104, box.palette="GnBu",
           branch.lty=3, shadow.col="gray", nn=TRUE)

