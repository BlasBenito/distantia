# Coerces Vector to a Given Time Class

Coerces Vector to a Given Time Class

## Usage

``` r
utils_coerce_time_class(x = NULL, to = "POSIXct")
```

## Arguments

- x:

  (required, vector of class Date or POSIXct) time vector to convert.
  Default: NULL

- to:

  (required, class name) class to coerce `x` to. Either "Date",
  "POSIXct", "integer" or "numeric". Default: "POSIXct"

## Value

time vector

## See also

Other internal_time_handling:
[`utils_as_time()`](https://blasbenito.github.io/distantia/reference/utils_as_time.md),
[`utils_is_time()`](https://blasbenito.github.io/distantia/reference/utils_is_time.md),
[`utils_new_time()`](https://blasbenito.github.io/distantia/reference/utils_new_time.md),
[`utils_time_keywords()`](https://blasbenito.github.io/distantia/reference/utils_time_keywords.md),
[`utils_time_keywords_dictionary()`](https://blasbenito.github.io/distantia/reference/utils_time_keywords_dictionary.md),
[`utils_time_keywords_translate()`](https://blasbenito.github.io/distantia/reference/utils_time_keywords_translate.md),
[`utils_time_units()`](https://blasbenito.github.io/distantia/reference/utils_time_units.md)

## Examples

``` r
x <- utils_coerce_time_class(
  x = c("2024-01-01", "2024-02-01"),
  to = "Date"
)

x
#> [1] "2024-01-01" "2024-02-01"
class(x)
#> [1] "Date"

x <- utils_coerce_time_class(
  x = c("2024-01-01", "2024-02-01"),
  to = "POSIXct"
)

x
#> [1] "2024-01-01 UTC" "2024-02-01 UTC"
class(x)
#> [1] "POSIXct" "POSIXt" 

x <- utils_coerce_time_class(
  x = c("2024-01-01", "2024-02-01"),
  to = "numeric"
)

x
#> [1] 19723 19754
class(x)
#> [1] "numeric"
```
