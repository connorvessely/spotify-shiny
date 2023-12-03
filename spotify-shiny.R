### Install and load necessary libraries
if (!requireNamespace("shiny", quietly = TRUE)) {
  install.packages("shiny")
}

### ----- Load packages ----

library(shiny)
library(tidyverse)

### ---- Define UI ----

# create vector of variable names
# -> take out the categorical variables
vars <- setdiff(names(iris), "Species")

ui <- fluidPage(
  
  titlePanel(title = "Shiny Iris Explorer App!"),
  
  sidebarPanel(
    
    # create dropdowns of variable names to plot
    selectInput(inputId = "yvar",
                label = "Choose Y Variable",
                choices = vars),
    selectInput(inputId = "xvar",
                label = "Choose X Variable",
                choices = vars,
                selected = vars[[2]]),
    
    # create checkbox to optionally color by a categorical variable
    checkboxInput(inputId = "species",
                  label = "Color by Species",
                  value = TRUE)
  ),
  
  # create spot for plot
  mainPanel(
    plotOutput(outputId = "plot1")
  )
)

### ---- Define server ----

server <- function(input, output) {
}

### ---- Run app ----
shinyApp(ui, server)
