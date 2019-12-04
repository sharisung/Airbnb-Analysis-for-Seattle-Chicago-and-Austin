library(shiny)
library(plotly)
library(dplyr)
library(tidyr)
library(leaflet)
library(ggplot2)
library(scales)
library(knitr)
source("global.R")

seattle_data <- seattle %>% 
    mutate(
        price_val = as.numeric(substr(seattle$price, 2, length(seattle$price))),
        superhost_val = ifelse(seattle$host_is_superhost == "t", TRUE, FALSE)
        )

chicago_data <- chicago %>% 
    mutate(
        price_val = as.numeric(substr(chicago$price, 2, length(chicago$price))),
        superhost_val = ifelse(chicago$host_is_superhost == "t", TRUE, FALSE)
    )

austin_data <- austin %>% 
    mutate(
        price_val = as.numeric(substr(austin$price, 2, length(austin$price))),
        superhost_val = ifelse(austin$host_is_superhost == "t", TRUE, FALSE)
    )   

plot_info_seattle <- seattle_data %>%
    group_by(neighbourhood_group_cleansed) %>%
    summarise(total_seattle = mean(price_val, na.rm = TRUE))

plot_info_chicago <- chicago_data %>%
    group_by(neighbourhood_cleansed) %>%
    summarise(total_chicago = mean(price_val, na.rm = TRUE))

plot_info_austin <- austin_data %>% 
    group_by(neighbourhood) %>% 
    summarise(total_austin = mean(price_val, na.rm = TRUE))

server <- function(input, output) {
    output$interactive_seattle <- renderLeaflet({
        sea_filtered_data <- seattle_data %>%
        filter(property_type == input$sea_input_property, 
               zipcode == input$sea_zip_input,
               accommodates == input$sea_num_guests,
               superhost_val == input$sea_superhost,
               )        
        leaflet(sea_filtered_data) %>%
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
    select_neighbourhood1 <- reactive ({
        new_data <- plot_info_seattle %>%
            filter(neighbourhood_group_cleansed == input$sea_checkGroup)
        return(new_data)
    })
    
    output$sea_bar <- renderPlotly({
        sea_bar_chart <- ggplot(select_neighbourhood1()) +
            geom_col(mapping = aes(x = neighbourhood_group_cleansed,
                                   y = total_seattle)) +
            labs(x = "Neighbourhoods",
                 y = "Average Price Per Night",
                 title = "Comparing Average Price Per Night In Different Neighbourhoods") +
            scale_fill_manual(values = c("steelblue4", "steelblue4", "tan1",
                                         "khaki1"))
        ggplotly(sea_bar_chart)
    })
    
    # Map for Chicago
    output$interactive_chicago <- renderLeaflet({
        chi_filtered_data <- chicago_data %>%
            filter(property_type == input$chi_input_property, 
                   zipcode == input$chi_zip_input,
                   accommodates == input$chi_num_guests,
                   superhost_val == input$chi_superhost,
            )        
        leaflet(chi_filtered_data) %>%
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
    
    #Building Bar Chart for Chicago
    select_neighbourhood2 <- reactive ({
        new_data <- plot_info_chicago %>%
            filter(neighbourhood_cleansed == input$chi_checkGroup)
        return(new_data)
    })
    
    output$chi_bar <- renderPlotly({
        chi_bar_chart <- ggplot(select_neighbourhood2()) +
            geom_col(mapping = aes(x = neighbourhood_cleansed,
                                   y = total_chicago)) +
            labs(x = "Neighbourhoods",
                 y = "Average Price Per Night",
                 title = "Comparing Average Price Per Night In Different Neighbourhoods") +
            scale_fill_manual(values = c("steelblue4", "steelblue4", "tan1",
                                         "khaki1"))
        ggplotly(chi_bar_chart)
    })
    
    # Map for Austin
    output$interactive_austin <- renderLeaflet({
        aus_filtered_data <- austin_data %>%
            filter(property_type == input$aus_input_property, 
                   zipcode == input$aus_zip_input,
                   accommodates == input$aus_num_guests,
                   superhost_val == input$aus_superhost,
            )        
        leaflet(aus_filtered_data) %>%
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
    
    # Bar Chart for Austin
    #Building Bar Chart for Seattle
    select_neighbourhood3 <- reactive ({
        new_data <- plot_info_austin %>%
            filter(neighbourhood == input$aus_checkGroup)
        return(new_data)
    })
    
    output$aus_bar <- renderPlotly({
        aus_bar_chart <- ggplot(select_neighbourhood3()) +
            geom_col(mapping = aes(x = neighbourhood,
                                   y = total_austin)) +
            labs(x = "Neighbourhoods",
                 y = "Average Price Per Night",
                 title = "Comparing Average Price Per Night In Different Neighbourhoods") +
            scale_fill_manual(values = c("steelblue4", "steelblue4", "tan1",
                                         "khaki1"))
        ggplotly(aus_bar_chart)
    })
    
    output$conclusion <- renderUI ({
        HTML(markdown::markdownToHTML(knit("conclusion.Rmd", quiet = TRUE)))
    })
}
