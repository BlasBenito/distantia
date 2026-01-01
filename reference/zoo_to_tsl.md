# Convert Individual Zoo Objects to Time Series List

Internal function to wrap a zoo object into a time series list.

## Usage

``` r
zoo_to_tsl(x = NULL)
```

## Arguments

- x:

  (required, zoo object) Time series. Default: NULL

## Value

time series list of length one.

## See also

Other zoo_functions:
[`zoo_aggregate()`](https://blasbenito.github.io/distantia/reference/zoo_aggregate.md),
[`zoo_name_clean()`](https://blasbenito.github.io/distantia/reference/zoo_name_clean.md),
[`zoo_name_get()`](https://blasbenito.github.io/distantia/reference/zoo_name_get.md),
[`zoo_name_set()`](https://blasbenito.github.io/distantia/reference/zoo_name_set.md),
[`zoo_permute()`](https://blasbenito.github.io/distantia/reference/zoo_permute.md),
[`zoo_plot()`](https://blasbenito.github.io/distantia/reference/zoo_plot.md),
[`zoo_resample()`](https://blasbenito.github.io/distantia/reference/zoo_resample.md),
[`zoo_smooth_exponential()`](https://blasbenito.github.io/distantia/reference/zoo_smooth_exponential.md),
[`zoo_smooth_window()`](https://blasbenito.github.io/distantia/reference/zoo_smooth_window.md),
[`zoo_time()`](https://blasbenito.github.io/distantia/reference/zoo_time.md),
[`zoo_vector_to_matrix()`](https://blasbenito.github.io/distantia/reference/zoo_vector_to_matrix.md)

## Examples

``` r
#create zoo object
x <- zoo_simulate()
class(x)
#> [1] "zoo"

#to time series list
tsl <- zoo_to_tsl(
  x = x
)

class(tsl)
#> [1] "list"
class(tsl[[1]])
#> [1] "zoo"
names(tsl)
#> [1] "A"
attributes(tsl[[1]])$name
#> [1] "A"
```
