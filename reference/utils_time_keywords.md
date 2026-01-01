# Valid Aggregation Keywords

Internal function to obtain valid aggregation keywords from a zoo object
or a time series list.

## Usage

``` r
utils_time_keywords(tsl = NULL)
```

## Arguments

- tsl:

  (required, list) Time series list. Default: NULL

## Value

Character string, aggregation keyword, or "none".

## See also

Other internal_time_handling:
[`utils_as_time()`](https://blasbenito.github.io/distantia/reference/utils_as_time.md),
[`utils_coerce_time_class()`](https://blasbenito.github.io/distantia/reference/utils_coerce_time_class.md),
[`utils_is_time()`](https://blasbenito.github.io/distantia/reference/utils_is_time.md),
[`utils_new_time()`](https://blasbenito.github.io/distantia/reference/utils_new_time.md),
[`utils_time_keywords_dictionary()`](https://blasbenito.github.io/distantia/reference/utils_time_keywords_dictionary.md),
[`utils_time_keywords_translate()`](https://blasbenito.github.io/distantia/reference/utils_time_keywords_translate.md),
[`utils_time_units()`](https://blasbenito.github.io/distantia/reference/utils_time_units.md)

## Examples

``` r
#one minute time series
#-----------------------------------
tsl <- tsl_simulate(
  time_range = c(
    Sys.time() - 60,
    Sys.time()
  )
)

#valid keywords for aggregation and/or resampling
utils_time_keywords(
  tsl = tsl
)
#> [1] "seconds"

#10 minutes time series
#-----------------------------------
tsl <- tsl_simulate(
  time_range = c(
    Sys.time() - 600,
    Sys.time()
  )
)

utils_time_keywords(
  tsl = tsl
)
#> [1] "minutes" "seconds"

#10 hours time series
#-----------------------------------
tsl <- tsl_simulate(
  time_range = c(
    Sys.time() - 6000,
    Sys.time()
  )
)

utils_time_keywords(
  tsl = tsl
)
#> [1] "hours"   "minutes" "seconds"

#10 days time series
#-----------------------------------
tsl <- tsl_simulate(
  time_range = c(
    Sys.Date() - 10,
    Sys.Date()
  )
)

utils_time_keywords(
  tsl = tsl
)
#> [1] "weeks" "days" 

#10 years time series
#-----------------------------------
tsl <- tsl_simulate(
  time_range = c(
    Sys.Date() - 3650,
    Sys.Date()
  )
)

utils_time_keywords(
  tsl = tsl
)
#> [1] "years"    "quarters" "months"   "weeks"    "decades" 
```
