library(shiny)
library(plotly)
library(dplyr)
library(tidyr)
library(leaflet)
library(ggplot2)

introduction <- tabPanel(
"Introduction",
h1("Introduction for the Project"),
h3(" We wanted to provide a travel guide on ten major cities in the United States for travelers, so they could 
   figure out which airbnb listing they want to live in based on price, room type and the number of
   guests they have."),
h4("source of data collected: http://insideairbnb.com/get-the-data.html"),
img(src = "AirbnbLogo.jpeg", width="40%", height ="30%")
)

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

barchart_side <- sidebarPanel(
    checkboxGroupInput("checkGroup",
                       label = h3("Select Neighbourhoods"),
                       choices = as.list(plot_info$neighbourhood_group),
                       selected = "Downtown"))


bar_panel <- tabPanel (
    "Average Price In Neighbourhoods",
    titlePanel("Average Price For One Night In Different Neighbourhoods"),
    p("How does the average price in different neighbourhoods different?
    This page will show a clear comparison wih selected neighbourhood gorups."),
    barchart_side,
    mainPanel(plotlyOutput("bar")),
    helpText(
        "If you compare the average price per night in different neighbourhoods, 
    you will find that Downtown Seattle has the highest average price pernight
    of 288 comparing against all other neighbourhoods.On the other hand, University
    District has the lowest average price per night of 104."
    ))

ui <- navbarPage(
    "Airbnb Dataset",
    introduction,
    map_panel,
    bar_panel,
    tabPanel("Conclusion", mainPanel(uiOutput("conclusion")))
)

