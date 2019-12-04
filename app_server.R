library(shiny)
library(plotly)
library(dplyr)
library(tidyr)
library(leaflet)
library(ggplot2)
library(scales)
source("global.R")
data <- seattle_data %>% 
    mutate(
        price_val = as.numeric(substr(seattle_data$price, 2, length(seattle_data$price))),
        superhost_val = ifelse(seattle_data$host_is_superhost == "t", TRUE, FALSE)
        )

#seattle_big_listing <- read.csv("data/big_seattle_listings.csv",
                                #stringsAsFactors = FALSE)

#data <- read.csv("seattle_listings.csv", stringsAsFactors = FALSE)
plot_info <- data %>%
    group_by(neighbourhood_group_cleansed) %>%
    summarise(total = mean(price_val))

server <- function(input, output) {
    output$interactive_seattle <- renderLeaflet({
        map_filtered_data <- data %>%
        filter(property_type == input$input_property, 
               zipcode == input$zip_input,
               accommodates == input$num_guests,
               superhost_val == input$superhost,
               #price_val == input$price_range
               )        
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
     
    #Building Bar Chart
    select_neighbourhood <- reactive ({
        new_data <- plot_info %>%
            filter(neighbourhood_group_cleansed == input$checkGroup)
        return(new_data)
    })
    
    output$bar <- renderPlotly({
        bar_chart <- ggplot(select_neighbourhood()) +
            geom_col(mapping = aes(x = neighbourhood_group_cleansed,
                                   y = total)) +
            labs(x = "Neighbourhoods",
                 y = "Average Price Per Night",
                 title = "Comparing Average Price Per Night In Different Neighbourhoods") +
            scale_fill_manual(values = c("steelblue4", "steelblue4", "tan1",
                                         "khaki1"))
        ggplotly(bar_chart)
    })
    output$conclusion <- renderUI ({
        HTML(markdown::markdownToHTML(knit("conclusion.Rmd", quiet = TRUE)))
    })

}
