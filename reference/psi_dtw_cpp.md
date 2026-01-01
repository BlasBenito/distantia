# (C++) Psi Dissimilarity Score of Two Time-Series

Computes the psi score of two time series `y` and `x` with the same
number of columns. NA values should be removed before using this
function. If the selected distance function is "chi" or "cosine", pairs
of zeros should be either removed or replaced with pseudo-zeros (i.e.
0.00001).

## Usage

``` r
psi_dtw_cpp(
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

  (required, numeric matrix) of same number of columns as 'y'.

- y:

  (required, numeric matrix) time series.

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
  default.

## Value

numeric

## See also

Other Rcpp_dissimilarity_analysis:
[`psi_equation_cpp()`](https://blasbenito.github.io/distantia/reference/psi_equation_cpp.md),
[`psi_ls_cpp()`](https://blasbenito.github.io/distantia/reference/psi_ls_cpp.md),
[`psi_null_dtw_cpp()`](https://blasbenito.github.io/distantia/reference/psi_null_dtw_cpp.md),
[`psi_null_ls_cpp()`](https://blasbenito.github.io/distantia/reference/psi_null_ls_cpp.md)
