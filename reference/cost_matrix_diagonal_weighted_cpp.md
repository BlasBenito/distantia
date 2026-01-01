# (C++) Compute Orthogonal and Weighted Diagonal Least Cost Matrix from a Distance Matrix

Computes the least cost matrix from a distance matrix. Weights diagonals
by a factor of 1.414214 (square root of 2) with respect to orthogonal
paths.

## Usage

``` r
cost_matrix_diagonal_weighted_cpp(dist_matrix)
```

## Arguments

- dist_matrix:

  (required, distance matrix). Distance matrix.

## Value

Least cost matrix.

## See also

Other Rcpp_matrix:
[`cost_matrix_diagonal_cpp()`](https://blasbenito.github.io/distantia/reference/cost_matrix_diagonal_cpp.md),
[`cost_matrix_orthogonal_cpp()`](https://blasbenito.github.io/distantia/reference/cost_matrix_orthogonal_cpp.md),
[`distance_ls_cpp()`](https://blasbenito.github.io/distantia/reference/distance_ls_cpp.md),
[`distance_matrix_cpp()`](https://blasbenito.github.io/distantia/reference/distance_matrix_cpp.md)
