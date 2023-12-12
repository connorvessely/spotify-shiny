### Install and load necessary libraries
if (!requireNamespace("shiny", quietly = TRUE)) {
  install.packages("shiny")
}

### ----- Load packages ----

library(shiny)
library(tidyverse)
library(shinyuieditor)
library(plotly)
library(gridlayout)
library(bslib)
library(dplyr)

load("data-music.RData")

# static version of slider control
slider_val <- 10

### ---- Define UI ----

ui <- grid_page(
  layout = c(
    "header  header ",
    "sidebar tabArea",
    ".       .      "
  ),
  row_sizes = c(
    "70px",
    "1.7fr",
    "0.3fr"
  ),
  col_sizes = c(
    "250px",
    "1fr"
  ),
  gap_size = "1rem",
  grid_card(
    area = "sidebar",
    card_header("Controls"),
    card_body(
      sliderInput(
        inputId = "topArtists",
        label = "Top N Artists",
        min = 1,
        max = 100,
        value = 20,
        width = "100%",
        step = 10
      ),
      checkboxInput(
        inputId = "colorCheckbox",
        label = "Color by genre",
        value = FALSE
      )
    )
  ),
  grid_card_text(
    area = "header",
    content = "Spotify Genre Comparison",
    alignment = "center",
    is_title = FALSE
  ),
  grid_card(
    area = "tabArea",
    card_body(
      tabsetPanel(
        nav_panel(
          title = "Feature Comparison",
          plotlyOutput(outputId = "plot-Scatter")
        ),
        nav_panel(
          title = "Top Artist Features",
          plotlyOutput(outputId = "plot-Box")
        )
      )
    )
  )
)

### ---- Define server ----

server <- function(input, output) {
  #use across to calculate the mean of all numeric variables by genre and keep top n based on slider value
  artist_stats <- data_music %>% summarize(.by = artist_name,
                                           across(where(is.numeric), mean)) %>%
    arrange(-popularity) %>% 
    distinct(artist_name, .keep_all = TRUE) %>% 
    slice_head(n=slider_val)
  
  topFiveList <- artist_stats %>%
    head(5)
  
  
  #Grab top 5 artists for boxplot only
  top_five <- data_music %>% filter(artist_name %in% topFiveList$artist_name) %>% 
    distinct(track_name, .keep_all = TRUE)
  
  #Insert plotly scatter plot here
  output$plot-Scatter <- renderPlotly({
    plot_ly(z = ~volcano, type = "surface")
  })

  #Insert plotly boxplot here
  output$plot-Box <- renderPlotly({
    plot_ly(z = ~volcano, type = "surface")
  })
}

  
