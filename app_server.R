library(shiny)
library(plotly)
library(dplyr)
library(tidyr)
library(leaflet)
library(ggplot2)
library(scales)
library(knitr)
source("global.R")


data_seattle <- seattle_data %>% 
    mutate(
        price_val = as.numeric(substr(seattle_data$price, 2, length(seattle_data$price))),
        superhost_val = ifelse(seattle_data$host_is_superhost == "t", TRUE, FALSE)
        )

data_chicago <- chicago_data %>% 
    mutate(
        price_val_chicago = as.numeric(substr(chicago_data$price, 2, length(seattle_data$price))),
        superhost_val = ifelse(chicago_data$host_is_superhost == "t", TRUE, FALSE)
    )

plot_info <- data_seattle %>%
    group_by(neighbourhood_group_cleansed) %>%
    summarise(total = mean(price_val))

plot_info_chicago <- data_chicago %>%
    group_by(neighbourhood_cleansed) %>%
    summarise(total_chicago = mean(price_val_chicago))

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
     
    #Building Bar Chart for Seattle
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
    
    # Build Bar Chart for Chicago
    select_neighbourhood_chicago <- reactive ({
        new_data_chicago <- plot_info_chicago %>%
            filter(neighbourhood_cleansed == input$checkGroup_Chicago)
        return(new_data_chicago)
    })
    
    output$bar_chicago <- renderPlotly({
        bar_chart_chicago <- ggplot(select_neighbourhood_chicago()) +
            geom_col(mapping = aes(x = neighbourhood_cleansed,
                                   y = total_chicago)) +
            labs(x = "Neighbourhoods",
                 y = "Average Price Per Night",
                 title = "Comparing Average Price Per Night In Different Neighbourhoods") +
            scale_fill_manual(values = c("steelblue4", "steelblue4", "tan1",
                                         "khaki1"))
        ggplotly(bar_chart_chicago)
    })
    output$conclusion <- renderUI ({
        HTML(markdown::markdownToHTML(knit("conclusion.Rmd", quiet = TRUE)))
    })
}
