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
library(DT)
load("data-music.RData")
og_vars = colnames(data_music[,sapply(data_music,is.numeric)])
vars = character(length(og_vars))
for (i in seq_along(og_vars)) {
  vars[i] = str_to_title(og_vars[i])
}
columns <- setNames(og_vars, vars)

### ---- Define UI ----

ui <- grid_page(
  layout = c(
    "header",
    "area3 "
  ),
  row_sizes = c(
    "40px",
    "1fr"
  ),
  col_sizes = c(
    "1fr"
  ),
  gap_size = "1rem",
  grid_card_text(
    area = "header",
    content = "Spotify Popular Artists",
    alignment = "center",
    is_title = FALSE
  ),
  grid_card(
    area = "area3",
    card_body(
      tabsetPanel(
        nav_panel(
          title = "Scatter Plot Comparison",
          grid_container(
            layout = c(
              "area0 area1"
            ),
            row_sizes = c(
              "1fr"
            ),
            col_sizes = c(
              "0.48fr",
              "1.52fr"
            ),
            gap_size = "10px",
            grid_card(
              area = "area0",
              full_screen = TRUE,
              card_header("Controls"),
              card_body(
                sliderInput(
                  inputId = "nArtists",
                  label = "Top N Artists",
                  min = 10,
                  max = 100,
                  value = 20,
                  width = "100%",
                  step = 10
                ),
                selectInput(
                  inputId = "xVar",
                  label = "Select X Variable",
                  choices = columns
                ),
                selectInput(
                  inputId = "yVar",
                  label = "Select Y Variable",
                  choices = columns,
                  selected = columns
                ),
                checkboxInput(
                  inputId = "colorCheckbox",
                  label = "Color by genre",
                  value = FALSE
                )
              )
            ),
            grid_card(
              area = "area1",
              card_body(plotlyOutput(outputId = "plotScatter"))
            )
          )
        ),
        nav_panel(
          title = "Box Plot Comparison",
          grid_container(
            layout = c(
              "area0 area1"
            ),
            row_sizes = c(
              "1fr"
            ),
            col_sizes = c(
              "0.48fr",
              "1.52fr"
            ),
            gap_size = "10px",
            grid_card(
              area = "area0",
              full_screen = TRUE,
              card_header("Controls"),
              card_body(
                sliderInput(
                  inputId = "nArtists2",
                  label = "Top N Artists",
                  min = 10,
                  max = 100,
                  value = 20,
                  width = "100%",
                  step = 10
                ),
                selectInput(
                  inputId = "xVar2",
                  label = "Select Variable to Compare",
                  choices = columns
                ),
                checkboxInput(
                  inputId = "colorCheckbox2",
                  label = "Color by genre",
                  value = FALSE
                )
              )
            ),
            grid_card(
              area = "area1",
              card_body(plotlyOutput(outputId = "plotBox"))
            )
          )
        ),
        nav_panel(
          title = "Most Popular Artists",
          DTOutput(outputId = "myTable", width = "55%")
        )
      )
    )
  )
)

### ---- Define server ----

server <- function(input, output) {
  
  # decided not to filter yVar to exclude the selected xVar because it made it more difficult to use
  # since it recalculates it changes the other var without the user meaning to do so
  
  #calculate the mean of all numeric variables by genre and keep top n based on slider value # nolint: line_length_linter.
  artist_stats <- data_music %>% summarize(.by = artist_name,
                                           across(where(is.numeric), mean)) %>%
    arrange(-popularity) %>% 
    distinct(artist_name, .keep_all = TRUE)
  
  output$plotScatter <- renderPlotly({
    topNList <- artist_stats %>% head(input$nArtists)
    topN <- data_music %>% filter(artist_name %in% topNList$artist_name) %>% 
      distinct(track_name, .keep_all = TRUE)
    
    if (input$colorCheckbox == FALSE) {
      topN %>% plot_ly() %>% 
        add_markers(x = paste0("~", input$xVar) %>% as.formula,
                    y = paste0("~", input$yVar) %>% as.formula,
                    text = ~str_to_title(paste0(input$xVar,": ", get(input$xVar),"<br>", input$yVar,": ", get(input$yVar),"<br>genre: ", genre)),
                    ) %>%
        layout(title = str_to_title(paste0(input$xVar," and ",input$yVar, " comparison for ",input$nArtists,  " most popular artists")))
    }
    else{
      topN %>% plot_ly() %>% 
        add_markers(x = paste0("~", input$xVar) %>% as.formula,
                    y = paste0("~", input$yVar) %>% as.formula,
                    color = ~genre,
                    text = ~str_to_title(paste0(input$xVar,": ", get(input$xVar),"<br>", input$yVar,": ", get(input$yVar),"<br>genre: ", genre)),
        ) %>%
        layout(title = str_to_title(paste0(input$xVar," and ",input$yVar, " comparison for ",input$nArtists,  " most popular artists")))
      
    }
  })
  
  output$plotBox <- renderPlotly({
    topNList <- artist_stats %>% head(input$nArtists2)
    topN <- data_music %>% filter(artist_name %in% topNList$artist_name) %>% 
      distinct(track_name, .keep_all = TRUE)
    
    if (input$colorCheckbox2 == FALSE) {
      topN %>% plot_ly() %>%
        add_trace(x = paste0("~", input$xVar2) %>% as.formula, name = "all genres",
                  type = "box")%>%
        layout(title = str_to_title(paste0(input$xVar2," for ",input$nArtists2,  " most popular artists")))
    }
    else{
      topN %>% plot_ly() %>%
        add_trace(x = paste0("~", input$xVar2) %>% as.formula, color = ~genre, type = "box") %>%
        layout(title = str_to_title(paste0(input$xVar2," for ",input$nArtists2,  " most popular artists")))
    }
  })
  output$myTable = renderDT({
    artists <- artist_stats %>% select(c(artist_name,popularity))
    artists
  })
}



### ---- Run app ----
shinyApp(ui, server)

