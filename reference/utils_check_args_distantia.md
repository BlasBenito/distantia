# Check Input Arguments of `distantia()`

Check Input Arguments of
[`distantia()`](https://blasbenito.github.io/distantia/reference/distantia.md)

## Usage

``` r
utils_check_args_distantia(
  tsl = NULL,
  distance = NULL,
  diagonal = NULL,
  bandwidth = NULL,
  lock_step = NULL,
  repetitions = NULL,
  permutation = NULL,
  block_size = NULL,
  seed = NULL
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

- repetitions:

  (optional, integer vector) number of permutations to compute the
  p-value. If 0, p-values are not computed. Otherwise, the minimum is 2.
  The resolution of the p-values and the overall computation time
  depends on the number of permutations. Default: 0

- permutation:

  (optional, character vector) permutation method, only relevant when
  `repetitions` is higher than zero. Valid values are:
  "restricted_by_row", "restricted", "free_by_row", and "free". Default:
  "restricted_by_row".

- block_size:

  (optional, integer) Size of the row blocks for the restricted
  permutation test. Only relevant when permutation methods are
  "restricted" or "restricted_by_row" and `repetitions` is higher than
  zero. A block of size `n` indicates that a row can only be permuted
  within a block of `n` adjacent rows. If NULL, defaults to the rounded
  one tenth of the shortest time series in `tsl`. Default: NULL.

- seed:

  (optional, integer) initial random seed to use for replicability when
  computing p-values. Default: 1

## Value

list

## See also

Other internal:
[`utils_boxplot_common()`](https://blasbenito.github.io/distantia/reference/utils_boxplot_common.md),
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
[`utils_prepare_zoo_list()`](https://blasbenito.github.io/distantia/reference/utils_prepare_zoo_list.md),
[`utils_tsl_pairs()`](https://blasbenito.github.io/distantia/reference/utils_tsl_pairs.md)
