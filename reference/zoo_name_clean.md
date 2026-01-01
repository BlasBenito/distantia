# Clean Name of a Zoo Time Series

Combines
[`utils_clean_names()`](https://blasbenito.github.io/distantia/reference/utils_clean_names.md)
and
[`zoo_name_set()`](https://blasbenito.github.io/distantia/reference/zoo_name_set.md)
to help clean, abbreviate, capitalize, and add a suffix or a prefix to
the name of a zoo object.

## Usage

``` r
zoo_name_clean(
  x = NULL,
  lowercase = FALSE,
  separator = "_",
  capitalize_first = FALSE,
  capitalize_all = FALSE,
  length = NULL,
  suffix = NULL,
  prefix = NULL
)
```

## Arguments

- x:

  (required, zoo object) Zoo time series to analyze. Default: NULL.

- lowercase:

  (optional, logical) If TRUE, all names are coerced to lowercase.
  Default: FALSE

- separator:

  (optional, character string) Separator when replacing spaces and dots.
  Also used to separate `suffix` and `prefix` from the main word.
  Default: "\_".

- capitalize_first:

  (optional, logical) Indicates whether to capitalize the first letter
  of each name Default: FALSE.

- capitalize_all:

  (optional, logical) Indicates whether to capitalize all letters of
  each name Default: FALSE.

- length:

  (optional, integer) Minimum length of abbreviated names. Names are
  abbreviated via
  [`abbreviate()`](https://rdrr.io/r/base/abbreviate.html). Default:
  NULL.

- suffix:

  (optional, character string) Suffix for the clean names. Default:
  NULL.

- prefix:

  (optional, character string) Prefix for the clean names. Default:
  NULL.

## Value

zoo time series

## See also

Other zoo_functions:
[`zoo_aggregate()`](https://blasbenito.github.io/distantia/reference/zoo_aggregate.md),
[`zoo_name_get()`](https://blasbenito.github.io/distantia/reference/zoo_name_get.md),
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
