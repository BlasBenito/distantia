# Optimize Spline Models for Time Series Resampling

Internal function used in
[`zoo_resample()`](https://blasbenito.github.io/distantia/reference/zoo_resample.md).
It finds optimal `df` parameter of a smoothing spline model `y ~ x`
fitted with
[`stats::smooth.spline()`](https://rdrr.io/r/stats/smooth.spline.html)
that minimizes the root mean squared error (rmse) between observations
and predictions, and returns a model fitted with such `df`.

## Usage

``` r
utils_optimize_spline(x = NULL, y = NULL, max_complexity = FALSE)
```

## Arguments

- x:

  (required, numeric vector) predictor, a time vector coerced to
  numeric. Default: NULL

- y:

  (required, numeric vector) response, a column of a zoo object.
  Default: NULL

- max_complexity:

  (required, logical). If TRUE, RMSE optimization is ignored, and the
  model of maximum complexity is returned. Default: FALSE

## Value

Object of class "smooth.spline".

## See also

Other tsl_processing_internal:
[`utils_drop_geometry()`](https://blasbenito.github.io/distantia/reference/utils_drop_geometry.md),
[`utils_global_scaling_params()`](https://blasbenito.github.io/distantia/reference/utils_global_scaling_params.md),
[`utils_optimize_loess()`](https://blasbenito.github.io/distantia/reference/utils_optimize_loess.md),
[`utils_rescale_vector()`](https://blasbenito.github.io/distantia/reference/utils_rescale_vector.md)

## Examples

``` r
#zoo time series
xy <- zoo_simulate(
  cols = 1,
  rows = 30
)

#optimize splines model
m <- utils_optimize_spline(
  x = as.numeric(zoo::index(xy)), #predictor
  y = xy[, 1] #response
)

print(m)
#> Call:
#> stats::smooth.spline(x = model_df$x, y = model_df$y, df = complexity_value, 
#>     all.knots = TRUE)
#> 
#> Smoothing Parameter  spar= -0.9799233  lambda= 1.490233e-15 (23 iterations)
#> Equivalent Degrees of Freedom (Df): 30
#> Penalized Criterion (RSS): 2.667914e-19
#> GCV: 0.1426039

#plot observation
plot(
  x = zoo::index(xy),
  y = xy[, 1],
  col = "forestgreen",
  type = "l",
  lwd = 2
  )

#plot prediction
points(
  x = zoo::index(xy),
  y = stats::predict(
    object = m,
    x = as.numeric(zoo::index(xy))
  )$y,
  col = "red"
)

```
