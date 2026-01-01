# Clean Character Vector of Names

Clean and format character vectors for use as column names or variable
names.

## Usage

``` r
utils_clean_names(
  x = NULL,
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

- x:

  (required, character vector) Names to be cleaned. Default: NULL

- lowercase:

  (optional, logical) If TRUE, all names are coerced to lowercase.
  Default: FALSE

- separator:

  (optional, character string) Separator when replacing spaces and dots
  and appending `suffix` and `prefix` to the main word. Default: "\_".

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

  (optional, character string) String to append to the cleaned names.
  Default: NULL.

- prefix:

  (optional, character string) String to prepend to the cleaned names.
  Default: NULL.

## Value

character vector

## Details

The cleanup operations are applied in the following order:

- Remove leading and trailing whitespaces.

- Generates syntactically valid names with
  [`base::make.names()`](https://rdrr.io/r/base/make.names.html).

- Replaces dots and spaces with the `separator`.

- Coerces names to lowercase.

- If argument `length` is provided,
  [`base::abbreviate()`](https://rdrr.io/r/base/abbreviate.html) is used
  to abbreviate the new column names.

- If `suffix` is provided, it is added at the end of the column name
  using the separator.

- If `prefix` is provided, it is added at the beginning of the column
  name using the separator.

- If `capitalize_first = TRUE`, the first letter is capitalized.

- If `capitalize_all = TRUE`, all letters are capitalized.

## See also

Other internal:
[`utils_boxplot_common()`](https://blasbenito.github.io/distantia/reference/utils_boxplot_common.md),
[`utils_check_args_distantia()`](https://blasbenito.github.io/distantia/reference/utils_check_args_distantia.md),
[`utils_check_args_matrix()`](https://blasbenito.github.io/distantia/reference/utils_check_args_matrix.md),
[`utils_check_args_momentum()`](https://blasbenito.github.io/distantia/reference/utils_check_args_momentum.md),
[`utils_check_args_path()`](https://blasbenito.github.io/distantia/reference/utils_check_args_path.md),
[`utils_check_args_tsl()`](https://blasbenito.github.io/distantia/reference/utils_check_args_tsl.md),
[`utils_check_args_zoo()`](https://blasbenito.github.io/distantia/reference/utils_check_args_zoo.md),
[`utils_check_distance_args()`](https://blasbenito.github.io/distantia/reference/utils_check_distance_args.md),
[`utils_check_list_class()`](https://blasbenito.github.io/distantia/reference/utils_check_list_class.md),
[`utils_digits()`](https://blasbenito.github.io/distantia/reference/utils_digits.md),
[`utils_distantia_df_split()`](https://blasbenito.github.io/distantia/reference/utils_distantia_df_split.md),
[`utils_prepare_df()`](https://blasbenito.github.io/distantia/reference/utils_prepare_df.md),
[`utils_prepare_matrix()`](https://blasbenito.github.io/distantia/reference/utils_prepare_matrix.md),
[`utils_prepare_matrix_list()`](https://blasbenito.github.io/distantia/reference/utils_prepare_matrix_list.md),
[`utils_prepare_time()`](https://blasbenito.github.io/distantia/reference/utils_prepare_time.md),
[`utils_prepare_vector_list()`](https://blasbenito.github.io/distantia/reference/utils_prepare_vector_list.md),
[`utils_prepare_zoo_list()`](https://blasbenito.github.io/distantia/reference/utils_prepare_zoo_list.md),
[`utils_tsl_pairs()`](https://blasbenito.github.io/distantia/reference/utils_tsl_pairs.md)

## Examples

``` r
x <- c(
  "GerMany",
  "spain",
  "SWEDEN"
)

#abbreviate names
#---------------------------
#abbreviate to 4 characters
utils_clean_names(
  x = x,
  capitalize_all = TRUE,
  length = 4
)
#> GerMany   spain  SWEDEN 
#>  "GRMN"  "SPAN"  "SWED" 

#suffix and prefix
#---------------------------
utils_clean_names(
  x = x,
  capitalize_first = TRUE,
  separator = "_",
  prefix = "my_prefix",
  suffix = "my_suffix"
)
#>                       GerMany                         spain 
#> "My_prefix_GerMany_my_suffix"   "My_prefix_spain_my_suffix" 
#>                        SWEDEN 
#>  "My_prefix_SWEDEN_my_suffix" 
```
