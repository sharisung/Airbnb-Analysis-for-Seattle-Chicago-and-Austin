# Interactive Map
library(dplyr)
library(ggplot2)
library("plotly")
library(leaflet)
seattle_big_listing <- read.csv("data/big_seattle_listings.csv",
                                stringsAsFactors = FALSE)

# create the function
aggregated_function <- function(seattle_big_listing) {
best_hosts_near_pike <-
    seattle_big_listing %>%
    filter(host_is_superhost == "t",
           host_response_rate == "100%",
           host_response_time == "within an hour",
           host_identity_verified == "t",
           host_has_profile_pic == "t",
           zipcode == "98101") %>%
    top_n(15, wt = review_scores_rating) %>%
    arrange(-review_scores_rating) %>%
    select(host_name, name, review_scores_rating)
}
