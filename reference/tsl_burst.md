# Multivariate TSL to Univariate TSL

Takes a time series list with multivariate zoo objects to generate a new
one with one univariate zoo objects per variable. A time series list
with the the zoo objects "A" and "B", each with the columns "a", "b",
and "c", becomes a time series list with the zoo objects "A\_\_a",
"A\_\_b", "A\_\_c", "B\_\_a", "B\_\_b", and "B\_\_c". The only column of
each new zoo object is named "x".

## Usage

``` r
tsl_burst(tsl = NULL, sep = "__")
```

## Arguments

- tsl:

  (required, list) Time series list. Default: NULL

- sep:

  (required, character string) separator between the time series name
  and the column name. Default: "\_\_"

## Value

time series list: list of univariate zoo objects with a column named
"x".

## See also

Other tsl_management:
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
[`tsl_time()`](https://blasbenito.github.io/distantia/reference/tsl_time.md),
[`tsl_to_df()`](https://blasbenito.github.io/distantia/reference/tsl_to_df.md)

## Examples

``` r
tsl <- tsl_simulate(
  n = 2,
  time_range = c(
    "2010-01-01",
    "2024-12-31"
  ),
  cols = 3
)

tsl_names_get(tsl)
#>   A   B 
#> "A" "B" 
tsl_colnames_get(tsl)
#> $A
#> [1] "a" "b" "c"
#> 
#> $B
#> [1] "a" "b" "c"
#> 

if(interactive()){
  tsl_plot(tsl)
}

tsl <- tsl_burst(tsl)

tsl_names_get(tsl)
#>   A__a   A__b   A__c   B__a   B__b   B__c 
#> "A__a" "A__b" "A__c" "B__a" "B__b" "B__c" 
tsl_colnames_get(tsl)
#> $A__a
#> [1] "x"
#> 
#> $A__b
#> [1] "x"
#> 
#> $A__c
#> [1] "x"
#> 
#> $B__a
#> [1] "x"
#> 
#> $B__b
#> [1] "x"
#> 
#> $B__c
#> [1] "x"
#> 

if(interactive()){
  tsl_plot(tsl)
}
```
