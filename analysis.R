
# Load libraries
library(tidyverse)
library(ggmap)

# Read in the state-level and county-level data
state <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv",
                  col_types = cols(
                    date = col_date(format = ""),
                    state = col_character(),
                    fips = col_character(),
                    cases = col_double(),
                    deaths = col_double()
                  ))
county_data <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv",
                   col_types = cols(
                     date = col_date(format = ""),
                     county = col_character(),
                     state = col_character(),
                     fips = col_character(),
                     cases = col_double(),
                     deaths = col_double()
                   )) %>%
  mutate(county = paste(county, sep = ", ", state)) %>%
  select(-state)

coordinates <- read_rds("coordinate_data.rds")

join_county_data <- left_join(county_data, coordinates, by = "county") %>%
  filter(!is.na(lon)) %>%
  group_by(county) %>%
  mutate(total_cases = sum(cases),
         total_deaths = sum(deaths))

x <- join_county_data %>%
  select(total_cases, total_deaths, county, lon, lat) %>%
  distinct()

write_rds(x, "x.rds")

# Add coordinates corresponding to each entry
# coordinates <- county_data %>%
#   mutate(county = paste(county, sep = ", ", state)) %>%
#   select(county) %>%
#   distinct() %>%
#   
#   # Use ggmap's geocoding functionality using the Google Maps Geocoding API. You
#   # may need to use the register_google() function, passing in your hashed API
#   # key as the argument.
#   
#   mutate_geocode(county)
# 
# write_rds(coordinates, "coordinate_data.rds")

