# Distance Matrix

Demonstration function to compute the distance matrix between two
univariate or multivariate time series.

This function does not accept NA data in the matrices `x` and `y`.

## Usage

``` r
psi_distance_matrix(x = NULL, y = NULL, distance = "euclidean")
```

## Arguments

- x:

  (required, zoo object or numeric matrix) a time series with no NAs.
  Default: NULL

- y:

  (zoo object or numeric matrix) a time series with the same columns as
  `x` and no NAs. Default: NULL

- distance:

  (optional, character vector) name or abbreviation of the distance
  method. Valid values are in the columns "names" and "abbreviation" of
  the dataset
  [distances](https://blasbenito.github.io/distantia/reference/distances.md).
  Default: "euclidean".

## Value

numeric matrix

## See also

Other psi_demo:
[`psi_auto_distance()`](https://blasbenito.github.io/distantia/reference/psi_auto_distance.md),
[`psi_auto_sum()`](https://blasbenito.github.io/distantia/reference/psi_auto_sum.md),
[`psi_cost_matrix()`](https://blasbenito.github.io/distantia/reference/psi_cost_matrix.md),
[`psi_cost_path()`](https://blasbenito.github.io/distantia/reference/psi_cost_path.md),
[`psi_cost_path_sum()`](https://blasbenito.github.io/distantia/reference/psi_cost_path_sum.md),
[`psi_distance_lock_step()`](https://blasbenito.github.io/distantia/reference/psi_distance_lock_step.md),
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

#distance matrix
dist_matrix <- psi_distance_matrix(
  x = x,
  y = y,
  distance = d
)

if(interactive()){
  utils_matrix_plot(
    m = dist_matrix
    )
}
```
