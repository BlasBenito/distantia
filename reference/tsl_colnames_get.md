# Get Column Names from a Time Series Lists

Get Column Names from a Time Series Lists

## Usage

``` r
tsl_colnames_get(tsl = NULL, names = c("all", "shared", "exclusive"))
```

## Arguments

- tsl:

  (required, list) Time series list. Default: NULL

- names:

  (optional, character string) Three different sets of column names can
  be requested:

  - "all" (default): list with the column names in each zoo object in
    `tsl`. Unnamed columns are tagged with the string "unnamed".

  - "shared": character vector with the shared column names in at least
    two zoo objects in `tsl`.

  - "exclusive": list with names of exclusive columns (if any) in each
    zoo object in `tsl`.

## Value

list

## See also

Other tsl_management:
[`tsl_burst()`](https://blasbenito.github.io/distantia/reference/tsl_burst.md),
[`tsl_colnames_clean()`](https://blasbenito.github.io/distantia/reference/tsl_colnames_clean.md),
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
#generate example data
tsl <- tsl_simulate()

#list all column names
tsl_colnames_get(
  tsl = tsl,
  names = "all"
)
#> $A
#> [1] "a" "b" "c" "d" "e"
#> 
#> $B
#> [1] "a" "b" "c" "d" "e"
#> 

#change one column name
names(tsl[[1]])[1] <- "new_column"

#all names again
tsl_colnames_get(
  tsl = tsl,
  names = "all"
)
#> $A
#> [1] "new_column" "b"          "c"          "d"          "e"         
#> 
#> $B
#> [1] "a" "b" "c" "d" "e"
#> 

#shared column names
tsl_colnames_get(
  tsl = tsl,
  names = "shared"
)
#> $A
#> [1] "b" "c" "d" "e"
#> 
#> $B
#> [1] "b" "c" "d" "e"
#> 

#exclusive column names
tsl_colnames_get(
  tsl = tsl,
  names = "exclusive"
)
#> $A
#> [1] "new_column"
#> 
#> $B
#> [1] "a"
#> 
```
