# Count NA Cases in Time Series Lists

Converts Inf, -Inf, and NaN to NA (via
[`tsl_Inf_to_NA()`](https://blasbenito.github.io/distantia/reference/tsl_handle_NA.md)
and
[`tsl_NaN_to_NA()`](https://blasbenito.github.io/distantia/reference/tsl_handle_NA.md)),
and counts the total number of NA cases in each time series.

## Usage

``` r
tsl_count_NA(tsl = NULL)
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
#tsl with no NA cases
tsl <- tsl_simulate()

tsl_count_NA(tsl = tsl)
#> $A
#> [1] 0
#> 
#> $B
#> [1] 0
#> 

#tsl with NA cases
tsl <- tsl_simulate(
  na_fraction = 0.3
)

tsl_count_NA(tsl = tsl)
#> $A
#> [1] 112
#> 
#> $B
#> [1] 118
#> 

#tsl with variety of empty cases
tsl <- tsl_simulate()
tsl[[1]][1, 1] <- Inf
tsl[[1]][2, 1] <- -Inf
tsl[[1]][3, 1] <- NaN
tsl[[1]][4, 1] <- NaN

tsl_count_NA(tsl = tsl)
#> $A
#> [1] 4
#> 
#> $B
#> [1] 0
#> 
```
