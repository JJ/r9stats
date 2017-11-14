library(mclust)
data <- read.csv("users-9jres.csv")
fit <- Mclust(data)
plot(fit) # plot results
summary(fit) # display the best model 
