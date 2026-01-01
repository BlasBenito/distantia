# Sum of Distances in Least Cost Path

Demonstration function to sum the distances of a least cost path.

## Usage

``` r
psi_cost_path_sum(path = NULL)
```

## Arguments

- path:

  (required, data frame) least cost path produced by
  [`psi_cost_path()`](https://blasbenito.github.io/distantia/reference/psi_cost_path.md).
  Default: NULL

## Value

numeric value

## See also

Other psi_demo:
[`psi_auto_distance()`](https://blasbenito.github.io/distantia/reference/psi_auto_distance.md),
[`psi_auto_sum()`](https://blasbenito.github.io/distantia/reference/psi_auto_sum.md),
[`psi_cost_matrix()`](https://blasbenito.github.io/distantia/reference/psi_cost_matrix.md),
[`psi_cost_path()`](https://blasbenito.github.io/distantia/reference/psi_cost_path.md),
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

#distance matrix
dist_matrix <- psi_distance_matrix(
  x = x,
  y = y,
  distance = d
)

#orthogonal least cost matrix
cost_matrix <- psi_cost_matrix(
  dist_matrix = dist_matrix
)

#orthogonal least cost path
cost_path <- psi_cost_path(
  dist_matrix = dist_matrix,
  cost_matrix = cost_matrix
)

#sum of distances in cost path
psi_cost_path_sum(
  path = cost_path
)
#> [1] 44.81312
```
