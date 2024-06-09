data("eemian_pollen")
data("eemian_coordinates")

df <- eemian_pollen
xy <- eemian_coordinates


#start cities data
tsl <- tsl_init(
  x = df,
  id_column = "site",
  time_column = "depth"
)

future::plan(strategy = future::multisession, workers = 4)

progressr::handlers(global = TRUE)

tsl_distantia <- distantia(
  tsl = tsl,
  diagonal = TRUE,
  weighted = TRUE
)

tsl_network <- distantia_geonetwork(
  df = tsl_distantia,
  xy = xy
)

tsl_network <- tsl_network |>
  dplyr::arrange(psi) |>
  dplyr::slice_head(n = 200)


#need further testing
library(tmap)
tmap_mode("view")

tmap::tm_shape(xy) +
  tmap::tm_bubbles(size = 1) +
  tmap::tm_shape(tsl_network) +
  tmap::tm_lines(
    col = "psi",
    lwd = 0.1,
    palette = viridis::viridis(n = 100, direction = 1)
  )
