# script for super hosts showing on map
superhosts <- sidebarPanel(
   checkboxInput(
     "superhosts",
     label = "Superhosts?",
     value = FALSE,
   )
)





# in server:
# if (superhosts = TRUE) {
#   df <- filter(mapdata, superhosts == TRUE)
# }