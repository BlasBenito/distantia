# Data Frame with Pairs of Time Series in Time Series Lists

Internal function used in
[`distantia()`](https://blasbenito.github.io/distantia/reference/distantia.md)
and
[`momentum()`](https://blasbenito.github.io/distantia/reference/momentum.md)
to generate a data frame with combinations of time series and function
arguments.

## Usage

``` r
utils_tsl_pairs(tsl = NULL, args_list = NULL)
```

## Arguments

- tsl:

  (required, list) Time series list. Default: NULL

- args_list:

  (required, list) arguments to combine with the pairs of time series.
  Default: NULL

## Value

data frame

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
[`utils_clean_names()`](https://blasbenito.github.io/distantia/reference/utils_clean_names.md),
[`utils_digits()`](https://blasbenito.github.io/distantia/reference/utils_digits.md),
[`utils_distantia_df_split()`](https://blasbenito.github.io/distantia/reference/utils_distantia_df_split.md),
[`utils_prepare_df()`](https://blasbenito.github.io/distantia/reference/utils_prepare_df.md),
[`utils_prepare_matrix()`](https://blasbenito.github.io/distantia/reference/utils_prepare_matrix.md),
[`utils_prepare_matrix_list()`](https://blasbenito.github.io/distantia/reference/utils_prepare_matrix_list.md),
[`utils_prepare_time()`](https://blasbenito.github.io/distantia/reference/utils_prepare_time.md),
[`utils_prepare_vector_list()`](https://blasbenito.github.io/distantia/reference/utils_prepare_vector_list.md),
[`utils_prepare_zoo_list()`](https://blasbenito.github.io/distantia/reference/utils_prepare_zoo_list.md)
