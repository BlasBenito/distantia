# Transform Time Series List to Data Frame

Transform Time Series List to Data Frame

## Usage

``` r
tsl_to_df(tsl = NULL)
```

## Arguments

- tsl:

  (required, list) Time series list. Default: NULL

## Value

data frame

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
[`tsl_nrow()`](https://blasbenito.github.io/distantia/reference/tsl_nrow.md),
[`tsl_repair()`](https://blasbenito.github.io/distantia/reference/tsl_repair.md),
[`tsl_subset()`](https://blasbenito.github.io/distantia/reference/tsl_subset.md),
[`tsl_time()`](https://blasbenito.github.io/distantia/reference/tsl_time.md)

## Examples

``` r
tsl <- tsl_simulate(
  n = 3,
  rows = 10,
  time_range = c(
    "2010-01-01",
    "2020-01-01"
  ),
  irregular = FALSE
)

df <- tsl_to_df(
  tsl = tsl
)

names(df)
#> [1] "name" "time" "a"    "b"    "c"    "d"    "e"   
nrow(df)
#> [1] 30
head(df)
#>   name       time         a         b         c         d         e
#> 1    A 2010-01-01 0.6787063 0.7138592 0.7593769 0.1121627 0.3162761
#> 2    A 2011-02-10 0.6687941 0.6085045 0.6988391 0.1482270 0.3481428
#> 3    A 2012-03-22 0.6755347 0.6513111 0.8201172 0.2468428 0.2098305
#> 4    A 2013-05-02 0.5048007 0.5792843 0.8101604 0.5660837 0.4594817
#> 5    A 2014-06-12 0.2721474 0.2185899 0.4842476 0.6985481 0.7787640
#> 6    A 2015-07-22 0.3293727 0.2469761 0.1484940 0.4906197 0.3858767
```
