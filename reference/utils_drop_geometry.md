# Removes Geometry Column from SF Data Frames

Replicates the functionality of
[`sf::st_drop_geometry()`](https://r-spatial.github.io/sf/reference/st_geometry.html)
without depending on the `sf` package.

## Usage

``` r
utils_drop_geometry(df = NULL)
```

## Arguments

- df:

  (required, data frame) Input data frame. Default: NULL.

## Value

data frame

## See also

Other tsl_processing_internal:
[`utils_global_scaling_params()`](https://blasbenito.github.io/distantia/reference/utils_global_scaling_params.md),
[`utils_optimize_loess()`](https://blasbenito.github.io/distantia/reference/utils_optimize_loess.md),
[`utils_optimize_spline()`](https://blasbenito.github.io/distantia/reference/utils_optimize_spline.md),
[`utils_rescale_vector()`](https://blasbenito.github.io/distantia/reference/utils_rescale_vector.md)
