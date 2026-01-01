# Data Transformation: Linear Detrending of Zoo Time Series

Fits a linear model on each column of a zoo object using time as a
predictor, predicts the outcome, and subtracts it from the original data
to return a detrended time series. This method might not be suitable if
the input data is not seasonal and has a clear trend, so please be
mindful of the limitations of this function when applied blindly.

## Usage

``` r
f_detrend_linear(x = NULL, center = TRUE, ...)
```

## Arguments

- x:

  (required, zoo object) Zoo time series object to transform.

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
[`f_detrend_difference()`](https://blasbenito.github.io/distantia/reference/f_detrend_difference.md),
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

y <- f_detrend_linear(
  x = x
)

if(interactive()){
  zoo_plot(x)
  zoo_plot(y)
}
```
