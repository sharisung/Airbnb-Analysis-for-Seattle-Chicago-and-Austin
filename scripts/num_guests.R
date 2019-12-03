# Script for filtering type of house

guests <- sidebarPanel(
  sliderInput(
    "num_gusts",
    label = "Number of Guests",
    min = 0,
    max = max(data),
    value = 1
  )
) 