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
data_music = load("data-music.RData")
head(data_music)


### ---- Define UI ----

ui <- grid_page(
  layout = c(
    "header  header  ",
    "sidebar plotGrid",
    ".       .       "
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
    area = "plotGrid",
    card_body(
      grid_container(
        layout = c(
          "plot1 plot2",
          "plot3 plot4"
        ),
        row_sizes = c(
          "1fr",
          "1fr"
        ),
        col_sizes = c(
          "1fr",
          "1fr"
        ),
        gap_size = "10px",
        grid_card(
          area = "plot1",
          card_body(plotlyOutput(outputId = "plotOutput1"))
        ),
        grid_card(
          area = "plot2",
          card_body(plotlyOutput(outputId = "plotOutput2"))
        ),
        grid_card(
          area = "plot3",
          card_body(plotlyOutput(outputId = "plotOutput3"))
        ),
        grid_card(
          area = "plot4",
          card_body(plotlyOutput(outputId = "plotOutput4"))
        )
      )
    )
  )
)

### ---- Define server ----

server <- function(input, output) {
  #Keep the top N number of artists based on the slider in order of popularity
  ####couldn't get this code to work!
  #numArtists <- input$topArtists
  #chosenArtists <- data_music %>% 
    #arrange(-popularity) %>% 
    #distinct(artist, .keep_all = TRUE) %>% 
    #head(numArtists)
  
  output$plotOutput1 <- renderPlot({
    ggplot(data = data_music) + 
      geom_point(aes(x = energy,
                     y = loudness)) +
      labs(title = "Energy vs Loudness for Top Artists", #descriptive labels
           x = "Energy Level",
           y = "Loudness")
  })
  
  output$plotOutput2 <- renderPlot({
    ggplot(data = data_music) + 
      geom_point(aes(x = energy,
                     y = loudness)) +
      labs(title = "Energy vs Loudness for Top Artists", #descriptive labels
           x = "Energy Level",
           y = "Loudness")
  })
  
  output$plotOutput3 <- renderPlot({
    ggplot(data = data_music) + 
      geom_point(aes(x = energy,
                     y = loudness)) +
      labs(title = "Energy vs Loudness for Top Artists", #descriptive labels
           x = "Energy Level",
           y = "Loudness")
  })
  
  output$plotOutput4 <- renderPlot({
    ggplot(data = data_music) + 
      geom_point(aes(x = energy,
                     y = loudness)) +
      labs(title = "Energy vs Loudness for Top Artists", #descriptive labels
           x = "Energy Level",
           y = "Loudness")
  })
}
### ---- Run app ----
shinyApp(ui, server)
