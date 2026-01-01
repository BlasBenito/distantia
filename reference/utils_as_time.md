# Ensures Correct Class for Time Arguments

This function guesses the class of a vector based on its elements. It
can handle numeric vectors, character vectors that can be coerced to
either "Date" or "POSIXct" classes, and vectors already in "Date" or
"POSIXct" classes.

## Usage

``` r
utils_as_time(x = NULL, to_class = NULL)
```

## Arguments

- x:

  (required, vector) Vectors of the classes 'numeric', 'Date', and
  'POSIXct' are valid and returned without any transformation. Character
  vectors are analyzed to determine their more probable type, and are
  coerced to 'Date' or 'POSIXct' depending on their number of elements.
  Generally, any character vector representing an ISO 8601 standard,
  like "YYYY-MM-DD" or "YYYY-MM-DD HH:MM:SS" will be converted to a
  valid class. If a character vector cannot be coerced to date, it is
  returned as is. Default: NULL

- to_class:

  (optional, class) Options are: NULL, "numeric", "Date", and "POSIXct".
  If NULL, 'x' is returned as the most appropriate time class.
  Otherwise, 'x' is coerced to the given class. Default: NULL

## Value

time vector

## See also

Other internal_time_handling:
[`utils_coerce_time_class()`](https://blasbenito.github.io/distantia/reference/utils_coerce_time_class.md),
[`utils_is_time()`](https://blasbenito.github.io/distantia/reference/utils_is_time.md),
[`utils_new_time()`](https://blasbenito.github.io/distantia/reference/utils_new_time.md),
[`utils_time_keywords()`](https://blasbenito.github.io/distantia/reference/utils_time_keywords.md),
[`utils_time_keywords_dictionary()`](https://blasbenito.github.io/distantia/reference/utils_time_keywords_dictionary.md),
[`utils_time_keywords_translate()`](https://blasbenito.github.io/distantia/reference/utils_time_keywords_translate.md),
[`utils_time_units()`](https://blasbenito.github.io/distantia/reference/utils_time_units.md)

## Examples

``` r
# numeric
utils_as_time(
  x = c(-123120, 1200)
  )
#> [1] -123120    1200

# character string to Date
utils_as_time(
  x = c("2022-03-17", "2024-02-05")
  )
#> [1] "2022-03-17" "2024-02-05"

# incomplete character strings to Date
utils_as_time(
  x = c("2022", "2024")
  )
#> Warning: Argument 'x' of class 'character' must have the format '%Y-%m-%d' for class 'Date', or '%Y-%m-%d %H:%M:%S' for class 'POSIXct'
#> [1] "2022" "2024"

utils_as_time(
  x = c("2022-02", "2024-03")
  )
#> Warning: Argument 'x' of class 'character' must have the format '%Y-%m-%d' for class 'Date', or '%Y-%m-%d %H:%M:%S' for class 'POSIXct'
#> [1] "2022-02" "2024-03"

# character string to POSIXct
utils_as_time(
  x = c("2022-03-17 12:30:45", "2024-02-05 11:15:45")
  )
#> [1] "2022-03-17 12:30:45 UTC" "2024-02-05 11:15:45 UTC"

# Date vector (returns the input)
utils_as_time(
  x = as.Date(c("2022-03-17", "2024-02-05"))
  )
#> [1] "2022-03-17" "2024-02-05"

# POSIXct vector (returns the input)
utils_as_time(
  x = as.POSIXct(c("2022-03-17 12:30:45", "2024-02-05 11:15:45"))
  )
#> [1] "2022-03-17 12:30:45 UTC" "2024-02-05 11:15:45 UTC"
```
