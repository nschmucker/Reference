# SETUP        #### #### #### #### #### ####
library(dplyr)
library(httr)
library(htmltools)
library(sf)
library(leaflet)

set.seed(1776)

# LOAD DATA    #### #### #### #### #### ####
## ## Simple features data: Philadelphia neighborhoods
# Source: OpenDataPhilly. https://www.opendataphilly.org/dataset/philadelphia-neighborhoods
neighborhoods_geojson <- "https://raw.githubusercontent.com/azavea/geo-data/master/Neighborhoods_Philadelphia/Neighborhoods_Philadelphia.geojson"
neighborhoods_raw <- sf::read_sf(neighborhoods_geojson)

# Note that this data is MultiPolygon data and that the CRS is WGS 84
head(neighborhoods_raw)

## ## Simple features data: Philadelphia shootings
# Source: OpenDataPhilly. https://www.opendataphilly.org/dataset/shooting-victims
base_url <- "https://phl.carto.com/api/v2/sql"
q <- "
select *
from shootings
where year > 2018
"
shootings_geoJSON <- 
  httr::modify_url(
    url = base_url,
    query = list(q = q, format = "GeoJSON")
  )
shootings_raw <- sf::read_sf(shootings_geoJSON)

# Note that this data is Point data and that the CRS is WGS 84
head(shootings_raw)

# CLEAN DATA   #### #### #### #### #### ####
## ## Simple features data: Philadelphia neighborhoods
neighborhoods <- neighborhoods_raw %>% 
  dplyr::select(label = mapname) 

head(neighborhoods)

## ## Simple features data: Philadelphia shootings
shootings_df <- sf::st_drop_geometry(shootings_raw)

head(shootings_df)

shootings <- shootings_raw %>% 
  dplyr::filter(point_x > -80 & point_y > 25) %>% # points in FL
  sf::st_jitter(factor = 0.0004) %>% 
  dplyr::mutate(
    color = dplyr::if_else(fatal == 1, "#900", "#222"),
    popup = paste0(
      "<b>", location, "</b>",
      "<br/><i>", date_, "</i>",
      "<br/><b>Race:</b> ", dplyr::case_when(
        race == "B" ~ "Black",
        race == "W" ~ "White",
        TRUE ~ "NA"
      ),
      "<br/><b>Sex:</b> ", dplyr::case_when(
        sex == "M" ~ "Male",
        sex == "F" ~ "Female",
        TRUE ~ "NA"
      ),
      "<br/><b>Age:</b> ", age,
      "<br/><b>Wound:</b> ", wound,
      "<br/><b>Fatal?:</b> ", dplyr::case_when(
        fatal == 1 ~ "Yes",
        fatal == 0 ~ "No",
        TRUE ~ "NA"
      )
    )
  ) %>% 
  dplyr::select(color, popup)

head(shootings)

## ## Simple features data: Philadelphia shootings by neighborhood
shootings_count <- sf::st_join(neighborhoods, shootings) %>% 
  dplyr::group_by(label) %>% 
  dplyr::summarise(total_shootings = n(), .groups = "drop") %>% 
  dplyr::mutate(
    label = paste0("<b>", label, ":</b> ", total_shootings)
  ) %>% 
  dplyr::select(label, total_shootings)

# ANALYZE      #### #### #### #### #### ####
# Non-geospatial data
shootings_df %>% 
  dplyr::group_by(year, fatal) %>% 
  dplyr::summarise(n = n(), .group = "drop") %>% 
  dplyr::arrange(year, fatal)

# Basic point map
leaflet::leaflet() %>% 
  leaflet::addProviderTiles(providers$CartoDB.Voyager) %>% 
  leaflet::addPolygons(data = neighborhoods) %>% 
  leaflet::addCircles(data = shootings)

# Formatted point map
leaflet::leaflet() %>% 
  leaflet::addProviderTiles(providers$CartoDB.Voyager) %>% 
  leaflet::addPolygons(
    color = "#222", weight = 2, opacity = 1, fillOpacity = 0,
    label = ~lapply(label, htmltools::htmlEscape),
    labelOptions = leaflet::labelOptions(direction = "top"),
    data = neighborhoods
  ) %>% 
  leaflet::addCircles(
    color = ~color, popup = ~popup,
    data = shootings
  )

pal <- leaflet::colorNumeric(
  "YlOrRd",
  domain = shootings_count$total_shootings
)

# Formatted choropleth
leaflet::leaflet(shootings_count) %>% 
  leaflet::addProviderTiles(providers$CartoDB.Voyager) %>% 
  leaflet::addPolygons(
    color = "#222", weight = 2, opacity = 1,
    fillColor = ~pal(total_shootings), fillOpacity = 0.7,
    label = ~lapply(label, htmltools::HTML),
    labelOptions = leaflet::labelOptions(direction = "top"),
    highlight = leaflet::highlightOptions(
      color = "#FFF", bringToFront = TRUE
    )
  ) %>%
  leaflet::addLegend(
    pal = pal, values = ~total_shootings, opacity = 0.7,
    title = "# shootings", position = "topleft"
  )
