# (C++) Compute Orthogonal and Diagonal Least Cost Matrix from a Distance Matrix

Computes the least cost matrix from a distance matrix. Considers
diagonals during computation of least-costs.

## Usage

``` r
cost_matrix_diagonal_cpp(dist_matrix)
```

## Arguments

- dist_matrix:

  (required, distance matrix). Square distance matrix, output of
  [`distance_matrix_cpp()`](https://blasbenito.github.io/distantia/reference/distance_matrix_cpp.md).

## Value

Least cost matrix.

## See also

Other Rcpp_matrix:
[`cost_matrix_diagonal_weighted_cpp()`](https://blasbenito.github.io/distantia/reference/cost_matrix_diagonal_weighted_cpp.md),
[`cost_matrix_orthogonal_cpp()`](https://blasbenito.github.io/distantia/reference/cost_matrix_orthogonal_cpp.md),
[`distance_ls_cpp()`](https://blasbenito.github.io/distantia/reference/distance_ls_cpp.md),
[`distance_matrix_cpp()`](https://blasbenito.github.io/distantia/reference/distance_matrix_cpp.md)
