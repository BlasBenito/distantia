# Spatial Representation of `distantia()` Data Frames

Given an sf data frame with geometry types POLYGON, MULTIPOLYGON, or
POINT representing time series locations, this function transforms the
output of
[`distantia()`](https://blasbenito.github.io/distantia/reference/distantia.md),
[`distantia_ls()`](https://blasbenito.github.io/distantia/reference/distantia_ls.md),
[`distantia_dtw()`](https://blasbenito.github.io/distantia/reference/distantia_dtw.md)
or
[`distantia_time_delay()`](https://blasbenito.github.io/distantia/reference/distantia_time_delay.md)
to an sf data frame.

If `network = TRUE`, the sf data frame is of type LINESTRING, with edges
connecting time series locations. This output is helpful to build
many-to-many dissimilarity maps (see examples).

If `network = FALSE`, the sf data frame contains the geometry in the
input `sf` argument. This output helps build one-to-many dissimilarity
maps.

## Usage

``` r
distantia_spatial(df = NULL, sf = NULL, network = TRUE)
```

## Arguments

- df:

  (required, data frame) Output of
  [`distantia()`](https://blasbenito.github.io/distantia/reference/distantia.md)
  or
  [`distantia_time_delay()`](https://blasbenito.github.io/distantia/reference/distantia_time_delay.md).
  Default: NULL

- sf:

  (required, sf data frame) Points or polygons representing the location
  of the time series in argument 'df'. It must have a column with all
  time series names in `df$x` and `df$y`. Default: NULL

- network:

  (optional, logical) If TRUE, the resulting sf data frame is of time
  LINESTRING and represent network edges. Default: TRUE

## Value

sf data frame (LINESTRING geometry)

## See also

Other distantia_support:
[`distantia_aggregate()`](https://blasbenito.github.io/distantia/reference/distantia_aggregate.md),
[`distantia_boxplot()`](https://blasbenito.github.io/distantia/reference/distantia_boxplot.md),
[`distantia_cluster_hclust()`](https://blasbenito.github.io/distantia/reference/distantia_cluster_hclust.md),
[`distantia_cluster_kmeans()`](https://blasbenito.github.io/distantia/reference/distantia_cluster_kmeans.md),
[`distantia_matrix()`](https://blasbenito.github.io/distantia/reference/distantia_matrix.md),
[`distantia_model_frame()`](https://blasbenito.github.io/distantia/reference/distantia_model_frame.md),
[`distantia_stats()`](https://blasbenito.github.io/distantia/reference/distantia_stats.md),
[`distantia_time_delay()`](https://blasbenito.github.io/distantia/reference/distantia_time_delay.md),
[`utils_block_size()`](https://blasbenito.github.io/distantia/reference/utils_block_size.md),
[`utils_cluster_hclust_optimizer()`](https://blasbenito.github.io/distantia/reference/utils_cluster_hclust_optimizer.md),
[`utils_cluster_kmeans_optimizer()`](https://blasbenito.github.io/distantia/reference/utils_cluster_kmeans_optimizer.md),
[`utils_cluster_silhouette()`](https://blasbenito.github.io/distantia/reference/utils_cluster_silhouette.md)

## Examples

``` r
tsl <- distantia::tsl_initialize(
  x = distantia::covid_prevalence,
  name_column = "name",
  time_column = "time"
) |>
distantia::tsl_subset(
  names = c(
    "Los_Angeles",
    "San_Francisco",
    "Fresno",
    "San_Joaquin"
    )
 )

df_psi <- distantia::distantia_ls(
  tsl = tsl
)

#network many to many
sf_psi <- distantia::distantia_spatial(
  df = df_psi,
  sf = distantia::covid_counties,
  network = TRUE
)

#network map
# mapview::mapview(
#   distantia::covid_counties,
#   col.regions = NA,
#   alpha.regions = 0,
#   color = "black",
#   label = "name",
#   legend = FALSE,
#   map.type = "OpenStreetMap"
# ) +
#   mapview::mapview(
#     sf_psi_subset,
#     layer.name = "Psi",
#     label = "edge_name",
#     zcol = "psi",
#     lwd = 3
#   ) |>
#   suppressWarnings()
```
