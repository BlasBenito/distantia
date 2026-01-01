# Data Transformation: Polynomial Linear Trend of Zoo Time Series

Fits a polynomial linear model on each column of a zoo object using time
as a predictor, and predicts the outcome to return the polynomial trend
of the time series. This method is a useful alternative to
[f_trend_linear](https://blasbenito.github.io/distantia/reference/f_trend_linear.md)
when the overall. trend of the time series does not follow a straight
line.

## Usage

``` r
f_trend_poly(x = NULL, degree = 2, center = TRUE, ...)
```

## Arguments

- x:

  (required, zoo object) Zoo time series object to transform.

- degree:

  (optional, integer) Degree of the polynomial. Default: 2

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
[`f_trend_linear()`](https://blasbenito.github.io/distantia/reference/f_trend_linear.md)

## Examples

``` r
x <- zoo_simulate(cols = 2)

y <- f_trend_poly(
  x = x
)

if(interactive()){
  zoo_plot(x)
  zoo_plot(y)
}
```
