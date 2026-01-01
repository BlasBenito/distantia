# Get Name of a Zoo Time Series

Just a convenient wrapper of `attributes(x)$name`.

## Usage

``` r
zoo_name_get(x = NULL)
```

## Arguments

- x:

  (required, zoo object) Zoo time series to analyze. Default: NULL.

## Value

character string

## See also

Other zoo_functions:
[`zoo_aggregate()`](https://blasbenito.github.io/distantia/reference/zoo_aggregate.md),
[`zoo_name_clean()`](https://blasbenito.github.io/distantia/reference/zoo_name_clean.md),
[`zoo_name_set()`](https://blasbenito.github.io/distantia/reference/zoo_name_set.md),
[`zoo_permute()`](https://blasbenito.github.io/distantia/reference/zoo_permute.md),
[`zoo_plot()`](https://blasbenito.github.io/distantia/reference/zoo_plot.md),
[`zoo_resample()`](https://blasbenito.github.io/distantia/reference/zoo_resample.md),
[`zoo_smooth_exponential()`](https://blasbenito.github.io/distantia/reference/zoo_smooth_exponential.md),
[`zoo_smooth_window()`](https://blasbenito.github.io/distantia/reference/zoo_smooth_window.md),
[`zoo_time()`](https://blasbenito.github.io/distantia/reference/zoo_time.md),
[`zoo_to_tsl()`](https://blasbenito.github.io/distantia/reference/zoo_to_tsl.md),
[`zoo_vector_to_matrix()`](https://blasbenito.github.io/distantia/reference/zoo_vector_to_matrix.md)

## Examples

``` r
#simulate zoo time series
x <- zoo_simulate()

#get current name
zoo_name_get(x = x)
#> [1] "A"

#change name
x <- zoo_name_set(
  x = x,
  name = "My.New.name"
)

zoo_name_get(x = x)
#> [1] "My.New.name"

#clean name
x <- zoo_name_clean(
  x = x,
  lowercase = TRUE
)

zoo_name_get(x = x)
#> [1] "my_new_name"
```
