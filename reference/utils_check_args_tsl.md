# Structural Check for Time Series Lists

Internal function to check that a time series list is a list of zoo
objects and has a minimum number of objects. For a more comprehensive
test, use
[`tsl_diagnose()`](https://blasbenito.github.io/distantia/reference/tsl_diagnose.md).

## Usage

``` r
utils_check_args_tsl(tsl = NULL, min_length = 2)
```

## Arguments

- tsl:

  (required, list) list of zoo objects. Default: NULL

- min_length:

  (required, positive integer) minimum number of zoo objects in `tsl`.
  Default: 2

## Value

error messages (if any)

## See also

Other internal:
[`utils_boxplot_common()`](https://blasbenito.github.io/distantia/reference/utils_boxplot_common.md),
[`utils_check_args_distantia()`](https://blasbenito.github.io/distantia/reference/utils_check_args_distantia.md),
[`utils_check_args_matrix()`](https://blasbenito.github.io/distantia/reference/utils_check_args_matrix.md),
[`utils_check_args_momentum()`](https://blasbenito.github.io/distantia/reference/utils_check_args_momentum.md),
[`utils_check_args_path()`](https://blasbenito.github.io/distantia/reference/utils_check_args_path.md),
[`utils_check_args_zoo()`](https://blasbenito.github.io/distantia/reference/utils_check_args_zoo.md),
[`utils_check_distance_args()`](https://blasbenito.github.io/distantia/reference/utils_check_distance_args.md),
[`utils_check_list_class()`](https://blasbenito.github.io/distantia/reference/utils_check_list_class.md),
[`utils_clean_names()`](https://blasbenito.github.io/distantia/reference/utils_clean_names.md),
[`utils_digits()`](https://blasbenito.github.io/distantia/reference/utils_digits.md),
[`utils_distantia_df_split()`](https://blasbenito.github.io/distantia/reference/utils_distantia_df_split.md),
[`utils_prepare_df()`](https://blasbenito.github.io/distantia/reference/utils_prepare_df.md),
[`utils_prepare_matrix()`](https://blasbenito.github.io/distantia/reference/utils_prepare_matrix.md),
[`utils_prepare_matrix_list()`](https://blasbenito.github.io/distantia/reference/utils_prepare_matrix_list.md),
[`utils_prepare_time()`](https://blasbenito.github.io/distantia/reference/utils_prepare_time.md),
[`utils_prepare_vector_list()`](https://blasbenito.github.io/distantia/reference/utils_prepare_vector_list.md),
[`utils_prepare_zoo_list()`](https://blasbenito.github.io/distantia/reference/utils_prepare_zoo_list.md),
[`utils_tsl_pairs()`](https://blasbenito.github.io/distantia/reference/utils_tsl_pairs.md)
