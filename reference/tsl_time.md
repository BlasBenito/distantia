# Time Features of Time Series Lists

The functions `tsl_time()` and `tsl_time_summary()` summarize the time
features of a time series list.

- `tsl_time()` returns a data frame with one row per time series in the
  argument 'tsl'

- `tsl_time_summary()` returns a list with the features captured by
  `tsl_time()`, but aggregated across time series.

Both functions return keywords useful for the functions
[`tsl_aggregate()`](https://blasbenito.github.io/distantia/reference/tsl_aggregate.md)
and
[`tsl_resample()`](https://blasbenito.github.io/distantia/reference/tsl_resample.md),
depending on the value of the argument `keywords`.

## Usage

``` r
tsl_time(tsl = NULL, keywords = c("resample", "aggregate"))

tsl_time_summary(tsl = NULL, keywords = c("resample", "aggregate"))
```

## Arguments

- tsl:

  (required, list) Time series list. Default: NULL

- keywords:

  (optional, character string or vector) Defines what keywords are
  returned. If "aggregate", returns valid keywords for
  [`zoo_aggregate()`](https://blasbenito.github.io/distantia/reference/zoo_aggregate.md).
  If "resample", returns valid keywords for
  [`zoo_resample()`](https://blasbenito.github.io/distantia/reference/zoo_resample.md).
  If both, returns all valid keywords. Default: c("aggregate",
  "resample").

## Value

- `tsl_time()`: data frame with the following columns:

  - `name` (string): time series name.

  - `rows` (integer): number of observations.

  - `class` (string): time class, one of "Date", "POSIXct", or
    "numeric."

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

- `tsl_time_summary()`: list with the following objects:

  - `class` (string): time class, one of "Date", "POSIXct", or
    "numeric."

  - `units` (string): units of the time series.

  - `begin` (date or numeric): begin time of the time series.

  - `end` (date or numeric): end time of the time series.

  - `resolution_max` (numeric): longer time interval between consecutive
    samples expressed in `units`.

  - `resolution_min` (numeric): shorter time interval between
    consecutive samples expressed in `units`.

  - `keywords` (character vector): valid keywords for
    [`tsl_aggregate()`](https://blasbenito.github.io/distantia/reference/tsl_aggregate.md)
    or
    [`tsl_resample()`](https://blasbenito.github.io/distantia/reference/tsl_resample.md),
    depending on the value of the argument `keywords`.

  - `units_df` (data frame) data frame for internal use within
    [`tsl_aggregate()`](https://blasbenito.github.io/distantia/reference/tsl_aggregate.md)
    and
    [`tsl_resample()`](https://blasbenito.github.io/distantia/reference/tsl_resample.md).

## See also

Other tsl_management:
[`tsl_burst()`](https://blasbenito.github.io/distantia/reference/tsl_burst.md),
[`tsl_colnames_clean()`](https://blasbenito.github.io/distantia/reference/tsl_colnames_clean.md),
[`tsl_colnames_get()`](https://blasbenito.github.io/distantia/reference/tsl_colnames_get.md),
[`tsl_colnames_prefix()`](https://blasbenito.github.io/distantia/reference/tsl_colnames_prefix.md),
[`tsl_colnames_set()`](https://blasbenito.github.io/distantia/reference/tsl_colnames_set.md),
[`tsl_colnames_suffix()`](https://blasbenito.github.io/distantia/reference/tsl_colnames_suffix.md),
[`tsl_count_NA()`](https://blasbenito.github.io/distantia/reference/tsl_count_NA.md),
[`tsl_diagnose()`](https://blasbenito.github.io/distantia/reference/tsl_diagnose.md),
[`tsl_handle_NA()`](https://blasbenito.github.io/distantia/reference/tsl_handle_NA.md),
[`tsl_join()`](https://blasbenito.github.io/distantia/reference/tsl_join.md),
[`tsl_names_clean()`](https://blasbenito.github.io/distantia/reference/tsl_names_clean.md),
[`tsl_names_get()`](https://blasbenito.github.io/distantia/reference/tsl_names_get.md),
[`tsl_names_set()`](https://blasbenito.github.io/distantia/reference/tsl_names_set.md),
[`tsl_names_test()`](https://blasbenito.github.io/distantia/reference/tsl_names_test.md),
[`tsl_ncol()`](https://blasbenito.github.io/distantia/reference/tsl_ncol.md),
[`tsl_nrow()`](https://blasbenito.github.io/distantia/reference/tsl_nrow.md),
[`tsl_repair()`](https://blasbenito.github.io/distantia/reference/tsl_repair.md),
[`tsl_subset()`](https://blasbenito.github.io/distantia/reference/tsl_subset.md),
[`tsl_to_df()`](https://blasbenito.github.io/distantia/reference/tsl_to_df.md)

## Examples

``` r
#simulate a time series list
tsl <- tsl_simulate(
  n = 3,
  rows = 150,
  time_range = c(
    Sys.Date() - 365,
    Sys.Date()
  ),
  irregular = TRUE
)

#time data frame
tsl_time(
  tsl = tsl
)
#>   name rows class units   length resolution      begin        end     keywords
#> 1    A  128  Date  days 364.2857   2.868391 2025-01-01 2026-01-01 years, q....
#> 2    B  114  Date  days 359.3846   3.180395 2025-01-06 2026-01-01 quarters....
#> 3    C  123  Date  days 364.2566   2.985710 2025-01-01 2025-12-31 years, q....

#time summary
tsl_time_summary(
  tsl = tsl
)
#> $class
#> [1] "Date"
#> 
#> $units
#> [1] "days"
#> 
#> $begin
#> [1] "2025-01-01"
#> 
#> $end
#> [1] "2026-01-01"
#> 
#> $resolution_max
#> [1] 0.7142857
#> 
#> $resolution_min
#> [1] 14.43956
#> 
#> $keywords
#> [1] "years"    "quarters" "months"   "weeks"    "days"    
#> 
#> $units_df
#>   factor base_units    units threshold keyword
#> 4     NA       days    years       365    TRUE
#> 5     NA       days quarters        90    TRUE
#> 6     NA       days   months        30    TRUE
#> 7     NA       days    weeks         7    TRUE
#> 8     NA       days     days         1    TRUE
#> 
```
