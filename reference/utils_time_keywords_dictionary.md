# Dictionary of Time Keywords

Called by
[`utils_time_keywords_translate()`](https://blasbenito.github.io/distantia/reference/utils_time_keywords_translate.md)
to generate a data frame that helps translate misnamed or abbreviated
time keywords, like "day", "daily", or "d", into correct ones such as
"days".

## Usage

``` r
utils_time_keywords_dictionary()
```

## Value

data frame

## See also

Other internal_time_handling:
[`utils_as_time()`](https://blasbenito.github.io/distantia/reference/utils_as_time.md),
[`utils_coerce_time_class()`](https://blasbenito.github.io/distantia/reference/utils_coerce_time_class.md),
[`utils_is_time()`](https://blasbenito.github.io/distantia/reference/utils_is_time.md),
[`utils_new_time()`](https://blasbenito.github.io/distantia/reference/utils_new_time.md),
[`utils_time_keywords()`](https://blasbenito.github.io/distantia/reference/utils_time_keywords.md),
[`utils_time_keywords_translate()`](https://blasbenito.github.io/distantia/reference/utils_time_keywords_translate.md),
[`utils_time_units()`](https://blasbenito.github.io/distantia/reference/utils_time_units.md)

## Examples

``` r
df <- utils_time_keywords_dictionary()
```
