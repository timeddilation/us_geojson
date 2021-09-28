library(data.table)
library(tigris)
library(sf)
library(sp)
library(geojsonio)
library(geojsonlint)

options(tigris_use_cache = TRUE)

### States

all_states <- states(cb = T, resolution = "20m") |> 
  as.data.table()

all_states_df <- all_states[, .(state_geoid = GEOID, state_name = NAME, abbrv = STUSPS)] |> 
  as.data.frame()
row.names(all_states_df) <- gsub("^", "ID", row.names(all_states_df))

file_conn <- file("topojson/states.json")
all_states[, geometry] |> 
  as_Spatial() |> 
  SpatialPolygonsDataFrame(data = all_states_df) |>
  geojson_json() |>
  geo2topo(object_name = "State") |>
  writeLines(file_conn)
close(file_conn)

### Counties

all_counties <- do.call(
  rbind,
  lapply(all_states[, STATEFP], counties, cb = T, resolution = "20m")
) |> 
  as.data.table()

all_counties_df <- all_counties[, .(county_geoid = GEOID, county_name = NAME, state_geoid = STATEFP)] |>
  merge(
    all_states[, .(state_geoid = GEOID, state_name = NAME)],
    by = "state_geoid"
  ) |>
  as.data.frame()
row.names(all_counties_df) <- gsub("^", "ID", row.names(all_counties_df))

file_conn <- file("topojson/counties.json")
all_counties[, geometry] |> 
  as_Spatial() |> 
  SpatialPolygonsDataFrame(data = all_counties_df) |>
  geojson_json() |>
  geo2topo(object_name = "County") |>
  writeLines(file_conn)
close(file_conn)
