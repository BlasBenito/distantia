# Data Transformation: Global Rescaling of to a New Range

Data Transformation: Global Rescaling of to a New Range

## Usage

``` r
f_rescale_global(
  x = NULL,
  new_min = 0,
  new_max = 1,
  old_min = NULL,
  old_max = NULL,
  .global,
  ...
)
```

## Arguments

- x:

  (required, zoo object) Time Series. Default: `NULL`

- new_min:

  (optional, numeric) New minimum value. Default: `0`

- new_max:

  (optional_numeric) New maximum value. Default: `1`

- old_min:

  (optional, numeric) Old minimum value. Default: `NULL`

- old_max:

  (optional_numeric) Old maximum value. Default: `NULL`

- .global:

  (optional, logical) Used to trigger global scaling within
  [`tsl_transform()`](https://blasbenito.github.io/distantia/reference/tsl_transform.md).

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
[`f_rescale_local()`](https://blasbenito.github.io/distantia/reference/f_rescale_local.md),
[`f_scale_global()`](https://blasbenito.github.io/distantia/reference/f_scale_global.md),
[`f_scale_local()`](https://blasbenito.github.io/distantia/reference/f_scale_local.md),
[`f_trend_linear()`](https://blasbenito.github.io/distantia/reference/f_trend_linear.md),
[`f_trend_poly()`](https://blasbenito.github.io/distantia/reference/f_trend_poly.md)

## Examples

``` r
x <- zoo_simulate(cols = 2)

y <- f_rescale_global(
  x = x,
  new_min = 0,
  new_max = 100
)

if(interactive()){
  zoo_plot(x)
  zoo_plot(y)
}
```
