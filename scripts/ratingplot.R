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
    ) + 
    theme(text = element_text(size=7), 
        axis.text.x = element_text(angle=90, hjust=1)) +
    labs(x = "Neighbourhood", y = "Number of Listings")
}
scatter_plot <- num_listings_by_neighbourhood(data)



