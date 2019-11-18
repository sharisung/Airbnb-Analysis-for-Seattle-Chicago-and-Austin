# Interactive Map

seattle_listing <- read.csv("data/seattle_listings.csv",stringsAsFactors = FALSE)
# interactive map
map <- leaflet(seattle_listing) %>%
    addTiles() %>%
    addProviderTiles("CartoDB.Positron") %>%
    addCircles(
        lat = ~latitude,
        lng = ~longitude,
        stroke = FALSE,
        popup = ~paste("Host name:", host_name, "<br>",
                       "Listing name:", name, "<br>",
                       "Price: $", price, "per night", "<br>",
                       "Room Type:", room_type, "<br>"),
        radius = ~0.5,
        fillOpacity = 0.5,
    )

# Create the points labeling UW on the graph
locations <- data.frame(
    label = c("University of Washington"),
    latitude = c(47.6553),
    longitude = c(-122.3035)
)

leaflet(data = locations) %>%
    addProviderTiles("CartoDB.Positron") %>%
    setView(lng = -122.3321, lat = 47.6062, zoom = 11) %>%
    addMarkers(
        lat = ~latitude,
        lng = ~ longitude,
        popup = ~label,
    )
