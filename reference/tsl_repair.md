# Repair Issues in Time Series Lists

A Time Series List (`tsl` for short) is a list of zoo time series. This
type of object, not defined as a class, is used throughout the
`distantia` package to contain time series data ready for processing and
analysis.

The structure and values of a `tsl` must fulfill several general
conditions:

Structure:

- The list names match the attributes "name" of the zoo time series

- All zoo time series must have at least one shared column name.

- Data in univariate zoo time series (as extracted by
  `zoo::coredata(x)`) must be of the class "matrix". Univariate zoo time
  series are often represented as vectors, but this breaks several
  subsetting and transformation operations implemented in this package.

Values (optional, when `full = TRUE`):

- All time series have at least one shared numeric column.

- There are no NA, Inf, or NaN values in the time series.

This function analyzes a `tsl`, and tries to fix all possible issues to
make it comply with the conditions listed above without any user input.
Use with care, as it might defile your data.

## Usage

``` r
tsl_repair(tsl = NULL, full = TRUE)
```

## Arguments

- tsl:

  (required, list) Time series list. Default: NULL

- full:

  (optional, logical) If TRUE, a full repair (structure and values) is
  triggered. Otherwise, only the data structure is repaired Default:
  TRUE

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
[`tsl_subset()`](https://blasbenito.github.io/distantia/reference/tsl_subset.md),
[`tsl_time()`](https://blasbenito.github.io/distantia/reference/tsl_time.md),
[`tsl_to_df()`](https://blasbenito.github.io/distantia/reference/tsl_to_df.md)

## Examples

``` r
#creating three zoo time series

#one with NA values
x <- zoo_simulate(
  name = "x",
  cols = 1,
  na_fraction = 0.1
  )

#with different number of columns
#wit repeated name
y <- zoo_simulate(
  name = "x",
  cols = 2
  )

#with different time class
z <- zoo_simulate(
  name = "z",
  cols = 1,
  time_range = c(1, 100)
  )

#adding a few structural issues

#changing the column name of x
colnames(x) <- c("b")

#converting z to vector
z <- zoo::zoo(
  x = runif(nrow(z)),
  order.by = zoo::index(z)
)

#storing zoo objects in a list
#with mismatched names
tsl <- list(
  a = x,
  b = y,
  c = z
)

#running full diagnose
tsl_diagnose(
  tsl = tsl,
  full = TRUE
  )
#> distantia::tsl_diagnose(): issues in TSL structure:
#> ---------------------------------------------------
#> 
#>   - core data of univariate zoo time series must be of class 'matrix': use lapply(tsl, distantia::zoo_vector_to_matrix) to fix this issue.
#> 
#>   - list and time series names must match and be unique: reset names with distantia::tsl_names_set().
#> 
#>   - missing column names in zoo time series: use distantia::tsl_colnames_set() to rename columns as needed.
#> 
#>   - no shared column names across time series: use distantia::tsl_colnames_get() and distantia::ts_colnames_set() to identify and rename columns as needed.
#> 
#>   - time in all time series must be of the same class: use lapply(tsl, function(x) class(zoo::index(x))) to identify and remove or modify the objects with a mismatching class.
#> 
#> distantia::tsl_diagnose(): issues in TSL values:
#> --------------------------------------------------
#> 
#>   - there are NA, Inf, -Inf, or NaN cases in the time series: interpolate or remove them with distantia::tsl_handle_NA().

tsl <- tsl_repair(tsl)
#> distantia::tsl_repair(): repairs in TSL structure:
#> --------------------------------------------------
#> 
#>   - converted univariate zoo vectors to matrix.
#> 
#>   - fixed naming issues.
#> 
#>   - REPAIR FAILED: cannot repair missing column names in zoo time series.
#> 
#>   - REPAIR FAILED: no valid shared column names found across all time series.
#> 
#>   - removed exclusive columns not shared across time series.
#> 
#> distantia::tsl_repair(): repairs in TSL values:
#> -------------------------------------------------
#> 
#>   - interpolated NA cases in zoo objects with distantia::tsl_handle_NA().
#> 
#> 
#> distantia::tsl_diagnose(): issues in TSL structure:
#> ---------------------------------------------------
#> 
#>   - no shared column names across time series: use distantia::tsl_colnames_get() and distantia::ts_colnames_set() to identify and rename columns as needed.
#> 
#>   - time in all time series must be of the same class: use lapply(tsl, function(x) class(zoo::index(x))) to identify and remove or modify the objects with a mismatching class.
```
