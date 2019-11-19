# Chart 
# A bar graph shows the most popuplar neighborhood in Seattle.
library(dplyr)
library(plotly)


data <- read.csv("data/seattle_listings.csv", stringsAsFactors = FALSE)

bar_chart_function <- function(data) { 
  plot_info <- data %>%
  group_by(neighbourhood_group) %>%
  summarise(total = mean(price)) 
  
  plot <- plot_ly(plot_info,
                  x = ~neighbourhood_group) %>%
    add_trace(
      y = ~total,
      name = "Average Price",
      type = "bar"
    ) %>%
    
    layout(
      title = "Average Airbnb Price for Neighbourhoods in Seattle Visualization",
      xaxis = list(title = "Neighbourhoods"),
      yaxis = list(title = "Average Price")
    )
  return(plot)
  }