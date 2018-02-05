#################################
#Examples of plots using ggplot2#
#################################

#Create data
  n <- 1000
  df <- data.frame(y = 1:n)
  df$x <- df$y  - 0.01*df$y^2 + rnorm(n, 0, 500)

#Import library
  library(ggplot2)

##Scatter plot
  p = ggplot(df,aes(x = x,y = y))  +
    xlab("x") +
    ylab("y")
  p1 = p + geom_point() + ggtitle("scatter")
  p2 = p + geom_point(alpha = 0.1, colour="navy") +
      theme_bw() + ggtitle("scatter (alpha = 0.1)")

##Hexbin
  p3 = p +
    stat_bin_hex(colour = "white", na.rm = TRUE, alpha = 0.9) +
    scale_fill_gradientn(colours=c("lightgrey","navy"), 
                         name = "Frequency", na.value = NA) + 
    guides(fill=FALSE) + 
    ggtitle("hexbin")

#Scatter by Group
p4  = ggplot(df,aes(x = x, y = y, 
                    colour = as.factor(round(x*10,1)*20))) +
      ggtitle("scatter by group") + 
      theme(legend.position="none") +
      geom_point(alpha = 0.3)

p5  = p + ggtitle("contour")+ 
      geom_density2d() + 
      theme_bw()

p6 = ggplot(df, aes(x = x, y = y)) + 
      ggtitle("scatter + regression line")+
      geom_point(shape = 1,alpha = 0.6, colour="navy") + 
      geom_smooth()    

#Put all graphs onto one canvas
  grid.arrange(p1,p2,p3,p4,p5,p6, ncol=3)
 