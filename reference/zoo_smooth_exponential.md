# Exponential Smoothing of Zoo Time Series

Applies exponential smoothing to a zoo time series object, where each
value is a weighted average of the current value and past smoothed
values. This method is useful for reducing noise in time series data
while preserving the general trend.

## Usage

``` r
zoo_smooth_exponential(x = NULL, alpha = 0.2)
```

## Arguments

- x:

  (required, zoo object) time series to smooth Default: NULL

- alpha:

  (required, numeric) Smoothing factor in the range (0, 1\]. Determines
  the weight of the current value relative to past values. A higher
  value gives more weight to recent observations, while a lower value
  gives more weight to past observations. Default: 0.2

## Value

zoo object

## See also

Other zoo_functions:
[`zoo_aggregate()`](https://blasbenito.github.io/distantia/reference/zoo_aggregate.md),
[`zoo_name_clean()`](https://blasbenito.github.io/distantia/reference/zoo_name_clean.md),
[`zoo_name_get()`](https://blasbenito.github.io/distantia/reference/zoo_name_get.md),
[`zoo_name_set()`](https://blasbenito.github.io/distantia/reference/zoo_name_set.md),
[`zoo_permute()`](https://blasbenito.github.io/distantia/reference/zoo_permute.md),
[`zoo_plot()`](https://blasbenito.github.io/distantia/reference/zoo_plot.md),
[`zoo_resample()`](https://blasbenito.github.io/distantia/reference/zoo_resample.md),
[`zoo_smooth_window()`](https://blasbenito.github.io/distantia/reference/zoo_smooth_window.md),
[`zoo_time()`](https://blasbenito.github.io/distantia/reference/zoo_time.md),
[`zoo_to_tsl()`](https://blasbenito.github.io/distantia/reference/zoo_to_tsl.md),
[`zoo_vector_to_matrix()`](https://blasbenito.github.io/distantia/reference/zoo_vector_to_matrix.md)

## Examples

``` r
x <- zoo_simulate()

x_smooth <- zoo_smooth_exponential(
  x = x,
  alpha = 0.2
)

if(interactive()){
  zoo_plot(x)
  zoo_plot(x_smooth)
}
```
