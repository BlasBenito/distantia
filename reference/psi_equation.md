# Normalized Dissimilarity Score

Demonstration function to computes the `psi` dissimilarity score (Birks
and Gordon 1985). Psi is computed as \\\psi = (2a / b) - 1\\, where
\\a\\ is the sum of distances between the relevant samples of two time
series, and \\b\\ is the cumulative sum of distances between consecutive
samples in the two time series.

If `a` is computed with dynamic time warping, and diagonals are used in
the computation of the least cost path, then one is added to the result
of the equation above.

## Usage

``` r
psi_equation(a = NULL, b = NULL, diagonal = TRUE)
```

## Arguments

- a:

  (required, numeric) Result of
  [`psi_cost_path_sum()`](https://blasbenito.github.io/distantia/reference/psi_cost_path_sum.md),
  the sum of distances of the least cost path between two time series.
  Default: NULL

- b:

  (required, numeric) Result of
  [`psi_auto_sum()`](https://blasbenito.github.io/distantia/reference/psi_auto_sum.md),
  the cumulative sum of the consecutive cases of two time series.
  Default: NULL

- diagonal:

  (optional, logical) Used to correct `psi` when diagonals are used
  during the computation of the least cost path. If the cost matrix and
  least cost path were computed using `diagonal = TRUE`, this argument
  should be `TRUE` as well. Default: TRUE

## Value

numeric value

## See also

Other psi_demo:
[`psi_auto_distance()`](https://blasbenito.github.io/distantia/reference/psi_auto_distance.md),
[`psi_auto_sum()`](https://blasbenito.github.io/distantia/reference/psi_auto_sum.md),
[`psi_cost_matrix()`](https://blasbenito.github.io/distantia/reference/psi_cost_matrix.md),
[`psi_cost_path()`](https://blasbenito.github.io/distantia/reference/psi_cost_path.md),
[`psi_cost_path_sum()`](https://blasbenito.github.io/distantia/reference/psi_cost_path_sum.md),
[`psi_distance_lock_step()`](https://blasbenito.github.io/distantia/reference/psi_distance_lock_step.md),
[`psi_distance_matrix()`](https://blasbenito.github.io/distantia/reference/psi_distance_matrix.md)

## Examples

``` r
#distance metric
d <- "euclidean"

#use diagonals in least cost computations
diagonal <- TRUE

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

#dynamic time warping

#distance matrix
dist_matrix <- psi_distance_matrix(
  x = x,
  y = y,
  distance = d
)

#cost matrix
cost_matrix <- psi_cost_matrix(
  dist_matrix = dist_matrix,
  diagonal = diagonal
)

#least cost path
cost_path <- psi_cost_path(
  dist_matrix = dist_matrix,
  cost_matrix = cost_matrix,
  diagonal = diagonal
)

if(interactive()){
  utils_matrix_plot(
    m = cost_matrix,
    path = cost_path
    )
}


#computation of psi score

#sum of distances in least cost path
a <- psi_cost_path_sum(
  path = cost_path
  )

#auto sum of both time series
b <- psi_auto_sum(
  x = x,
  y = y,
  distance = d
)

#dissimilarity score
psi_equation(
  a = a,
  b = b,
  diagonal = diagonal
)
#> [1] 6.05602

#full computation with distantia()
tsl <- list(
  x = x,
  y = y
)

distantia(
  tsl = tsl,
  distance = d,
  diagonal = diagonal
)$psi
#> [1] 6.05602

if(interactive()){
  distantia_dtw_plot(
    tsl = tsl,
    distance = d,
    diagonal = diagonal
  )
}
```
