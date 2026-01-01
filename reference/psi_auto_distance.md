# Cumulative Sum of Distances Between Consecutive Cases in a Time Series

Demonstration function to compute the sum of distances between
consecutive cases in a time series.

## Usage

``` r
psi_auto_distance(x = NULL, distance = "euclidean")
```

## Arguments

- x:

  (required, zoo object or matrix) univariate or multivariate time
  series with no NAs. Default: NULL

- distance:

  (optional, character vector) name or abbreviation of the distance
  method. Valid values are in the columns "names" and "abbreviation" of
  the dataset
  [distances](https://blasbenito.github.io/distantia/reference/distances.md).
  Default: "euclidean".

## Value

numeric value

## See also

Other psi_demo:
[`psi_auto_sum()`](https://blasbenito.github.io/distantia/reference/psi_auto_sum.md),
[`psi_cost_matrix()`](https://blasbenito.github.io/distantia/reference/psi_cost_matrix.md),
[`psi_cost_path()`](https://blasbenito.github.io/distantia/reference/psi_cost_path.md),
[`psi_cost_path_sum()`](https://blasbenito.github.io/distantia/reference/psi_cost_path_sum.md),
[`psi_distance_lock_step()`](https://blasbenito.github.io/distantia/reference/psi_distance_lock_step.md),
[`psi_distance_matrix()`](https://blasbenito.github.io/distantia/reference/psi_distance_matrix.md),
[`psi_equation()`](https://blasbenito.github.io/distantia/reference/psi_equation.md)

## Examples

``` r
#distance metric
d <- "euclidean"

#simulate zoo time series
x <- zoo_simulate(
  name = "x",
  rows = 100,
  seasons = 2,
  seed = 1
)

#sum distance between consecutive samples
psi_auto_distance(
  x = x,
  distance = d
)
#> [1] 6.921253
```
