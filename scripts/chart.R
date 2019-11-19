# Chart
# A bar graph shows the most popuplar neighborhood in Seattle.
library(dplyr)
library(plotly)

# load files
data <- read.csv("data/seattle_listings.csv", stringsAsFactors = FALSE)

# create the function
bar_chart_function <- function(data) {

  # information processing
  plot_info <- data %>%
    group_by(neighbourhood_group) %>%
    summarise(total = mean(price))

  # create plot with plotly
  plot <- plot_ly(plot_info,
                  x = ~neighbourhood_group) %>%
    add_trace(
      y = ~total,
      name = "Average Price",
      type = "bar"
    ) %>%

    layout(
      title =
        "Average Airbnb Price for Neighbourhoods in Seattle Visualization",
      xaxis = list(title = "Neighbourhoods"),
      yaxis = list(title = "Average Price")
    )
  return(plot)
}