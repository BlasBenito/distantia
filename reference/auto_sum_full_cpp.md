# (C++) Sum Distances Between All Consecutive Samples in Two Time Series

Computes the cumulative auto sum of autodistances of two time series.
The output value is used as normalization factor when computing
dissimilarity scores.

## Usage

``` r
auto_sum_full_cpp(x, y, distance = "euclidean")
```

## Arguments

- x:

  (required, numeric matrix) univariate or multivariate time series.

- y:

  (required, numeric matrix) univariate or multivariate time series with
  the same number of columns as 'x'.

- distance:

  (optional, character string) distance name from the "names" column of
  the dataset `distances` (see `distances$name`). Default: "euclidean"

## Value

numeric

## See also

Other Rcpp_auto_sum:
[`auto_distance_cpp()`](https://blasbenito.github.io/distantia/reference/auto_distance_cpp.md),
[`auto_sum_cpp()`](https://blasbenito.github.io/distantia/reference/auto_sum_cpp.md),
[`auto_sum_path_cpp()`](https://blasbenito.github.io/distantia/reference/auto_sum_path_cpp.md),
[`subset_matrix_by_rows_cpp()`](https://blasbenito.github.io/distantia/reference/subset_matrix_by_rows_cpp.md)

## Examples

``` r
#simulate two time series
x <- zoo_simulate(seed = 1)
y <- zoo_simulate(seed = 2)

#auto sum
auto_sum_full_cpp(
  x = x,
  y = y,
  distance = "euclidean"
)
#> [1] 17.12273
```
