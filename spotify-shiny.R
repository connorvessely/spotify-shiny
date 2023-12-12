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
## EXTRA - list of most popular artists - and their popularity stat
## what makes you a top artist?

## for pres- talk about tables, etc demo

## with issues send email with R file

launch_editor(app_loc = "spotify_app")

#test area here


### ---- Run app ----
shinyApp(ui, server)
