# Check Input Arguments of `momentum()`

Check Input Arguments of
[`momentum()`](https://blasbenito.github.io/distantia/reference/momentum.md)

## Usage

``` r
utils_check_args_momentum(
  tsl = NULL,
  distance = NULL,
  diagonal = NULL,
  bandwidth = NULL,
  lock_step = NULL,
  robust = NULL
)
```

## Arguments

- tsl:

  (required, time series list) list of zoo time series. Default: NULL

- distance:

  (optional, character vector) name or abbreviation of the distance
  method. Valid values are in the columns "names" and "abbreviation" of
  the dataset
  [distances](https://blasbenito.github.io/distantia/reference/distances.md).
  Default: "euclidean".

- diagonal:

  (optional, logical vector). If TRUE, diagonals are included in the
  dynamic time warping computation. Default: TRUE

- bandwidth:

  (optional, numeric) Proportion of space at each side of the cost
  matrix diagonal (aka *Sakoe-Chiba band*) defining a valid region for
  dynamic time warping, used to control the flexibility of the warping
  path. This method prevents degenerate alignments due to differences in
  magnitude between time series when the data is not properly scaled. If
  `1` (default), DTW is unconstrained. If `0`, DTW is fully constrained
  and the warping path follows the matrix diagonal. Recommended values
  may vary depending on the nature of the data. Ignored if
  `lock_step = TRUE`. Default: 1.

- lock_step:

  (optional, logical vector) If TRUE, time series captured at the same
  times are compared sample wise (with no dynamic time warping).
  Requires time series in argument `tsl` to be fully aligned, or it will
  return an error. Default: FALSE.

- robust:

  (required, logical). If TRUE (default), importance scores are computed
  using the least cost path of the complete time series as reference.
  Setting it to FALSE allows to replicate importance scores of the
  previous versions of this package. This option is irrelevant when
  `lock_step = TRUE`. Default: TRUE

## Value

list

## See also

Other internal:
[`utils_boxplot_common()`](https://blasbenito.github.io/distantia/reference/utils_boxplot_common.md),
[`utils_check_args_distantia()`](https://blasbenito.github.io/distantia/reference/utils_check_args_distantia.md),
[`utils_check_args_matrix()`](https://blasbenito.github.io/distantia/reference/utils_check_args_matrix.md),
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
[`utils_prepare_zoo_list()`](https://blasbenito.github.io/distantia/reference/utils_prepare_zoo_list.md),
[`utils_tsl_pairs()`](https://blasbenito.github.io/distantia/reference/utils_tsl_pairs.md)
