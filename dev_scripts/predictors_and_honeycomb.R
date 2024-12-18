library(sf)
library(terra)
library(dplyr)

load("data_full/honeycomb_polygons.rda")
honeycomb_polygons_100 <- honeycomb_polygons
rm(honeycomb_polygons)

cc_vect <- terra::vect(honeycomb_polygons_100)

#distance to ocean
out <- terra::extract(
  x = terra::rast("~/Dropbox/BMK_RASTER_REPOSITORY/1km/continuous/static/geography/geography__distance_to_ocean.tif"),
  y = cc_vect,
  fun = mean,
  na.rm = TRUE,
  ID = FALSE
)[, 1]

out[is.na(out)] <- 0
out <- out * 100

honeycomb_polygons_100$distance_to_ocean <- out

#elevation
out <- terra::extract(
  x = terra::rast("~/Dropbox/BMK_RASTER_REPOSITORY/1km/continuous/static/geography/geography__elevation.tif"),
  y = cc_vect,
  ID = FALSE
)[, 1]

out[is.na(out)] <- 0

honeycomb_polygons_100$elevation <- out

#radiation
out <- terra::extract(
  x = terra::rast("~/Dropbox/BMK_RASTER_REPOSITORY/1km/continuous/static/radiation/annual/radiation__annual__mean.tif"),
  y = terra::buffer(cc_vect, width = 100000),
  fun = mean,
  na.rm = TRUE,
  ID = FALSE
)[, 1]

honeycomb_polygons_100$solar_radiation <- out

#aridity
out <- terra::extract(
  x = terra::rast("~/Dropbox/BMK_RASTER_REPOSITORY/1km/continuous/static/climate/aridity_index__annual__mean.tif"),
  y = terra::buffer(cc_vect, width = 100000),
  fun = mean,
  na.rm = TRUE,
  ID = FALSE
)[, 1]

honeycomb_polygons_100$aridity_index <- out

#cloud cover
out <- terra::extract(
  x = terra::rast("~/Dropbox/BMK_RASTER_REPOSITORY/1km/continuous/static/climate/cloud_cover__annual__mean.tif"),
  y = terra::buffer(cc_vect, width = 100000),
  fun = mean,
  na.rm = TRUE,
  ID = FALSE
)[, 1]

honeycomb_polygons_100$annual_cloud_cover <- out


#ndvi
out <- terra::extract(
  x = terra::rast("~/Dropbox/BMK_RASTER_REPOSITORY/1km/continuous/static/vegetation/annual/ndvi__annual__mean.tif"),
  y = terra::buffer(cc_vect, width = 100000),
  fun = mean,
  na.rm = TRUE,
  ID = FALSE
)[, 1]

honeycomb_polygons_100$annual_ndvi <- out

honeycomb_polygons_100 <- honeycomb_polygons_100 |>
  dplyr::transmute(
    name,
    country,
    x,
    y,
    elevation,
    distance_to_ocean,
    solar_radiation,
    annual_cloud_cover,
    aridity_index,
    annual_ndvi,
    geometry
  ) |>
  as.data.frame() |>
  sf::st_sf()

honeycomb_polygons <- honeycomb_polygons_100
save(honeycomb_polygons, file = "data_full/honeycomb_polygons.rda")
rm(honeycomb_polygons)

load("data/honeycomb_polygons.rda")

honeycomb_polygons <- dplyr::inner_join(
  x = honeycomb_polygons[, c("name", "country", "geometry")],
  y = sf::st_drop_geometry(honeycomb_polygons_100),
  by = c("name", "country")
)

usethis::use_data(honeycomb_polygons, overwrite = TRUE)


