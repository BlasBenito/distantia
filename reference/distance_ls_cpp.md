# (C++) Sum of Pairwise Distances Between Cases in Two Aligned Time Series

Computes the lock-step sum of distances between two regular and aligned
time series. NA values should be removed before using this function. If
the selected distance function is "chi" or "cosine", pairs of zeros
should be either removed or replaced with pseudo-zeros (i.e. 0.00001).

## Usage

``` r
distance_ls_cpp(x, y, distance = "euclidean")
```

## Arguments

- x:

  (required, numeric matrix) univariate or multivariate time series.

- y:

  (required, numeric matrix) univariate or multivariate time series with
  the same number of columns and rows as 'x'.

- distance:

  (optional, character string) distance name from the "names" column of
  the dataset `distances` (see `distances$name`). Default: "euclidean".

## Value

numeric

## See also

Other Rcpp_matrix:
[`cost_matrix_diagonal_cpp()`](https://blasbenito.github.io/distantia/reference/cost_matrix_diagonal_cpp.md),
[`cost_matrix_diagonal_weighted_cpp()`](https://blasbenito.github.io/distantia/reference/cost_matrix_diagonal_weighted_cpp.md),
[`cost_matrix_orthogonal_cpp()`](https://blasbenito.github.io/distantia/reference/cost_matrix_orthogonal_cpp.md),
[`distance_matrix_cpp()`](https://blasbenito.github.io/distantia/reference/distance_matrix_cpp.md)

## Examples

``` r
#simulate two regular time series
x <- zoo_simulate(
  seed = 1,
  irregular = FALSE
  )
y <- zoo_simulate(
  seed = 2,
  irregular = FALSE
  )

#distance matrix
dist_matrix <- distance_ls_cpp(
  x = x,
  y = y,
  distance = "euclidean"
)
```
