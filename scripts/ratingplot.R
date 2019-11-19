setwd("/Users/Yash/Desktop/final-Jackzzzzz")
data <- read.csv("data/listings.csv", stringsAsFactors = FALSE)
library(ggplot2)
library(dplyr)
num_listings_by_neighbourhood <- function(data) {
  to_use <- data %>% 
    group_by(neighbourhood_cleansed) %>% 
    summarise(n = n())
  ggplot(data = to_use) + 
    geom_point(
      mapping = aes(x = to_use$neighbourhood_cleansed, y = n)
    )
}




