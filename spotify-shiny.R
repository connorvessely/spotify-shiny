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
#data_music = load("data-music.RData")


### ---- Define UI ----

## top 3/10/20 whatever vs all slider

## color by genre checkbox
## plot_ly
## four graphs: 
##  energy vs loudness 
##  acousticness vs speechiness 
##  tempo vs danceability 
##  boxplot popularity 

launch_editor(app_loc = "spotify_app")


### ---- Run app ----
shinyApp(ui, server)
