library(shiny)
library(tidyverse)
library(shinyuieditor)
library(plotly)
library(gridlayout)
library(bslib)
library(dplyr)

load("data-music.RData")

slider_val <- 10

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


#create scatterplot
ggplot(data = artist_stats) + 
  geom_point(aes(x = energy,
                 y = loudness)) +
  labs(title = "Energy vs Loudness for Top Artists",
       x = "Energy Level",
       y = "Loudness")

#create boxplot
ggplot(data = top_five,
       aes(x = tempo)) +
  labs(title = "Top 5 Artists based on features",
       x = "Tempo") +
  geom_boxplot() + 
  facet_wrap(~artist_name,
             ncol = 1)