# Rolling Window Smoothing of Zoo Time Series

Just a fancy wrapper for
[`zoo::rollapply()`](https://rdrr.io/pkg/zoo/man/rollapply.html).

## Usage

``` r
zoo_smooth_window(x = NULL, window = 3, f = mean, ...)
```

## Arguments

- x:

  (required, zoo object) Time series to smooth Default: NULL

- window:

  (optional, integer) Smoothing window width, in number of cases.
  Default: 3

- f:

  (optional, quoted or unquoted function name) Name of a standard or
  custom function to aggregate numeric vectors. Typical examples are
  `mean`, `max`,`min`, `median`, and `quantile`. Default: `mean`.

- ...:

  (optional, additional arguments) additional arguments to `f`.

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
[`zoo_smooth_exponential()`](https://blasbenito.github.io/distantia/reference/zoo_smooth_exponential.md),
[`zoo_time()`](https://blasbenito.github.io/distantia/reference/zoo_time.md),
[`zoo_to_tsl()`](https://blasbenito.github.io/distantia/reference/zoo_to_tsl.md),
[`zoo_vector_to_matrix()`](https://blasbenito.github.io/distantia/reference/zoo_vector_to_matrix.md)

## Examples

``` r
x <- zoo_simulate()

x_smooth <- zoo_smooth_window(
  x = x,
  window = 5,
  f = mean
)

if(interactive()){
  zoo_plot(x)
  zoo_plot(x_smooth)
}
```
