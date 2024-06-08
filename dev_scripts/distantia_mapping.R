data("eemian_pollen")
data("eemian_coordinates")


#start eemian data
eemian <- tsl_init(
  x = eemian_pollen,
  id_column = "site",
  time_column = "depth"
)

eemian_distantia <- distantia(
  tsl = eemian
)

eemian_network <- distantia_geonetwork(
  df = eemian_distantia,
  xy = eemian_coordinates
)

eemian_network$similarity <- max(eemian_network$psi) - (eemian_network$psi)

#need further testing
library(tmap)
tmap_mode("view")

tmap::tm_shape(eemian_coordinates) +
tmap::tm_bubbles() +
tmap::tm_shape(eemian_network) +
  tmap::tm_lines(
    col = "psi",
    lwd = 3,
    palette = viridis::viridis(n = 10)
    )
