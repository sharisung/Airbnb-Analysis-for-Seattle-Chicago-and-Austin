dataset <- read.csv("data/seattle_listings.csv", stringsAsFactors = FALSE)
library(ggplot2)
library(dplyr)
num_listings_by_neighbourhood <- function(dataset) {
  data_to_use <- dataset %>% 
    group_by(neighborhood_cleansed) %>% 
    summarise(n = n())
  ggplot(data = data_to_use) +
    geom_point(
      mapping = aes(x = neighborhood_cleansed, y = n)
    )
}
