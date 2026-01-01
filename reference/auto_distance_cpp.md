# (C++) Sum Distances Between Consecutive Samples in a Time Series

Computes the cumulative sum of distances between consecutive samples in
a univariate or multivariate time series. NA values should be removed
before using this function.

## Usage

``` r
auto_distance_cpp(x, distance = "euclidean")
```

## Arguments

- x:

  (required, numeric matrix) univariate or multivariate time series.

- distance:

  (optional, character string) distance name from the "names" column of
  the dataset `distances` (see `distances$name`). Default: "euclidean"

## Value

numeric

## See also

Other Rcpp_auto_sum:
[`auto_sum_cpp()`](https://blasbenito.github.io/distantia/reference/auto_sum_cpp.md),
[`auto_sum_full_cpp()`](https://blasbenito.github.io/distantia/reference/auto_sum_full_cpp.md),
[`auto_sum_path_cpp()`](https://blasbenito.github.io/distantia/reference/auto_sum_path_cpp.md),
[`subset_matrix_by_rows_cpp()`](https://blasbenito.github.io/distantia/reference/subset_matrix_by_rows_cpp.md)

## Examples

``` r
#simulate a time series
x <- zoo_simulate()

#compute auto distance
auto_distance_cpp(
  x = x,
  distance = "euclidean"
  )
#> [1] 9.474722
```
