# (C++) Sum Distances Between All Consecutive Samples in the Least Cost Path Between Two Time Series

Computes the cumulative auto sum of auto-distances of two time series
for the coordinates of a trimmed least cost path. The output value is
used as normalization factor when computing dissimilarity scores.

## Usage

``` r
auto_sum_path_cpp(x, y, path, distance = "euclidean")
```

## Arguments

- x:

  (required, numeric matrix) univariate or multivariate time series.

- y:

  (required, numeric matrix) univariate or multivariate time series with
  the same number of columns as 'x'.

- path:

  (required, data frame) least-cost path produced by
  [`cost_path_orthogonal_cpp()`](https://blasbenito.github.io/distantia/reference/cost_path_orthogonal_cpp.md).
  Default: NULL

- distance:

  (optional, character string) distance name from the "names" column of
  the dataset `distances` (see `distances$name`). Default: "euclidean".

## Value

numeric

## See also

Other Rcpp_auto_sum:
[`auto_distance_cpp()`](https://blasbenito.github.io/distantia/reference/auto_distance_cpp.md),
[`auto_sum_cpp()`](https://blasbenito.github.io/distantia/reference/auto_sum_cpp.md),
[`auto_sum_full_cpp()`](https://blasbenito.github.io/distantia/reference/auto_sum_full_cpp.md),
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
auto_sum_path_cpp(
  x = x,
  y = y,
  path = cost_path_trimmed,
  distance = "euclidean"
)
#> [1] 5.289003
```
