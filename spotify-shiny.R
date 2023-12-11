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


### ---- Define UI ----

## top 3/10/20 whatever vs all slider

## color by genre checkbox
## plot_ly

## tabs
## scatterplot with dropdown for x y
## boxplot for other features with another dropdown - checkbox for 'by genre'
## list of most popular artists - and their popularity stat
## popularity distribution for popular artists
## what makes you a top artist?

## for pres- talk about tables, etc demo

## with issues send email with R file

#launch_editor(app_loc = "spotify_app")

#test area here:
load("data-music.RData")

#create scatterplot
ggplot(data = data_music) + 
    geom_point(aes(x = energy,
                   y = loudness)) +
    labs(title = "Energy vs Loudness for Top Artists",
         x = "Energy Level",
         y = "Loudness")

#create boxplot
ggplot(data = ska_tempos,
       aes(x = tempo)) +
  labs(title = "Tempos of Ska Bands",
       x = "Tempo") +
  geom_boxplot() + #box plot graph
  facet_wrap(~popularity,
             ncol = 1)


### ---- Run app ----
#shinyApp(ui, server)
