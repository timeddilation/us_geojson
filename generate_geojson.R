library(data.table)
library(tigris)
library(sf)
library(sp)
library(geojsonio)
library(geojsonlint)

options(tigris_use_cache = TRUE)

all_states <- states(cb = T, resolution = "20m") |> 
  as.data.table()

all_states_df <- all_states[, .(Name = NAME)] |> as.data.frame()
row.names(all_states_df) <- gsub("^", "ID", row.names(all_states_df))


file_conn <- file("geojson/states.json")
all_states[, geometry] |> 
  as_Spatial() |> 
  SpatialPolygonsDataFrame(data = all_states_df) |>
  geojson_json() |>
  geo2topo(object_name = "State") |>
  writeLines(file_conn)
close(file_conn)
