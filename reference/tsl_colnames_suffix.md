# Append Suffix to Column Names of Time Series List

Append Suffix to Column Names of Time Series List

## Usage

``` r
tsl_colnames_suffix(tsl = NULL, suffix = NULL)
```

## Arguments

- tsl:

  (required, list) Time series list. Default: NULL

- suffix:

  (optional, character string) String to append to the column names.
  Default: NULL.

## Value

time series list

## See also

Other tsl_management:
[`tsl_burst()`](https://blasbenito.github.io/distantia/reference/tsl_burst.md),
[`tsl_colnames_clean()`](https://blasbenito.github.io/distantia/reference/tsl_colnames_clean.md),
[`tsl_colnames_get()`](https://blasbenito.github.io/distantia/reference/tsl_colnames_get.md),
[`tsl_colnames_prefix()`](https://blasbenito.github.io/distantia/reference/tsl_colnames_prefix.md),
[`tsl_colnames_set()`](https://blasbenito.github.io/distantia/reference/tsl_colnames_set.md),
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
tsl <- tsl_simulate()

tsl_colnames_get(tsl = tsl)
#> $A
#> [1] "a" "b" "c" "d" "e"
#> 
#> $B
#> [1] "a" "b" "c" "d" "e"
#> 

tsl <- tsl_colnames_suffix(
  tsl = tsl,
  suffix = "_my_suffix"
)

tsl_colnames_get(tsl = tsl)
#> $A
#> [1] "a_my_suffix" "b_my_suffix" "c_my_suffix" "d_my_suffix" "e_my_suffix"
#> 
#> $B
#> [1] "a_my_suffix" "b_my_suffix" "c_my_suffix" "d_my_suffix" "e_my_suffix"
#> 
```
