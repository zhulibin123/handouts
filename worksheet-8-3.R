# Libraries
library(...)
library(...)

# Data
species <- read.csv('data/species.csv', stringsAsFactors = FALSE)
surveys <- read.csv('data/animals.csv', na.strings = '', stringsAsFactors = FALSE)

# User Interface
in1 <- selectInput(inputId = 'pick_species',
                   label = 'Pick a species',
                   choices = unique(species[['id']]))
...
tab <- tabPanel(title = 'Species', in1, ...)
ui <- navbarPage(title = 'Portal Project', tab)

# Server
server <- function(input, output) {
  output[['species_plot']] <- renderPlot(
    ...
  )
}

# Create the Shiny App
shinyApp(ui = ui, server = server)
