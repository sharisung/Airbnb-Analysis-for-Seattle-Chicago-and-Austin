# script for price filtering on map visualization

price_range <- sidebarPanel(
  sliderInput(
    "price_range",
    label = "Price Range",
    min = min(data),
    max = max(data),
    value = 250
  )
)
