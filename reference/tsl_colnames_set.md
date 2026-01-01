# Set Column Names in Time Series Lists

Set Column Names in Time Series Lists

## Usage

``` r
tsl_colnames_set(tsl = NULL, names = NULL)
```

## Arguments

- tsl:

  (required, list) Time series list. Default: NULL

- names:

  (required, list or character vector):

  - list: with same names as 'tsl', containing a vector of new column
    names for each time series in 'tsl'.

  - character vector: vector of new column names assigned by position.

## Value

time series list

## See also

Other tsl_management:
[`tsl_burst()`](https://blasbenito.github.io/distantia/reference/tsl_burst.md),
[`tsl_colnames_clean()`](https://blasbenito.github.io/distantia/reference/tsl_colnames_clean.md),
[`tsl_colnames_get()`](https://blasbenito.github.io/distantia/reference/tsl_colnames_get.md),
[`tsl_colnames_prefix()`](https://blasbenito.github.io/distantia/reference/tsl_colnames_prefix.md),
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
[`tsl_time()`](https://blasbenito.github.io/distantia/reference/tsl_time.md),
[`tsl_to_df()`](https://blasbenito.github.io/distantia/reference/tsl_to_df.md)

## Examples

``` r
tsl <- tsl_simulate(
  cols = 3
  )

tsl_colnames_get(
  tsl = tsl
  )
#> $A
#> [1] "a" "b" "c"
#> 
#> $B
#> [1] "a" "b" "c"
#> 

#using a vector
#extra names are ignored
tsl <- tsl_colnames_set(
  tsl = tsl,
  names = c("x", "y", "z", "zz")
)

tsl_colnames_get(
  tsl = tsl
)
#> $A
#> [1] "x" "y" "z"
#> 
#> $B
#> [1] "x" "y" "z"
#> 

#using a list
#extra names are ignored too
tsl <- tsl_colnames_set(
  tsl = tsl,
  names = list(
    A = c("A", "B", "C"),
    B = c("X", "Y", "Z", "ZZ")
  )
)

tsl_colnames_get(
  tsl = tsl
)
#> $A
#> [1] "A" "B" "C"
#> 
#> $B
#> [1] "X" "Y" "Z"
#> 
```
