# Data Transformation: Rowwise Hellinger Transformation

Transforms the input zoo object to proportions via
[f_proportion](https://blasbenito.github.io/distantia/reference/f_proportion.md)
and then applies the Hellinger transformation.

## Usage

``` r
f_hellinger(x = NULL, ...)
```

## Arguments

- x:

  (required, zoo object) Zoo time series object to transform.

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
  cols = 5,
  data_range = c(0, 500)
  )

y <- f_hellinger(
  x = x
)

if(interactive()){
  zoo_plot(x)
  zoo_plot(y)
}
```
