evi <- evi.climate

library(dplyr)
evi <- evi.climate |>
  dplyr::mutate(
    date = as.Date(paste0(year, "-", month, "-01"))
  ) |>
  dplyr::relocate(
    date,
    .before = evi
  ) |>
  dplyr::relocate(
    site,
    .before = date
  ) |>
  dplyr::select(
    -year,
    -month
  )

usethis::use_data(evi)


#eemian
eemian_pollen <- eemian.pollen

usethis::use_data(eemian_pollen)

eemian_sites <- eemian.sites |>
  dplyr::transmute(
    site,
    x = lon,
    y = lat
  ) |>
  sf::st_as_sf(
    coords = c("x", "y"),
    crs = 4326,
    remove = FALSE
  )

usethis::use_data(eemian_sites)


#temperature
cities_temperature <- GlobalLandTemperaturesByMajorCity |>
  dplyr::transmute(
    city = City,
    date = dt,
    temperature = AverageTemperature
  ) |>
  dplyr::filter(
    date >= as.Date("1975-01-01"),
    date <= as.Date("2010-01-01")
  )

cities_coordinates <- GlobalLandTemperaturesByMajorCity |>
  dplyr::transmute(
    city = City,
    country = Country,
    x = Longitude,
    y = Latitude
  ) |>
  dplyr::distinct()


convert_coord <- function(coord) {
  direction <- substr(coord, nchar(coord), nchar(coord))
  value <- as.numeric(substr(coord, 1, nchar(coord) - 1))
  if (direction %in% c("S", "W")) {
    value <- -value
  }
  return(value)
}

# Apply the function to the data frame
cities_coordinates <- cities_coordinates |>
  mutate(
    x = sapply(x, convert_coord),
    y = sapply(y, convert_coord)
  )

# Convert to sf object
cities_coordinates <- sf::st_as_sf(cities_coordinates, coords = c("x", "y"), crs = 4326, remove = FALSE)

usethis::use_data(cities_temperature)
usethis::use_data(cities_coordinates)



#covid


# Data frame with county names and coordinates in WGS 84
covid_coordinates <- data.frame(
  county = c("Alameda", "Butte", "Contra Costa", "El Dorado", "Fresno", "Humboldt",
             "Imperial", "Kern", "Kings", "Los Angeles", "Madera", "Marin", "Merced",
             "Monterey", "Napa", "Orange", "Placer", "Riverside", "Sacramento",
             "San Bernardino", "San Diego", "San Francisco", "San Joaquin",
             "San Luis Obispo", "San Mateo", "Santa Barbara", "Santa Clara",
             "Santa Cruz", "Shasta", "Solano", "Sonoma", "Stanislaus", "Sutter",
             "Tulare", "Ventura", "Yolo"),
  y = c(37.8044, 39.5138, 38.0194, 38.7296, 36.7378, 40.8021, 32.7920, 35.3733,
          36.3275, 34.0522, 36.9613, 37.9735, 37.3022, 36.6777, 38.2975, 33.7455,
          38.8966, 33.9806, 38.5816, 34.1083, 32.7157, 37.7749, 37.9577, 35.2828,
          37.4848, 34.4208, 37.3382, 36.9741, 40.5865, 38.2494, 38.4405, 37.6391,
          39.1404, 36.3302, 34.2746, 38.6785),
  x = c(-122.2711, -121.5564, -122.1341, -120.7985, -119.7871, -124.1637,
          -115.5631, -119.0187, -119.6457, -118.2437, -120.0607, -122.5311,
          -120.4820, -121.6555, -122.2869, -117.8677, -121.0769, -117.3755,
          -121.4944, -117.2898, -117.1611, -122.4194, -121.2908, -120.6596,
          -122.2281, -119.6982, -121.8863, -122.0308, -122.3917, -122.0390,
          -122.7144, -120.9969, -121.6169, -119.2921, -119.2290, -121.7733)
)

covid_coordinates <- covid_coordinates |>
  sf::st_as_sf(
    coords = c("x", "y"),
    crs = 4326,
    remove = FALSE
  )

usethis::use_data(covid_coordinates)

# Print the data frame
print(county_coords)
