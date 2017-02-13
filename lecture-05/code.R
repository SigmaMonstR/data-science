# Code for Lecture 5

# Random number generator and R as a fancy calculator

# We will draw from the normal distribution 1,000 times to create X
X <- rnorm(1000)
head(X)
hist(X) # built in function for examining data


# check mean
mean(X)
summary(X)
quantile(X, .975) 
quantile(rnorm(1000000), .975) 
54634 * 565  # Use R as a calculator where there are random variables


# If you run this over and over, you will get different values, since the
# random vector is generated over and over again.
X.1 <- rnorm(1000)
X.2 <- rnorm(1000)

mean(X.1)
mean(X.2)


# Use the `set.seed()` function to peg the draws to the same seed.
set.seed(124)
X.1 <- rnorm(1000)

set.seed(124) # Note what happens if you comment out the second seed set.
X.2 <- rnorm(1000)

mean(X.1)
mean(X.2)


# Fancy graphs of normal distributions that are not standard normal; with
# different spreads, different deviations.
set.seed(124)
X <- rnorm(1000, 0, 1)

set.seed(124)
Y <- rnorm(1000, 0, 4)

labels.vec <- rep(c("X", "Y"), c(1000, 1000))
data <- data.frame(data=c(X, Y), labels=labels.vec)

library(ggplot2) # you may need to install
p <- ggplot(data, aes(x=data, fill=labels)) # play with parameters
p + geom_histogram(position="identity", binwidth=0.25, alpha=0.5)


# Calculate the variance of a transformed random variable
set.seed(124)
X <- rnorm(10000, 0, 1)

# can back out actual equation, or at least the intuition by adjusting the a
# and b parameters
T <- (2 * X) + 3  
labels.vec <- rep(c("X", "T"), c(10000, 10000))
data <- data.frame(data=c(X, T), labels=labels.vec)

p <- ggplot(data, aes(x=data, fill=labels))
p + geom_histogram(position="identity", binwidth=0.25, alpha=0.5)


# Equivalent to a calculator
sd(X)
sd(T)


### Impact assessment, understanding bias

# Getting some intuition by generating a data process.
N <- 5000; eps <- rnorm(N); u <- rnorm(N)
x1 <- runif(N); x2 <- runif(N); x3 <- runif(N)
D <- ifelse(2*(x1 + x2 + x3) + u > 4, 1, 0)
Y <- D + x1 + x2 + x3 + eps
summary(D); summary(Y)

