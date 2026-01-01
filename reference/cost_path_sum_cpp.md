# (C++) Sum Distances in a Least Cost Path

(C++) Sum Distances in a Least Cost Path

## Usage

``` r
cost_path_sum_cpp(path)
```

## Arguments

- path:

  (required, data frame) least-cost path produced by
  [`cost_path_orthogonal_cpp()`](https://blasbenito.github.io/distantia/reference/cost_path_orthogonal_cpp.md).

## Value

numeric

## See also

Other Rcpp_cost_path:
[`cost_path_cpp()`](https://blasbenito.github.io/distantia/reference/cost_path_cpp.md),
[`cost_path_diagonal_bandwidth_cpp()`](https://blasbenito.github.io/distantia/reference/cost_path_diagonal_bandwidth_cpp.md),
[`cost_path_diagonal_cpp()`](https://blasbenito.github.io/distantia/reference/cost_path_diagonal_cpp.md),
[`cost_path_orthogonal_bandwidth_cpp()`](https://blasbenito.github.io/distantia/reference/cost_path_orthogonal_bandwidth_cpp.md),
[`cost_path_orthogonal_cpp()`](https://blasbenito.github.io/distantia/reference/cost_path_orthogonal_cpp.md),
[`cost_path_slotting_cpp()`](https://blasbenito.github.io/distantia/reference/cost_path_slotting_cpp.md),
[`cost_path_trim_cpp()`](https://blasbenito.github.io/distantia/reference/cost_path_trim_cpp.md)

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
cost_path <- cost_path_slotting_cpp(
  dist_matrix = dist_matrix,
  cost_matrix = cost_matrix
)

cost_path_sum_cpp(
  path = cost_path
  )
#> [1] 66.25985
```
