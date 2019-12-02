library(shiny)
library(plotly)
library(dplyr)
library(tidyr)
library(leaflet)
library(ggplot2)

map_sidebar_content <- sidebarPanel(
    numericInput(
        "zip_input",
        label = "Input Zipcode",
        value = "Enter text..."
        ),
    radioButtons(
    "input_property",
    label = "The type of property of the listing item",
    choices = c("House",
    "Guest suite",
    "Apartment",
    "Condominium"),
    selected = "Apartment"
    )
)

map_main_content <- mainPanel(
    leafletOutput("interactive_seattle")
)

map_panel <- tabPanel(
    "interactive_seattle",
    titlePanel("Interactive Map of Seattle"),
    sidebarLayout(
        map_sidebar_content,
        map_main_content
    )
)
ui <- navbarPage(
    "Airbnb Dataset",
    map_panel
)








