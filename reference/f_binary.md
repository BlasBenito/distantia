# Transform Zoo Object to Binary

Converts a zoo object to binary (1 and 0) based on a given threshold.

## Usage

``` r
f_binary(x = NULL, threshold = NULL)
```

## Arguments

- x:

  (required, zoo object) Zoo time series object to transform.

- threshold:

  (required, numeric) Values greater than this number become 1, others
  become 0. Set to the mean of the time series by default. Default: NULL

## Value

zoo object

## See also

Other tsl_transformation:
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
[`f_trend_linear()`](https://blasbenito.github.io/distantia/reference/f_trend_linear.md),
[`f_trend_poly()`](https://blasbenito.github.io/distantia/reference/f_trend_poly.md)

## Examples

``` r
x <- zoo_simulate(
  data_range = c(0, 1)
  )

y <- f_binary(
  x = x,
  threshold = 0.5
)

if(interactive()){
  zoo_plot(x)
  zoo_plot(y)
}
```
