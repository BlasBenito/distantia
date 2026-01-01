# Get Time Features from Zoo Objects

This function generates a data frame summarizing the time features
(class, length, resolution, and others) of zoo time series.

## Usage

``` r
zoo_time(x = NULL, keywords = c("resample", "aggregate"))
```

## Arguments

- x:

  (required, zoo object) Zoo time series to analyze. Default: NULL.

- keywords:

  (optional, character string or vector) Defines what keywords are
  returned. If "aggregate", returns valid keywords for
  [`zoo_aggregate()`](https://blasbenito.github.io/distantia/reference/zoo_aggregate.md).
  If "resample", returns valid keywords for
  [`zoo_resample()`](https://blasbenito.github.io/distantia/reference/zoo_resample.md).
  If both, returns all valid keywords. Default: c("aggregate",
  "resample").

## Value

Data frame with the following columns:

- `name` (string): time series name.

- `rows` (integer): number of observations.

- `class` (string): time class, one of "Date", "POSIXct", or "numeric."

- `units` (string): units of the time series.

- `length` (numeric): total length of the time series expressed in
  `units`.

- `resolution` (numeric): average interval between observations
  expressed in `units`.

- `begin` (date or numeric): begin time of the time series.

- `end` (date or numeric): end time of the time series.

- `keywords` (character vector): valid keywords for
  [`tsl_aggregate()`](https://blasbenito.github.io/distantia/reference/tsl_aggregate.md)
  or
  [`tsl_resample()`](https://blasbenito.github.io/distantia/reference/tsl_resample.md),
  depending on the value of the argument `keywords`.

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
[`zoo_to_tsl()`](https://blasbenito.github.io/distantia/reference/zoo_to_tsl.md),
[`zoo_vector_to_matrix()`](https://blasbenito.github.io/distantia/reference/zoo_vector_to_matrix.md)

## Examples

``` r
#simulate a zoo time series
x <- zoo_simulate(
  rows = 150,
  time_range = c(
    Sys.Date() - 365,
    Sys.Date()
  ),
  irregular = TRUE
)

#time data frame
zoo_time(
  x = x
)
#>   name rows class units length resolution      begin        end     keywords
#> 1    A  150  Date  days    365   2.449664 2025-01-01 2026-01-01 years, q....
```
