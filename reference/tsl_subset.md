# Subset Time Series Lists by Time Series Names, Time, and/or Column Names

Subset Time Series Lists by Time Series Names, Time, and/or Column Names

## Usage

``` r
tsl_subset(
  tsl = NULL,
  names = NULL,
  colnames = NULL,
  time = NULL,
  numeric_cols = TRUE,
  shared_cols = TRUE
)
```

## Arguments

- tsl:

  (required, list) Time series list. Default: NULL

- names:

  (optional, character or numeric vector) Character vector of names or
  numeric vector with list indices. If NULL, all time series are kept.
  Default: NULL

- colnames:

  (optional, character vector) Column names of the zoo objects in `tsl`.
  If NULL, all columns are returned. Default: NULL

- time:

  (optional, numeric vector) time vector of length two used to subset
  rows by time. If NULL, all rows in `tsl` are preserved. Default: NULL

- numeric_cols:

  (optional, logical) If TRUE, only the numeric columns of the zoo
  objects are returned. Default: TRUE

- shared_cols:

  (optional, logical) If TRUE, only columns shared across all zoo
  objects are returned. Default: TRUE

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
[`tsl_names_set()`](https://blasbenito.github.io/distantia/reference/tsl_names_set.md),
[`tsl_names_test()`](https://blasbenito.github.io/distantia/reference/tsl_names_test.md),
[`tsl_ncol()`](https://blasbenito.github.io/distantia/reference/tsl_ncol.md),
[`tsl_nrow()`](https://blasbenito.github.io/distantia/reference/tsl_nrow.md),
[`tsl_repair()`](https://blasbenito.github.io/distantia/reference/tsl_repair.md),
[`tsl_time()`](https://blasbenito.github.io/distantia/reference/tsl_time.md),
[`tsl_to_df()`](https://blasbenito.github.io/distantia/reference/tsl_to_df.md)

## Examples

``` r
#initialize time series list
tsl <- tsl_initialize(
  x = fagus_dynamics,
  name_column = "name",
  time_column = "time"
)

#checking available dimensions

#names
tsl_names_get(
  tsl = tsl
)
#>   Germany     Spain    Sweden 
#> "Germany"   "Spain"  "Sweden" 

#colnames
tsl_colnames_get(
  tsl = tsl
)
#> $Germany
#> [1] "evi"         "rainfall"    "temperature"
#> 
#> $Spain
#> [1] "evi"         "rainfall"    "temperature"
#> 
#> $Sweden
#> [1] "evi"         "rainfall"    "temperature"
#> 

#time
tsl_time(
  tsl = tsl
)[, c("name", "begin", "end")]
#>      name      begin        end
#> 1 Germany 2001-01-01 2018-12-01
#> 2   Spain 2001-01-01 2018-12-01
#> 3  Sweden 2001-01-01 2018-12-01

#subset
tsl_new <- tsl_subset(
  tsl = tsl,
  names = c("Sweden", "Germany"),
  colnames = c("rainfall", "temperature"),
  time = c("2010-01-01", "2015-01-01")
)

#check new dimensions

#names
tsl_names_get(
  tsl = tsl_new
)
#>    Sweden   Germany 
#>  "Sweden" "Germany" 

#colnames
tsl_colnames_get(
  tsl = tsl_new
)
#> $Sweden
#> [1] "rainfall"    "temperature"
#> 
#> $Germany
#> [1] "rainfall"    "temperature"
#> 

#time
tsl_time(
  tsl = tsl_new
)[, c("name", "begin", "end")]
#>      name      begin        end
#> 1  Sweden 2010-01-01 2015-01-01
#> 2 Germany 2010-01-01 2015-01-01
```
