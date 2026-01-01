# Clean Column Names in Time Series Lists

Uses the function
[`utils_clean_names()`](https://blasbenito.github.io/distantia/reference/utils_clean_names.md)
to simplify and normalize messy column names in a time series list.

The cleanup operations are applied in the following order:

- Remove leading and trailing whitespaces.

- Generates syntactically valid names with
  [`base::make.names()`](https://rdrr.io/r/base/make.names.html).

- Replaces dots and spaces with the `separator`.

- Coerces names to lowercase.

- If `capitalize_first = TRUE`, the first letter is capitalized.

- If `capitalize_all = TRUE`, all letters are capitalized.

- If argument `length` is provided,
  [`base::abbreviate()`](https://rdrr.io/r/base/abbreviate.html) is used
  to abbreviate the new column names.

- If `suffix` is provided, it is added at the end of the column name
  using the separator.

- If `prefix` is provided, it is added at the beginning of the column
  name using the separator.

## Usage

``` r
tsl_colnames_clean(
  tsl = NULL,
  lowercase = FALSE,
  separator = "_",
  capitalize_first = FALSE,
  capitalize_all = FALSE,
  length = NULL,
  suffix = NULL,
  prefix = NULL
)
```

## Arguments

- tsl:

  (required, list) Time series list. Default: NULL

- lowercase:

  (optional, logical) If TRUE, all names are coerced to lowercase.
  Default: FALSE

- separator:

  (optional, character string) Separator when replacing spaces and dots.
  Also used to separate `suffix` and `prefix` from the main word.
  Default: "\_".

- capitalize_first:

  (optional, logical) Indicates whether to capitalize the first letter
  of each name Default: FALSE.

- capitalize_all:

  (optional, logical) Indicates whether to capitalize all letters of
  each name Default: FALSE.

- length:

  (optional, integer) Minimum length of abbreviated names. Names are
  abbreviated via
  [`abbreviate()`](https://rdrr.io/r/base/abbreviate.html). Default:
  NULL.

- suffix:

  (optional, character string) String to append to the column names.
  Default: NULL.

- prefix:

  (optional, character string) String to prepend to the column names.
  Default: NULL.

## Value

time series list

## See also

Other tsl_management:
[`tsl_burst()`](https://blasbenito.github.io/distantia/reference/tsl_burst.md),
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
#generate example data
tsl <- tsl_simulate(cols = 3)

#list all column names
tsl_colnames_get(
  tsl = tsl
)
#> $A
#> [1] "a" "b" "c"
#> 
#> $B
#> [1] "a" "b" "c"
#> 

#rename columns
tsl <- tsl_colnames_set(
  tsl = tsl,
  names = c(
  "New name 1",
  "new Name 2",
  "NEW NAME 3"
  )
)

#check new names
tsl_colnames_get(
  tsl = tsl,
  names = "all"
)
#> $A
#> [1] "New name 1" "new Name 2" "NEW NAME 3"
#> 
#> $B
#> [1] "New name 1" "new Name 2" "NEW NAME 3"
#> 

#clean names
tsl <- tsl_colnames_clean(
  tsl = tsl
)

tsl_colnames_get(
  tsl = tsl
)
#> $A
#> [1] "New_name_1" "new_Name_2" "NEW_NAME_3"
#> 
#> $B
#> [1] "New_name_1" "new_Name_2" "NEW_NAME_3"
#> 

#abbreviated
tsl <- tsl_colnames_clean(
  tsl = tsl,
  capitalize_first = TRUE,
  length = 6,
  suffix = "clean"
)

tsl_colnames_get(
  tsl = tsl
)
#> $A
#> [1] "Nw_n_1_clean" "Nw_N_2_clean" "NEW_NA_clean"
#> 
#> $B
#> [1] "Nw_n_1_clean" "Nw_N_2_clean" "NEW_NA_clean"
#> 
```
