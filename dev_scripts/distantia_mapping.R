data("eemian_pollen")
data("eemian_coordinates")

#initialize tsl
tsl <- distantia::tsl_init(
  x = distantia::eemian_pollen,
  name_column = "site",
  time_column = "depth"
)

#compute importance
df <- distantia::momentum(
  tsl = tsl
)

distantia_boxplot(df)

#transform to sf
psi_sf <- distantia::distantia_spatial_network(
  df = psi_importance,
  sf = distantia::eemian_coordinates
)

#mapping with tmap
library(tmap)
tmap::tmap_mode("view")

tmap::tm_shape(psi_sf) +
  tmap::tm_lines(
    col = "importance__Picea",
    lwd = 3,
    palette = utils_color_continuous_default(n = 100)
  ) +
  tmap::tm_shape(distantia::eemian_coordinates) +
  tmap::tm_dots(size = 0.1, col = "gray50")
