# (C++) Contribution of Individual Variables to the Dissimilarity Between Two Time Series (Legacy Version)

Computes the contribution of individual variables to the
similarity/dissimilarity between two irregular multivariate time series.
In opposition to the robust version, least-cost paths for each
combination of variables are computed independently, which makes the
results of individual variables harder to compare. This function should
only be used when the objective is replicating importance scores
generated with previous versions of the package `distantia`. This
function generates a data frame with the following columns:

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
  `((psi_all - psi_without) * 100) / psi_all`. Positive scores represent
  contribution to dissimilarity, while negative scores represent
  contribution to similarity.

## Usage

``` r
importance_dtw_legacy_cpp(
  y,
  x,
  distance = "euclidean",
  diagonal = FALSE,
  weighted = TRUE,
  ignore_blocks = FALSE,
  bandwidth = 1
)
```

## Arguments

- y:

  (required, numeric matrix) multivariate time series with the same
  number of columns as 'x'.

- x:

  (required, numeric matrix) multivariate time series.

- distance:

  (optional, character string) distance name from the "names" column of
  the dataset `distances` (see `distances$name`). Default: "euclidean".

- diagonal:

  (optional, logical). If TRUE, diagonals are included in the
  computation of the cost matrix. Default: TRUE.

- weighted:

  (optional, logical). Only relevant when diagonal is TRUE. When TRUE,
  diagonal cost is weighted by y factor of 1.414214 (square root of 2).
  Default: TRUE.

- ignore_blocks:

  (optional, logical). If TRUE, blocks of consecutive path coordinates
  are trimmed to avoid inflating the psi distance. Default: FALSE.

- bandwidth:

  (required, numeric) Size of the Sakoe-Chiba band at both sides of the
  diagonal used to constrain the least cost path. Expressed as a
  fraction of the number of matrix rows and columns. Unrestricted by
  default. Default: 1

## Value

data frame

## See also

Other Rcpp_importance:
[`importance_dtw_cpp()`](https://blasbenito.github.io/distantia/reference/importance_dtw_cpp.md),
[`importance_ls_cpp()`](https://blasbenito.github.io/distantia/reference/importance_ls_cpp.md)

## Examples

``` r
#simulate two regular time series
x <- zoo_simulate(
  seed = 1,
  rows = 100
  )

y <- zoo_simulate(
  seed = 2,
  rows = 150
  )

#different number of rows
#this is not a requirement though!
nrow(x) == nrow(y)
#> [1] FALSE

#compute importance
df <- importance_dtw_legacy_cpp(
  x = x,
  y = y,
  distance = "euclidean"
)

df
#>   variable      psi psi_only_with psi_without psi_difference importance
#> 1        a 7.117738      3.944473    7.085622      -3.141148  0.4512122
#> 2        b 7.117738      3.939795    6.697154      -2.757359  5.9089584
#> 3        c 7.117738      2.933434    6.993513      -4.060079  1.7452840
#> 4        d 7.117738      3.850228    6.372267      -2.522039 10.4734219
#> 5        e 7.117738      1.546849    7.347811      -5.800962 -3.2323892
```
