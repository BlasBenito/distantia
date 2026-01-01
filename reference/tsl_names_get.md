# Get Time Series Names from a Time Series Lists

A time series list has two sets of names: the names of the list items
(as returned by `names(tsl)`), and the names of the contained zoo
objects, as stored in their attribute "name". These names should ideally
be the same, for the sake of data consistency. This function extracts
either set of names,

## Usage

``` r
tsl_names_get(tsl = NULL, zoo = TRUE)
```

## Arguments

- tsl:

  (required, list) Time series list. Default: NULL

- zoo:

  (optional, logical) If TRUE, the attributes "name" of the zoo objects
  are returned. Default: TRUE

## Value

list

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
[`tsl_names_set()`](https://blasbenito.github.io/distantia/reference/tsl_names_set.md),
[`tsl_names_test()`](https://blasbenito.github.io/distantia/reference/tsl_names_test.md),
[`tsl_ncol()`](https://blasbenito.github.io/distantia/reference/tsl_ncol.md),
[`tsl_nrow()`](https://blasbenito.github.io/distantia/reference/tsl_nrow.md),
[`tsl_repair()`](https://blasbenito.github.io/distantia/reference/tsl_repair.md),
[`tsl_subset()`](https://blasbenito.github.io/distantia/reference/tsl_subset.md),
[`tsl_time()`](https://blasbenito.github.io/distantia/reference/tsl_time.md),
[`tsl_to_df()`](https://blasbenito.github.io/distantia/reference/tsl_to_df.md)

## Examples

``` r
#initialize a time series list
tsl <- tsl_initialize(
  x = fagus_dynamics,
  name_column = "name",
  time_column = "time"
)


#get names of zoo objects
tsl_names_get(
  tsl = tsl,
  zoo = TRUE
)
#>   Germany     Spain    Sweden 
#> "Germany"   "Spain"  "Sweden" 

#get list names only
tsl_names_get(
  tsl = tsl,
  zoo = FALSE
  )
#> [1] "Germany" "Spain"   "Sweden" 

#same as
names(tsl)
#> [1] "Germany" "Spain"   "Sweden" 
```
