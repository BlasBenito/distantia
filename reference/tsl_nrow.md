# Get Number of Rows in Time Series Lists

Get Number of Rows in Time Series Lists

## Usage

``` r
tsl_nrow(tsl = NULL)
```

## Arguments

- tsl:

  (required, list) Time series list. Default: NULL

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
[`tsl_names_get()`](https://blasbenito.github.io/distantia/reference/tsl_names_get.md),
[`tsl_names_set()`](https://blasbenito.github.io/distantia/reference/tsl_names_set.md),
[`tsl_names_test()`](https://blasbenito.github.io/distantia/reference/tsl_names_test.md),
[`tsl_ncol()`](https://blasbenito.github.io/distantia/reference/tsl_ncol.md),
[`tsl_repair()`](https://blasbenito.github.io/distantia/reference/tsl_repair.md),
[`tsl_subset()`](https://blasbenito.github.io/distantia/reference/tsl_subset.md),
[`tsl_time()`](https://blasbenito.github.io/distantia/reference/tsl_time.md),
[`tsl_to_df()`](https://blasbenito.github.io/distantia/reference/tsl_to_df.md)

## Examples

``` r
#simulate zoo time series
tsl <- tsl_simulate(
  rows = 150
  )

#count rows
tsl_nrow(
  tsl = tsl
)
#> $A
#> [1] 133
#> 
#> $B
#> [1] 113
#> 
```
