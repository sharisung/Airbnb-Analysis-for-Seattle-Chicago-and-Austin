library(shiny)
library(plotly)
library(dplyr)
library(tidyr)
library(leaflet)
library(ggplot2)
source("global.R")
introduction <- tabPanel(
"Introduction",
h1("Introduction for the Project"),
h3(" We wanted to provide a travel guide on ten major cities in the United States for travelers, so they could 
   figure out which airbnb listing they want to live in based on price, room type and the number of
   guests they have."),
h4("source of data collected: http://insideairbnb.com/get-the-data.html"),
img(src = "AirbnbLogo.jpeg", width="40%", height ="30%")
)

sea_map_sidebar_content <- sidebarPanel(
    numericInput(
        "sea_zip_input", #server
        label = "Input Zipcode",
        value = "Enter text..."
        ),
    radioButtons(
        "sea_input_property", #rhe
        label = "The type of property of the listing item",
        choices = c("House",
        "Guest suite",
        "Apartment",
        "Condominium"),
        selected = "Apartment"
    ),
    checkboxInput(
        "sea_superhost", #ffd
        label = "Superhosts?",
        value = FALSE,
    ),
    sliderInput(
        "sea_num_guests", #r
        label = "Number of Guests",
        min = 1,
        max = max(seattle$accommodates, na.rm = TRUE),
        value = 1,
        step = 1
    )
) 

sea_map_main_content <- mainPanel(
    leafletOutput("interactive_seattle")
)

sea_map_panel <- tabPanel(
    "interactive_seattle",
    titlePanel("Interactive Map of Seattle"),
    sidebarLayout(
        sea_map_sidebar_content,
        sea_map_main_content
    )
)

chi_map_sidebar_content <- sidebarPanel(
    numericInput(
        "chi_zip_input", #server
        label = "Input Zipcode",
        value = "Enter text..."
    ),
    radioButtons(
        "chi_input_property", #rhe
        label = "The type of property of the listing item",
        choices = c("House",
                    "Guest suite",
                    "Apartment",
                    "Condominium"),
        selected = "Apartment"
    ),
    checkboxInput(
        "chi_superhost", #ffd
        label = "Superhosts?",
        value = FALSE,
    ),
    sliderInput(
        "chi_num_guests", #r
        label = "Number of Guests",
        min = 1,
        max = max(chicago$accommodates, na.rm = TRUE),
        value = 1,
        step = 1
    )
) 

chi_map_main_content <- mainPanel(
    leafletOutput("interactive_chicago")
)

chi_map_panel <- tabPanel(
    "interactive_chicago",
    titlePanel("Interactive Map of Chicago"),
    sidebarLayout(
        chi_map_sidebar_content,
        chi_map_main_content
    )
)

aus_map_sidebar_content <- sidebarPanel(
    numericInput(
        "aus_zip_input", #server
        label = "Input Zipcode",
        value = "Enter text..."
    ),
    radioButtons(
        "aus_input_property", #rhe
        label = "The type of property of the listing item",
        choices = c("House",
                    "Guest suite",
                    "Apartment",
                    "Condominium"),
        selected = "Apartment"
    ),
    checkboxInput(
        "aus_superhost", #ffd
        label = "Superhosts?",
        value = FALSE,
    ),
    sliderInput(
        "aus_num_guests", #r
        label = "Number of Guests",
        min = 1,
        max = max(austin$accommodates, na.rm = TRUE),
        value = 1,
        step = 1
    )
) 

aus_map_main_content <- mainPanel(
    leafletOutput("interactive_austin")
)

aus_map_panel <- tabPanel(
    "interactive_austin",
    titlePanel("Interactive Map of Austin"),
    sidebarLayout(
        aus_map_sidebar_content,
        aus_map_main_content
    )
)

seattle_barchart_side <- sidebarPanel(
    checkboxGroupInput("sea_checkGroup",
                       label = h3("Select Neighbourhoods"),
                       choices = as.list(plot_info_seattle$neighbourhood_group_cleansed),
                       selected = "Downtown"))

seattle_bar_panel <- tabPanel (
    "Average Price In Neighbourhoods",
    titlePanel("Average Price For One Night In Different Neighbourhoods"),
    p("How does the average price in different neighbourhoods compare?
    This page will show a clear comparison wih selected neighbourhood groups"),
    seattle_barchart_side,
    mainPanel(plotlyOutput("sea_bar")),
    helpText(
        "If you compare the average price per night in different neighbourhoods, 
    you will find that Downtown Seattle has the highest average price pernight
    of 288 comparing against all other neighbourhoods.On the other hand, University
    District has the lowest average price per night of 104."
    ))



chicago_barchart_side <- sidebarPanel(
    checkboxGroupInput("chi_checkGroup",
                       label = h3("Select Neighbourhoods"),
                       choices = as.list(plot_info_chicago$neighbourhood_cleansed),
                       selected = "Uptown"))

chicago_bar_panel <- tabPanel (
    "Average Price In Neighbourhoods",
    titlePanel("Average Price For One Night In Different Neighbourhoods"),
    p("How does the average price in different neighbourhoods compare?
    This page will show a clear comparison wih selected neighbourhood groups"),
    chicago_barchart_side,
    mainPanel(plotlyOutput("chi_bar")))

austin_barchart_side <- sidebarPanel(
    checkboxGroupInput("aus_checkGroup",
                       label = h3("Select Neighbourhoods"),
                       choices = as.list(plot_info_austin$neighbourhood),
                       selected = "Downtown"))

austin_bar_panel <- tabPanel (
    "Average Price In Neighbourhoods",
    titlePanel("Average Price For One Night In Different Neighbourhoods"),
    p("How does the average price in different neighbourhoods compare?
    This page will show a clear comparison wih selected neighbourhood groups"),
    austin_barchart_side,
    mainPanel(plotlyOutput("aus_bar")))

ui <- navbarPage(
    "Airbnb Dataset",
    introduction,
    sea_map_panel,
    seattle_bar_panel,
    chi_map_panel,
    chicago_bar_panel,
    aus_map_panel,
    austin_bar_panel,
    tabPanel("Conclusion", mainPanel(uiOutput("conclusion")))
)

