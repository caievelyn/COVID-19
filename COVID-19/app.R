
# Load libraries
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(tidyverse)
library(gganimate)
library(ggplot2)
library(leaflet)

# Load data
x <- read_rds("x.rds")

# Define UI for application
ui <- fluidPage(

    # Application title
    titlePanel("COVID-19 US Tracker"),
    
    # Create navbar
    navbarPage("",
               tabPanel("Interactive Map",
                        mainPanel(
                            leafletOutput("map"))
                        ),
               tabPanel("Explore the Data",
                        mainPanel(
                            plotOutput
                        )),
               tabPanel("Texas Trends",
                        mainPanel(
                            plotOutput
                        ))
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$map <- renderLeaflet({
        
        # Store object to call later
        m <- x %>%
            
            # Call leaflet
            leaflet() %>%
            
            # Add pre-styled tiles; this one clearly delineates the state lines
            # while maintaining visual appeal
            addProviderTiles("Stamen.Terrain") %>%
            
            # Set the automatic view so that the United States are fully in view
            setView(lng = -95, lat = 37.5, zoom = 3.5) %>%
            
            # Add circle markers that are blue for non-winners
            
            addCircleMarkers(radius = case_when(x$total_cases <= 10 ~ 1,
                                                TRUE ~ log(x$total_cases)),
                             
                             # Remove the stroke, which adds to the radius
                             
                             stroke = FALSE,
                             
                             # Specify the fill color as blue and opacity as a
                             # number between 0 and 1. I chose 0.45 as it allows you
                             # to see the higher concentration of contestants
                             # easily.
                             
                             fill = TRUE,
                             fillColor = "red",
                             fillOpacity = 0.38,
                             
                             # Create popups that contain the contestant's name,
                             # season number, and finish place.
                             
                             popup = paste(x$county, "<br>",
                                           "Total Cases: ", x$total_cases, "<br>",
                                           "Total Deaths: ", x$total_deaths))
        
        # Call leaflet object for display
        m
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
