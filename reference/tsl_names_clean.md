# Clean Time Series Names in a Time Series List

Combines
[`utils_clean_names()`](https://blasbenito.github.io/distantia/reference/utils_clean_names.md)
and
[`tsl_names_set()`](https://blasbenito.github.io/distantia/reference/tsl_names_set.md)
to help clean, abbreviate, capitalize, and add a suffix or a prefix to
time series list names.

## Usage

``` r
tsl_names_clean(
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

  (optional, character string) Suffix for the clean names. Default:
  NULL.

- prefix:

  (optional, character string) Prefix for the clean names. Default:
  NULL.

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
#initialize time series list
tsl <- tsl_initialize(
  x = fagus_dynamics,
  name_column = "name",
  time_column = "time"
)

#original names
tsl_names_get(
  tsl = tsl
)
#>   Germany     Spain    Sweden 
#> "Germany"   "Spain"  "Sweden" 

#abbreviate names
#---------------------------
tsl_clean <- tsl_names_clean(
  tsl = tsl,
  capitalize_first = TRUE,
  length = 4 #abbreviate to 4 characters
)

#new names
tsl_names_get(
  tsl = tsl_clean
)
#>   Grmn   Span   Swdn 
#> "Grmn" "Span" "Swdn" 

#suffix and prefix
#---------------------------
tsl_clean <- tsl_names_clean(
  tsl = tsl,
  capitalize_all = TRUE,
  separator = "_",
  suffix = "fagus",
  prefix = "country"
)

#new names
tsl_names_get(
  tsl = tsl_clean
)
#>   COUNTRY_GERMANY_FAGUS     COUNTRY_SPAIN_FAGUS    COUNTRY_SWEDEN_FAGUS 
#> "COUNTRY_GERMANY_FAGUS"   "COUNTRY_SPAIN_FAGUS"  "COUNTRY_SWEDEN_FAGUS" 
```
