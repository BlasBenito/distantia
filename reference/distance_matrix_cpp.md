# (C++) Distance Matrix of Two Time Series

Computes the distance matrix between the rows of two matrices `y` and
`x` representing regular or irregular time series with the same number
of columns. NA values should be removed before using this function. If
the selected distance function is "chi" or "cosine", pairs of zeros
should be either removed or replaced with pseudo-zeros (i.e. 0.00001).

## Usage

``` r
distance_matrix_cpp(x, y, distance = "euclidean")
```

## Arguments

- x:

  (required, numeric matrix) univariate or multivariate time series.

- y:

  (required, numeric matrix) univariate or multivariate time series with
  the same number of columns as 'x'.

- distance:

  (optional, character string) distance name from the "names" column of
  the dataset `distances` (see `distances$name`). Default: "euclidean".

## Value

numeric matrix

## See also

Other Rcpp_matrix:
[`cost_matrix_diagonal_cpp()`](https://blasbenito.github.io/distantia/reference/cost_matrix_diagonal_cpp.md),
[`cost_matrix_diagonal_weighted_cpp()`](https://blasbenito.github.io/distantia/reference/cost_matrix_diagonal_weighted_cpp.md),
[`cost_matrix_orthogonal_cpp()`](https://blasbenito.github.io/distantia/reference/cost_matrix_orthogonal_cpp.md),
[`distance_ls_cpp()`](https://blasbenito.github.io/distantia/reference/distance_ls_cpp.md)

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
```
