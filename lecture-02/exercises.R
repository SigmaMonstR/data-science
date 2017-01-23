set.seed(123)
data <- data.frame(month = seq(1,12,1),
                   quarter = c(rep(1,3),rep(2,3),rep(3,3),rep(4,3)),
                   rev_mil= round(sin(1:12)*100 +200 + rnorm(12,10,20)),
                   elec_k = round(sin((1:12)/5)*100 + rnorm(12,100,20)),
                   likes_k = round(runif(12)*300))


#