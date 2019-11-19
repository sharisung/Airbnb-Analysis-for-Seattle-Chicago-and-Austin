# Interactive Map
library(dplyr)
library(ggplot2)
library("plotly")
library(leaflet)
# Interactive Map
seattle_listing <- read.csv("data/seattle_listings.csv",
                            stringsAsFactors = FALSE)
interactive_map_function <- function(seattle_listing){
map <- leaflet(seattle_listing) %>%
    addTiles() %>%
    addProviderTiles("CartoDB.Positron") %>%
    addCircles(
        lat = ~latitude,
        lng = ~longitude,
        stroke = FALSE,
        popup = ~paste("Host name:", host_name, "<br>",
                       "Listing name:", name, "<br>",
                       "Price: $", price, "per night", "<br>",
                       "Room Type:", room_type, "<br>"),
        radius = ~0.5,
        fillOpacity = 0.5,
    )
}
