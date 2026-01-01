# (C++) Contribution of Individual Variables to the Dissimilarity Between Two Aligned Time Series

Computes the contribution of individual variables to the
similarity/dissimilarity between two aligned multivariate time series.
This function generates a data frame with the following columns:

- variable: name of the individual variable for which the importance is
  being computed, from the column names of the arguments `x` and `y`.

- psi: global dissimilarity score `psi` of the two time series.

- psi_only_with: dissimilarity between `x` and `y` computed from the
  given variable alone.

- psi_without: dissimilarity between `x` and `y` computed from all other
  variables.

- psi_difference: difference between `psi_only_with` and `psi_without`.

- importance: contribution of the variable to the
  similarity/dissimilarity between `x` and `y`, computed as
  `(psi_difference * 100) / psi_all`. Positive scores represent
  contribution to dissimilarity, while negative scores represent
  contribution to similarity.

## Usage

``` r
importance_ls_cpp(x, y, distance = "euclidean")
```

## Arguments

- x:

  (required, numeric matrix) multivariate time series.

- y:

  (required, numeric matrix) multivariate time series with the same
  number of columns and rows as 'x'.

- distance:

  (optional, character string) distance name from the "names" column of
  the dataset `distances` (see `distances$name`). Default: "euclidean".

## Value

data frame

## See also

Other Rcpp_importance:
[`importance_dtw_cpp()`](https://blasbenito.github.io/distantia/reference/importance_dtw_cpp.md),
[`importance_dtw_legacy_cpp()`](https://blasbenito.github.io/distantia/reference/importance_dtw_legacy_cpp.md)

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

#same number of rows
nrow(x) == nrow(y)
#> [1] TRUE

#compute importance
df <- importance_ls_cpp(
  x = x,
  y = y,
  distance = "euclidean"
)

df
#>   variable      psi psi_only_with psi_without psi_difference  importance
#> 1        a 5.216396      4.140726    5.328400     -1.1876738 -22.7680904
#> 2        b 5.216396      5.036421    5.048808     -0.0123872  -0.2374666
#> 3        c 5.216396      6.763852    4.961907      1.8019444  34.5438541
#> 4        d 5.216396      7.782788    4.922800      2.8599885  54.8269008
#> 5        e 5.216396      3.673350    5.914521     -2.2411717 -42.9639841
```
