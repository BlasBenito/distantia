# Spatial Representation of `momentum()` Data Frames

Given an sf data frame with geometry types POLYGON, MULTIPOLYGON, or
POINT representing time series locations, this function transforms the
output of
[`momentum()`](https://blasbenito.github.io/distantia/reference/momentum.md),
[`momentum_ls()`](https://blasbenito.github.io/distantia/reference/momentum_ls.md),
[`momentum_dtw()`](https://blasbenito.github.io/distantia/reference/momentum_dtw.md)
to an sf data frame.

If `network = TRUE`, the sf data frame is of type LINESTRING, with edges
connecting time series locations. This output is helpful to build
many-to-many dissimilarity maps (see examples).

If `network = FALSE`, the sf data frame contains the geometry in the
input `sf` argument. This output helps build one-to-many dissimilarity
maps.

## Usage

``` r
momentum_spatial(df = NULL, sf = NULL, network = TRUE)
```

## Arguments

- df:

  (required, data frame) Output of
  [`momentum()`](https://blasbenito.github.io/distantia/reference/momentum.md),
  [`momentum_ls()`](https://blasbenito.github.io/distantia/reference/momentum_ls.md),
  or
  [`momentum_dtw()`](https://blasbenito.github.io/distantia/reference/momentum_dtw.md).
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

Other momentum_support:
[`momentum_aggregate()`](https://blasbenito.github.io/distantia/reference/momentum_aggregate.md),
[`momentum_boxplot()`](https://blasbenito.github.io/distantia/reference/momentum_boxplot.md),
[`momentum_model_frame()`](https://blasbenito.github.io/distantia/reference/momentum_model_frame.md),
[`momentum_stats()`](https://blasbenito.github.io/distantia/reference/momentum_stats.md),
[`momentum_to_wide()`](https://blasbenito.github.io/distantia/reference/momentum_to_wide.md)

## Examples

``` r
tsl <- distantia::tsl_initialize(
  x = distantia::eemian_pollen,
  name_column = "name",
  time_column = "time"
) |>
#reduce size to speed-up example runtime
distantia::tsl_subset(
  names = 1:3
  )
#> distantia::utils_prepare_time():  duplicated time indices in 'Krumbach_I':
#> - value 6.8 replaced with 6.825.

df_momentum <- distantia::momentum(
  tsl = tsl
)

#network many to many
sf_momentum <- distantia::momentum_spatial(
  df = df_momentum,
  sf = distantia::eemian_coordinates,
  network = TRUE
)

#network map
# mapview::mapview(
#   sf_momentum,
#   layer.name = "Importance - Abies",
#   label = "edge_name",
#   zcol = "importance__Abies",
#   lwd = 3
# ) |>
#   suppressWarnings()
```
