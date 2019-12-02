library(shiny)
library(plotly)
library(dplyr)
library(tidyr)
library(leaflet)
library(ggplot2)

seattle_big_listing <- read.csv("data/big_seattle_listings.csv",
                                stringsAsFactors = FALSE)

server <- function(input, output) {
    output$interactive_seattle <-renderLeaflet({
        map_filtered_data <-seattle_big_listing %>%
        filter(property_type == input$input_property, zipcode == input$zip_input)        
        leaflet(map_filtered_data) %>%
        addTiles() %>%
        addProviderTiles("CartoDB.Positron") %>%
        addCircles(
            lat = ~latitude,
            lng = ~longitude,
            stroke = FALSE,
            popup = ~paste("Host name:", host_name, "<br>",
                           "Listing name:", name, "<br>",
                           "Price:", price, "per night", "<br>",
                           "Property type:", property_type, "<br>"),
            radius = ~30,
            fillOpacity = 0.5,
        )
    })
}



