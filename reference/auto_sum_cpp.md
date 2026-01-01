# (C++) Sum Distances Between Consecutive Samples in Two Time Series

Sum of auto-distances of two time series. This function switches between
[`auto_sum_full_cpp()`](https://blasbenito.github.io/distantia/reference/auto_sum_full_cpp.md)
and
[`auto_sum_path_cpp()`](https://blasbenito.github.io/distantia/reference/auto_sum_path_cpp.md)
depending on the value of the argument `ignore_blocks`.

## Usage

``` r
auto_sum_cpp(x, y, path, distance = "euclidean", ignore_blocks = FALSE)
```

## Arguments

- x:

  (required, numeric matrix) of same number of columns as 'y'.

- y:

  (required, numeric matrix) of same number of columns as 'x'.

- path:

  (required, data frame) output of
  [`cost_path_orthogonal_cpp()`](https://blasbenito.github.io/distantia/reference/cost_path_orthogonal_cpp.md).

- distance:

  (optional, character string) distance name from the "names" column of
  the dataset `distances` (see `distances$name`). Default: "euclidean"

- ignore_blocks:

  (optional, logical). If TRUE, blocks of consecutive path coordinates
  are trimmed to avoid inflating the psi distance. Default: FALSE.

## Value

numeric

## See also

Other Rcpp_auto_sum:
[`auto_distance_cpp()`](https://blasbenito.github.io/distantia/reference/auto_distance_cpp.md),
[`auto_sum_full_cpp()`](https://blasbenito.github.io/distantia/reference/auto_sum_full_cpp.md),
[`auto_sum_path_cpp()`](https://blasbenito.github.io/distantia/reference/auto_sum_path_cpp.md),
[`subset_matrix_by_rows_cpp()`](https://blasbenito.github.io/distantia/reference/subset_matrix_by_rows_cpp.md)

## Examples

``` r
#simulate two time series
x <- zoo_simulate(seed = 1)
y <- zoo_simulate(seed = 2)

#distance matrix
dist_matrix <- distance_matrix_cpp(
  x = x,
  y = y,
  distance = "euclidean"
)

#least cost matrix
cost_matrix <- cost_matrix_orthogonal_cpp(
  dist_matrix = dist_matrix
)

#least cost path
cost_path <- cost_path_orthogonal_cpp(
  dist_matrix = dist_matrix,
  cost_matrix = cost_matrix
)

nrow(cost_path)
#> [1] 199

#remove blocks from least-cost path
cost_path_trimmed <- cost_path_trim_cpp(
  path = cost_path
)

nrow(cost_path_trimmed)
#> [1] 29

#auto sum
auto_sum_cpp(
  x = x,
  y = y,
  path = cost_path_trimmed,
  distance = "euclidean",
  ignore_blocks = FALSE
)
#> [1] 17.12273
```
