# Coerce Coredata of Univariate Zoo Time Series to Matrix

Transforms vector coredata of univariate zoo time series to class
matrix. If the input zoo time series has the attribute "name", the
output inherits the value of such attribute.

Multivariate zoo objects are returned without changes.

## Usage

``` r
zoo_vector_to_matrix(x = NULL, name = NULL)
```

## Arguments

- x:

  (required, zoo object) zoo time series. Default: NULL

- name:

  (required, character string) name of the matrix column. Default: NULL

## Value

zoo time series

## See also

Other zoo_functions:
[`zoo_aggregate()`](https://blasbenito.github.io/distantia/reference/zoo_aggregate.md),
[`zoo_name_clean()`](https://blasbenito.github.io/distantia/reference/zoo_name_clean.md),
[`zoo_name_get()`](https://blasbenito.github.io/distantia/reference/zoo_name_get.md),
[`zoo_name_set()`](https://blasbenito.github.io/distantia/reference/zoo_name_set.md),
[`zoo_permute()`](https://blasbenito.github.io/distantia/reference/zoo_permute.md),
[`zoo_plot()`](https://blasbenito.github.io/distantia/reference/zoo_plot.md),
[`zoo_resample()`](https://blasbenito.github.io/distantia/reference/zoo_resample.md),
[`zoo_smooth_exponential()`](https://blasbenito.github.io/distantia/reference/zoo_smooth_exponential.md),
[`zoo_smooth_window()`](https://blasbenito.github.io/distantia/reference/zoo_smooth_window.md),
[`zoo_time()`](https://blasbenito.github.io/distantia/reference/zoo_time.md),
[`zoo_to_tsl()`](https://blasbenito.github.io/distantia/reference/zoo_to_tsl.md)

## Examples

``` r
#create zoo object from vector
x <- zoo::zoo(
  x = runif(100)
)

#coredata is not a matrix
is.matrix(zoo::coredata(x))
#> [1] FALSE

#convert to matrix
y <- zoo_vector_to_matrix(
  x = x
)

#coredata is now a matrix
is.matrix(zoo::coredata(y))
#> [1] TRUE
```
