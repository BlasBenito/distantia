# Auto Sum

Demonstration function to computes the sum of distances between
consecutive samples in two time series.

## Usage

``` r
psi_auto_sum(x = NULL, y = NULL, distance = "euclidean")
```

## Arguments

- x:

  (required, zoo object or numeric matrix) univariate or multivariate
  time series with no NAs. Default: NULL.

- y:

  (required, zoo object or numeric matrix) a time series with the same
  number of columns as `x` and no NAs. Default: NULL.

- distance:

  (optional, character vector) name or abbreviation of the distance
  method. Valid values are in the columns "names" and "abbreviation" of
  the dataset
  [distances](https://blasbenito.github.io/distantia/reference/distances.md).
  Default: "euclidean".

## Value

numeric vector

## See also

Other psi_demo:
[`psi_auto_distance()`](https://blasbenito.github.io/distantia/reference/psi_auto_distance.md),
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

#simulate two irregular time series
x <- zoo_simulate(
  name = "x",
  rows = 100,
  seasons = 2,
  seed = 1
)

y <- zoo_simulate(
  name = "y",
  rows = 80,
  seasons = 2,
  seed = 2
)

if(interactive()){
  zoo_plot(x = x)
  zoo_plot(x = y)
}

#auto sum of distances
psi_auto_sum(
  x = x,
  y = y,
  distance = d
)
#> [1] 14.79953

#same as:
x_sum <- psi_auto_distance(
  x = x,
  distance = d
)

y_sum <- psi_auto_distance(
  x = y,
  distance = d
)

x_sum + y_sum
#> [1] 14.79953
```
