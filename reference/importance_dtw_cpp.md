# (C++) Contribution of Individual Variables to the Dissimilarity Between Two Time Series (Robust Version)

Computes the contribution of individual variables to the
similarity/dissimilarity between two irregular multivariate time series.
In opposition to the legacy version, importance computation is performed
taking the least-cost path of the whole sequence as reference. This
operation makes the importance scores of individual variables fully
comparable. This function generates a data frame with the following
columns:

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
importance_dtw_cpp(
  x,
  y,
  distance = "euclidean",
  diagonal = TRUE,
  weighted = TRUE,
  ignore_blocks = FALSE,
  bandwidth = 1
)
```

## Arguments

- x:

  (required, numeric matrix) multivariate time series.

- y:

  (required, numeric matrix) multivariate time series with the same
  number of columns as 'x'.

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
[`importance_dtw_legacy_cpp()`](https://blasbenito.github.io/distantia/reference/importance_dtw_legacy_cpp.md),
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
df <- importance_dtw_cpp(
  x = x,
  y = y,
  distance = "euclidean"
)

df
#>   variable      psi psi_only_with psi_without psi_difference importance
#> 1        a 6.922989      7.277243    6.992495      0.2847484   4.113085
#> 2        b 6.922989      7.262113    6.985450      0.2766631   3.996295
#> 3        c 6.922989      7.415667    6.813090      0.6025773   8.704005
#> 4        d 6.922989      6.889989    6.617020      0.2729691   3.942938
#> 5        e 6.922989      5.855310    7.182964     -1.3276538 -19.177466
```
