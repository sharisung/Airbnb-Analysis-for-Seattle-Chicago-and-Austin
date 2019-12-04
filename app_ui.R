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
    ),
    checkboxInput(
        "superhost",
        label = "Superhosts?",
        value = FALSE,
    ),
    sliderInput(
        "num_guests",
        label = "Number of Guests",
        min = min(),
        max = 8, # how to link data file here
        value = 1
    ),
    sliderInput(
        "price_range",
        label = "Price Range per Night",
        min = min(data), # how to link data file here
        max = 2500,# how to link data file here
        value = 250
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
