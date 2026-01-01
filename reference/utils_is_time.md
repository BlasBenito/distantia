# Title

Title

## Usage

``` r
utils_is_time(x = NULL)
```

## Arguments

- x:

  (required, vector) Vector to test. If the class of the vector elements
  is 'numeric', 'POSIXct', or 'Date', the function returns TRUE.
  Default: NULL.

## Value

logical

## See also

Other internal_time_handling:
[`utils_as_time()`](https://blasbenito.github.io/distantia/reference/utils_as_time.md),
[`utils_coerce_time_class()`](https://blasbenito.github.io/distantia/reference/utils_coerce_time_class.md),
[`utils_new_time()`](https://blasbenito.github.io/distantia/reference/utils_new_time.md),
[`utils_time_keywords()`](https://blasbenito.github.io/distantia/reference/utils_time_keywords.md),
[`utils_time_keywords_dictionary()`](https://blasbenito.github.io/distantia/reference/utils_time_keywords_dictionary.md),
[`utils_time_keywords_translate()`](https://blasbenito.github.io/distantia/reference/utils_time_keywords_translate.md),
[`utils_time_units()`](https://blasbenito.github.io/distantia/reference/utils_time_units.md)

## Examples

``` r
utils_is_time(
  x = c("2024-01-01", "2024-02-01")
)
#> [1] FALSE

utils_is_time(
  x = utils_as_time(
    x = c("2024-01-01", "2024-02-01")
    )
)
#> [1] TRUE
```
