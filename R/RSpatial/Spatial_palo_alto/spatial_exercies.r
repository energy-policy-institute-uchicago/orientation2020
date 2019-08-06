path <- '/Users/michaelcahana/Dropbox/epic_predoc_resources/epic_orientation/data/Spatial_palo_alto'

library(sf)
library(dplyr)
library(readr)
library(ggplot2)
library(mapview)
library(lubridate)
library(ggplot2)

palo_alto <- 
  +     file.path(path, "palo_alto.shp") %>%
  +     st_read(stringsAsFactors = F)

freeway <- 
  +     file.path(path, "freeway.shp") %>%
  +     st_read(stringsAsFactors = F)

palo_alto %>%
  +     ggplot() + 
  +     geom_sf() +
  +     geom_sf(data = freeway)

per_capita_map <-
  +     palo_alto %>%
  +     ggplot() +
  +     geom_sf(aes(fill = PrCpInc)) + 
  +     geom_sf(data=freeway) +
  +     theme_nothing()

palto_alto$dFreeway <- 
  st_distance(palo_alto, freeway) %>%
  apply(1, min)