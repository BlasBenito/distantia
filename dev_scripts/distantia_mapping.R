data("covid_prevalence")
data("covid_coordinates")

#start covid data
covid <- tsl_init(
  x = covid_prevalence,
  id_column = "county",
  time_column = "date",
  lock_step = TRUE
)

covid <- tsl_aggregate(
  tsl = covid,
  breaks = "month",
  f = sum
  )

covid_distantia <- distantia(
  tsl = covid
) |>
  distantia_aggregate()

#create lines
lines <- list()

for(i in seq_len(nrow(covid_distantia))){

  lines[[i]] <- covid_coordinates |>
    dplyr::filter(
      county %in% c(
        covid_distantia[i, "x"],
        covid_distantia[i, "y"]
        )
      ) |>
    sf::st_coordinates() |>
    sf::st_linestring() |>
    sf::st_sfc(crs = sf::st_crs(covid_coordinates))

}

covid_distantia <- covid_distantia |>
  sf::st_sf(geometry = sf::st_sfc(lines))



#GENERIC METHOD?

# Generate all pairs of rows
pairs <- expand.grid(
  id1 = 1:nrow(covid_coordinates),
  id2 = 1:nrow(covid_coordinates)
  ) |>
  dplyr::filter(id1 != id2)

# Function to create a line from two points
create_line <- function(id1, id2, data) {
  coords <- sf::st_coordinates(data[c(id1, id2), ])
  sf::st_sfc(sf::st_linestring(coords))
}

# Create the lines
lines <- mapply(
  create_line,
  pairs$id1,
  pairs$id2,
  MoreArgs = list(data = covid_coordinates)
  )

# Convert the list of lines into an sf object
lines_sf <- sf::st_sf(
  geometry = sf::st_sfc(lines),
  crs = sf::st_crs(covid_coordinates)
  )

# Inspect the created lines
covid_distantia <- cbind(
  covid_distantia,
  lines_sf
) |>
  sf::st_as_sf()

#compute line width
covid_distantia$line_width <- 10 - rescale_vector(
  x = covid_distantia$psi,
  new_min = 0,
  new_max = 10
)

covid_distantia$line_alpha <- 1 - rescale_vector(
  x = covid_distantia$psi,
  new_min = 0,
  new_max = 1
)

#need further testing
library(tmap)
tmap_mode("plot")

tmap::tm_shape(covid_distantia) +
  tmap::tm_lines(lwd = "line_width")



#no interactive
library(ggplot2)
ggplot(data = covid_distantia) +
  geom_sf(
    lwd = covid_distantia$line_width,
    )


#no line width
mapview(
  covid_distantia,
  zcol = "psi",
  weight = covid_distantia$line_width
  )

