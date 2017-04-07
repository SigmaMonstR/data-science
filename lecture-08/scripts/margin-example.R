#Margin Example
margin_size <- 0.3
set.seed(123)
df <- data.frame(x = runif(200),
                 y = runif(200),
                 supports = NA)

#Set up margin supports
supports <- data.frame( x = c(0.6, 0.7, 0.7), y = NA, supports = NA)
supports$supports[1:2] <- -1.08 + 2*supports$x[1:2]
supports$supports[3] <- -.52 + 2*supports$x[3]

df <- rbind(df,
            supports)


#Best boundary
df$z <- -0.8 + df$x*2 
df$perp <- 0.6578033 + df$x*-0.5
df$perp[df$x >= 0.6951213] <- NA
df$perp[df$x <= 0.4711213] <- NA

#Cut out
df <- df[which((df$y > df$z + margin_size | df$y < df$z - margin_size | !is.na(df$supports))), ]
df$group <- "Side A"
df$group[df$y < df$z - margin_size] <- "Side B"
df$cols <- "blue"
df$cols[df$group == "Side B"] <- "green"


#Alternative boundaries
df$z1 <- -1.1 + df$x*2.1
df$z2 <- -0.5 + df$x*1.9
df$z3 <- -0.95 + df$x*2  
df$z4 <- -0.65 + df$x*2  
df$z5 <- -0.95 + df$x*2.3
df$z6 <- -0.65 + df$x*1.7

df$margin2 <- -1.08 + df$x*2
df$margin1 <- -.52 + df$x*2

df <- df[order(df$perp),]

#Plot
library(ggplot2)

base <- ggplot(df, aes(group=factor(group))) + 
  geom_point(aes(x = x, y = y,  colour = factor(group)))  +
  ylim(0,1) + xlim(0,1) + 
  ylab("x1") + xlab("x2") +
  ggtitle("(1)") + scale_colour_manual(values=c("lightblue", "lightgrey")) +
  coord_fixed(ratio = 1) +
  theme(plot.title = element_text(size = 10), 
        axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),axis.ticks=element_blank(),
        legend.position="none",
        panel.background=element_blank(),panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),plot.background=element_blank(),
        plot.margin=unit(c(-0.5,1,1,1), "cm"))

options1 <- ggplot(df) + 
  geom_point(aes(x = x, y = y, colour = df$cols)) +
  geom_line(aes(x = x, y = z), alpha = 0.5, colour = "grey") + 
  geom_line(aes(x = x, y = z1), alpha = 0.5, colour = "grey") + 
  geom_line(aes(x = x, y = z2), alpha = 0.5, colour = "grey") + 
  geom_line(aes(x = x, y = z3), alpha = 0.5, colour = "grey") + 
  geom_line(aes(x = x, y = z4), alpha = 0.5, colour = "grey") + 
  geom_line(aes(x = x, y = z5), alpha = 0.5, colour = "grey") + 
  geom_line(aes(x = x, y = z6), alpha = 0.5, colour = "grey") + 
  ylim(0,1) + xlim(0,1) +
  ggtitle("(2)") +  scale_colour_manual(values=c("lightblue", "lightgrey")) +
  coord_fixed(ratio = 1) + 
  ylab("x1") + xlab("x2") +
  theme(plot.title = element_text(size = 10), 
        axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),axis.ticks=element_blank(),
        legend.position="none",
        panel.background=element_blank(),panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),plot.background=element_blank(),
        plot.margin=unit(c(-0.5,1,1,1), "cm"))


optimal <- ggplot(df) + 
  geom_point(aes(x = x, y = y, colour = df$cols)) +
  geom_line(aes(x = x, y = z), size = 2, colour = "purple") + 
  geom_line(aes(x = x, y = margin1), size = 1, linetype="dashed", colour = "grey") + 
  geom_line(aes(x = x, y = margin2), size = 1, linetype="dashed", colour = "grey") + 
  geom_line(aes(x = x, y = perp), size = 1, colour = "blue") + 
  ylim(0,1) + xlim(0,1) + 
  ylab("x1") + xlab("x2") +
  ggtitle("(3)") +  scale_colour_manual(values=c("lightblue", "lightgrey")) +
  coord_fixed(ratio = 1) +
  theme(plot.title = element_text(size = 10), 
        axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),axis.ticks=element_blank(),
        legend.position="none",
        panel.background=element_blank(),panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),plot.background=element_blank(),
        plot.margin=unit(c(-0.5,1,1,1), "cm")) + 
  annotate("text", x = .3, y = .4, label = "Margin", colour = "blue") + 
  annotate("text", x = .8, y = .2, label = "Hyperplane", colour = "purple") 


supports <- ggplot(df) + 
  geom_point(aes(x = x, y = y, colour = df$cols)) +
  geom_line(aes(x = x, y = z), size = 2, colour = "purple") + 
  geom_line(aes(x = x, y = margin1), size = 1, linetype="dashed", colour = "grey") + 
  geom_line(aes(x = x, y = margin2), size = 1, linetype="dashed", colour = "grey") +
  geom_point(aes(x = x, y = supports, colour = "red", size=0.7)) +
  ylim(0,1) + xlim(0,1) + 
  ylab("x1") + xlab("x2") +
  ggtitle("(4)") +  scale_colour_manual(values=c("lightblue", "lightgrey", "red")) +
  coord_fixed(ratio = 1) +theme_bw() +
  theme(plot.title = element_text(size = 10), 
        axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),axis.ticks=element_blank(),
        legend.position="none",
        panel.background=element_blank(),panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),plot.background=element_blank(),
        plot.margin=unit(c(-0.5,1,1,1), "cm")) 

library(gridExtra)
grid.arrange(base, options1, ncol = 2)
grid.arrange(optimal, supports, ncol = 2)