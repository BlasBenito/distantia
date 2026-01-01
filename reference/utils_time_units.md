# Data Frame with Supported Time Units

Returns a data frame with the names of the supported time units, the
classes that can handle each time unit, and a the threshold used to
identify what time units can be used when aggregating a time series.

## Usage

``` r
utils_time_units(all_columns = FALSE, class = NULL)
```

## Arguments

- all_columns:

  (optional, logical) If TRUE, all columns are returned. Default: FALSE

- class:

  (optional, class name). Used to filter rows and columns. Accepted
  values are "numeric", "Date", and "POSIXct". Default: NULL

## Value

data frame

## See also

Other internal_time_handling:
[`utils_as_time()`](https://blasbenito.github.io/distantia/reference/utils_as_time.md),
[`utils_coerce_time_class()`](https://blasbenito.github.io/distantia/reference/utils_coerce_time_class.md),
[`utils_is_time()`](https://blasbenito.github.io/distantia/reference/utils_is_time.md),
[`utils_new_time()`](https://blasbenito.github.io/distantia/reference/utils_new_time.md),
[`utils_time_keywords()`](https://blasbenito.github.io/distantia/reference/utils_time_keywords.md),
[`utils_time_keywords_dictionary()`](https://blasbenito.github.io/distantia/reference/utils_time_keywords_dictionary.md),
[`utils_time_keywords_translate()`](https://blasbenito.github.io/distantia/reference/utils_time_keywords_translate.md)

## Examples

``` r
df <- utils_time_units()
head(df)
#>   base_units     units Date POSIXct numeric integer
#> 1       days millennia TRUE    TRUE   FALSE   FALSE
#> 2       days centuries TRUE    TRUE   FALSE   FALSE
#> 3       days   decades TRUE    TRUE   FALSE   FALSE
#> 4       days     years TRUE    TRUE   FALSE   FALSE
#> 5       days  quarters TRUE    TRUE   FALSE   FALSE
#> 6       days    months TRUE    TRUE   FALSE   FALSE
```
