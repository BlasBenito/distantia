# Global Centering and Scaling Parameters of Time Series Lists

Internal function to compute global scaling parameters (mean and
standard deviation) for time series lists. Used within
[`tsl_transform()`](https://blasbenito.github.io/distantia/reference/tsl_transform.md)
when the scaling function
[`f_scale_global()`](https://blasbenito.github.io/distantia/reference/f_scale_global.md)
is used as input for the argument `f`.

Warning: this function removes exclusive columns from the data. See
function
[`tsl_subset()`](https://blasbenito.github.io/distantia/reference/tsl_subset.md).

## Usage

``` r
utils_global_scaling_params(tsl = NULL, f = NULL, ...)
```

## Arguments

- tsl:

  (required, list) Time series list. Default: NULL

- f:

  (required, function) function
  [`f_scale_global()`](https://blasbenito.github.io/distantia/reference/f_scale_global.md).
  Default: NULL

- ...:

  (optional, arguments of `f`) Optional arguments for the transformation
  function.

## Value

list

## See also

Other tsl_processing_internal:
[`utils_drop_geometry()`](https://blasbenito.github.io/distantia/reference/utils_drop_geometry.md),
[`utils_optimize_loess()`](https://blasbenito.github.io/distantia/reference/utils_optimize_loess.md),
[`utils_optimize_spline()`](https://blasbenito.github.io/distantia/reference/utils_optimize_spline.md),
[`utils_rescale_vector()`](https://blasbenito.github.io/distantia/reference/utils_rescale_vector.md)
