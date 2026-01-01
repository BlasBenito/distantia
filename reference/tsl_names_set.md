# Set Time Series Names in a Time Series List

Sets the names of a time series list and the internal names of the zoo
objects inside, stored in their attribute "name".

## Usage

``` r
tsl_names_set(tsl = NULL, names = NULL)
```

## Arguments

- tsl:

  (required, list) Time series list. Default: NULL

- names:

  (optional, character vector) names to set. Must be of the same length
  of `x`. If NULL, and the list `x` has names, then the names of the zoo
  objects inside of the list are taken from the names of the list
  elements.

## Value

time series list

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
[`tsl_names_test()`](https://blasbenito.github.io/distantia/reference/tsl_names_test.md),
[`tsl_ncol()`](https://blasbenito.github.io/distantia/reference/tsl_ncol.md),
[`tsl_nrow()`](https://blasbenito.github.io/distantia/reference/tsl_nrow.md),
[`tsl_repair()`](https://blasbenito.github.io/distantia/reference/tsl_repair.md),
[`tsl_subset()`](https://blasbenito.github.io/distantia/reference/tsl_subset.md),
[`tsl_time()`](https://blasbenito.github.io/distantia/reference/tsl_time.md),
[`tsl_to_df()`](https://blasbenito.github.io/distantia/reference/tsl_to_df.md)

## Examples

``` r
#simulate time series list
tsl <- tsl_simulate(n = 3)

#assess validity
tsl_diagnose(
  tsl = tsl
)

#list and zoo names (default)
tsl_names_get(
  tsl = tsl
)
#>   A   B   C 
#> "A" "B" "C" 

#list names
tsl_names_get(
  tsl = tsl,
  zoo = FALSE
)
#> [1] "A" "B" "C"

#renaming list items and zoo objects
#------------------------------------
tsl <- tsl_names_set(
  tsl = tsl,
  names = c("X", "Y", "Z")
)

# check new names
tsl_names_get(
  tsl = tsl
)
#>   X   Y   Z 
#> "X" "Y" "Z" 

#fixing naming issues
#------------------------------------

#creating a invalid time series list
names(tsl)[2] <- "B"

# check names
tsl_names_get(
  tsl = tsl
)
#>   X   B   Z 
#> "X" "Y" "Z" 

#validate tsl
#returns NOT VALID
#recommends a solution
tsl_diagnose(
  tsl = tsl
)
#> distantia::tsl_diagnose(): issues in TSL structure:
#> ---------------------------------------------------
#> 
#>   - list and time series names must match and be unique: reset names with distantia::tsl_names_set().

#fix issue with tsl_names_set()
#uses names of zoo objects for the list items
tsl <- tsl_names_set(
  tsl = tsl
)

#validate again
tsl_diagnose(
  tsl = tsl
)

#list names
tsl_names_get(
  tsl = tsl
)
#>   X   B   Z 
#> "X" "B" "Z" 
```
