# Translates The User's Time Keywords Into Valid Ones

Internal function to translate misnamed or abbreviated keywords into
valid ones. Uses
[`utils_time_keywords_dictionary()`](https://blasbenito.github.io/distantia/reference/utils_time_keywords_dictionary.md)
as reference dictionary.

## Usage

``` r
utils_time_keywords_translate(keyword = NULL)
```

## Arguments

- keyword:

  (optional, character string) A time keyword such as "day". Default:
  NULL

## Value

Time keyword.

## See also

Other internal_time_handling:
[`utils_as_time()`](https://blasbenito.github.io/distantia/reference/utils_as_time.md),
[`utils_coerce_time_class()`](https://blasbenito.github.io/distantia/reference/utils_coerce_time_class.md),
[`utils_is_time()`](https://blasbenito.github.io/distantia/reference/utils_is_time.md),
[`utils_new_time()`](https://blasbenito.github.io/distantia/reference/utils_new_time.md),
[`utils_time_keywords()`](https://blasbenito.github.io/distantia/reference/utils_time_keywords.md),
[`utils_time_keywords_dictionary()`](https://blasbenito.github.io/distantia/reference/utils_time_keywords_dictionary.md),
[`utils_time_units()`](https://blasbenito.github.io/distantia/reference/utils_time_units.md)

## Examples

``` r
#millennia
utils_time_keywords_translate(
  keyword = "1000 years"
)
#> [1] "millennia"

utils_time_keywords_translate(
  keyword = "1000 y"
)
#> [1] "millennia"

utils_time_keywords_translate(
  keyword = "thousands"
)
#> [1] "millennia"

#years
utils_time_keywords_translate(
  keyword = "year"
)
#> [1] "years"

utils_time_keywords_translate(
  keyword = "y"
)
#> [1] "years"

#days
utils_time_keywords_translate(
  keyword = "d"
)
#> [1] "days"

utils_time_keywords_translate(
  keyword = "day"
)
#> [1] "days"

#seconds
utils_time_keywords_translate(
  keyword = "s"
)
#> [1] "seconds"

utils_time_keywords_translate(
  keyword = "sec"
)
#> [1] "seconds"
```
