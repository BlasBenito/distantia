data("eemian_pollen")
data("eemian_coordinates")

#initialize tsl
tsl <- distantia::tsl_init(
  x = distantia::eemian_pollen,
  id_column = "site",
  time_column = "depth"
)

#compute dissimilarity
psi_importance <- distantia::distantia_importance(
  tsl = tsl,
  distance = c("euclidean", "manhattan"),
  robust = c(TRUE, FALSE)
)

#transform to sf
psi_sf <- distantia::distantia_to_sf(
  df = psi_importance,
  xy = distantia::eemian_coordinates
)

#mapping with tmap
# library(tmap)
# tmap::tmap_mode("view")
#
# tmap::tm_shape(psi_sf) +
#   tmap::tm_lines(
#     col = "psi",
#     lwd = 3
#   ) +
#   tmap::tm_shape(distantia::eemian_coordinates) +
#   tmap::tm_dots(size = 0.1, col = "gray50")
