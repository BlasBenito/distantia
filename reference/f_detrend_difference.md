# Data Transformation: Detrending and Differencing

Performs differencing to remove trends from a zoo time series, isolating
short-term fluctuations by subtracting values at specified lags. The
function preserves the original index and metadata, with an option to
center the output around the mean of the original series. Suitable for
preprocessing time series data to focus on random fluctuations unrelated
to overall trends.

## Usage

``` r
f_detrend_difference(x = NULL, lag = 1, center = TRUE, ...)
```

## Arguments

- x:

  (required, zoo object) Zoo time series object to transform.

- lag:

  (optional, integer)

- center:

  (required, logical) If TRUE, the output is centered at zero. If FALSE,
  it is centered at the data mean. Default: TRUE

- ...:

  (optional, additional arguments) Ignored in this function.

## Value

zoo object

## See also

Other tsl_transformation:
[`f_binary()`](https://blasbenito.github.io/distantia/reference/f_binary.md),
[`f_clr()`](https://blasbenito.github.io/distantia/reference/f_clr.md),
[`f_detrend_linear()`](https://blasbenito.github.io/distantia/reference/f_detrend_linear.md),
[`f_detrend_poly()`](https://blasbenito.github.io/distantia/reference/f_detrend_poly.md),
[`f_hellinger()`](https://blasbenito.github.io/distantia/reference/f_hellinger.md),
[`f_list()`](https://blasbenito.github.io/distantia/reference/f_list.md),
[`f_log()`](https://blasbenito.github.io/distantia/reference/f_log.md),
[`f_percent()`](https://blasbenito.github.io/distantia/reference/f_percent.md),
[`f_proportion()`](https://blasbenito.github.io/distantia/reference/f_proportion.md),
[`f_proportion_sqrt()`](https://blasbenito.github.io/distantia/reference/f_proportion_sqrt.md),
[`f_rescale_global()`](https://blasbenito.github.io/distantia/reference/f_rescale_global.md),
[`f_rescale_local()`](https://blasbenito.github.io/distantia/reference/f_rescale_local.md),
[`f_scale_global()`](https://blasbenito.github.io/distantia/reference/f_scale_global.md),
[`f_scale_local()`](https://blasbenito.github.io/distantia/reference/f_scale_local.md),
[`f_trend_linear()`](https://blasbenito.github.io/distantia/reference/f_trend_linear.md),
[`f_trend_poly()`](https://blasbenito.github.io/distantia/reference/f_trend_poly.md)

## Examples

``` r
x <- zoo_simulate(cols = 2)

y_lag1 <- f_detrend_difference(
  x = x,
  lag = 1
)

y_lag5 <- f_detrend_difference(
  x = x,
  lag = 5
)

if(interactive()){
  zoo_plot(x)
  zoo_plot(y_lag1)
  zoo_plot(y_lag5)
}
```
