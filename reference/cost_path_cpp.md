# Least Cost Path

Least cost path between two time series `x` and `y`. NA values must be
removed from `x` and `y` before using this function. If the selected
distance function is "chi" or "cosine", pairs of zeros should be either
removed or replaced with pseudo-zeros (i.e. 0.00001).

## Usage

``` r
cost_path_cpp(
  x,
  y,
  distance = "euclidean",
  diagonal = TRUE,
  weighted = TRUE,
  ignore_blocks = FALSE,
  bandwidth = 1
)
```

## Arguments

- x:

  (required, numeric matrix) multivariate time series.

- y:

  (required, numeric matrix) multivariate time series with the same
  number of columns as 'x'.

- distance:

  (optional, character string) distance name from the "names" column of
  the dataset `distances` (see `distances$name`). Default: "euclidean".

- diagonal:

  (optional, logical). If TRUE, diagonals are included in the
  computation of the cost matrix. Default: TRUE.

- weighted:

  (optional, logical). Only relevant when diagonal is TRUE. When TRUE,
  diagonal cost is weighted by y factor of 1.414214 (square root of 2).
  Default: TRUE.

- ignore_blocks:

  (optional, logical). If TRUE, blocks of consecutive path coordinates
  are trimmed to avoid inflating the psi distance. Default: FALSE.

- bandwidth:

  (required, numeric) Size of the Sakoe-Chiba band at both sides of the
  diagonal used to constrain the least cost path. Expressed as a
  fraction of the number of matrix rows and columns. Unrestricted by
  default. Default: 1

## Value

data frame

## See also

Other Rcpp_cost_path:
[`cost_path_diagonal_bandwidth_cpp()`](https://blasbenito.github.io/distantia/reference/cost_path_diagonal_bandwidth_cpp.md),
[`cost_path_diagonal_cpp()`](https://blasbenito.github.io/distantia/reference/cost_path_diagonal_cpp.md),
[`cost_path_orthogonal_bandwidth_cpp()`](https://blasbenito.github.io/distantia/reference/cost_path_orthogonal_bandwidth_cpp.md),
[`cost_path_orthogonal_cpp()`](https://blasbenito.github.io/distantia/reference/cost_path_orthogonal_cpp.md),
[`cost_path_slotting_cpp()`](https://blasbenito.github.io/distantia/reference/cost_path_slotting_cpp.md),
[`cost_path_sum_cpp()`](https://blasbenito.github.io/distantia/reference/cost_path_sum_cpp.md),
[`cost_path_trim_cpp()`](https://blasbenito.github.io/distantia/reference/cost_path_trim_cpp.md)
