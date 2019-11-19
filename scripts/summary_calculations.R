setwd("/Users/Yash/Desktop/final-Jackzzzzz")
data <- read.csv("data/listings.csv", stringsAsFactors = FALSE)
# A function that takes in a dataset and returns a list of info about it:
get_summary_info <- function(data) {
  # Number of airbnb hosts in the city
  total_hosts <- as.numeric(length(unique(data$host_id)))
  
  # Neighbourhood with most number of AirBnb listings
  most_popular_neighbourhood <- data %>% 
    group_by(neighbourhood_cleansed) %>% 
    summarise(n = n()) %>% 
    filter(n == max(n, na.rm = TRUE)) %>% 
    pull(neighbourhood_cleansed) %>% 
    as.character()
  
  # Most popular type of listing in the most popular neighbourhood 
  most_popular_property <- data %>% 
    filter(neighbourhood_cleansed == most_popular_neighbourhood) %>%
    group_by(property_type) %>% 
    summarise(n = n()) %>% 
    filter(n == max(n, na.rm = TRUE)) %>% 
    pull(property_type) %>% 
    as.character()
  
  # Average price in that neighbourhood
  average_price <- data %>% 
    mutate(price_val = as.numeric(substr(price, 2, length(price)))) %>% 
    filter(neighbourhood_cleansed == most_popular_neighbourhood) %>% 
    select(price_val) %>% 
    lapply(mean, na.rm = TRUE) %>% 
    as.numeric()
  
  # Average rating of that neighbourhood
  average_rating <- data %>% 
    filter(neighbourhood_cleansed == most_popular_neighbourhood) %>% 
    select(review_scores_rating) %>%
    lapply(mean, na.rm = TRUE) %>% 
    as.numeric()
  
  ret <- list(
    "Total listings" = total_hosts,
    "Neighbourhood with most listings" = most_popular_neighbourhood,
    "Most popular type of listing in the area" = most_popular_property,
    "Average price in the area" = average_price,
    "Average rating in the area" = average_rating
  )
  return (ret)
}
