# (C++) Null Distribution of Dissimilarity Scores of Two Time Series

Applies permutation methods to compute null distributions for the psi
scores of two time series. NA values should be removed before using this
function. If the selected distance function is "chi" or "cosine", pairs
of zeros should be either removed or replaced with pseudo-zeros (i.e.
0.00001).

## Usage

``` r
psi_null_dtw_cpp(
  x,
  y,
  distance = "euclidean",
  diagonal = TRUE,
  weighted = TRUE,
  ignore_blocks = FALSE,
  bandwidth = 1,
  repetitions = 100L,
  permutation = "restricted_by_row",
  block_size = 3L,
  seed = 1L
)
```

## Arguments

- x:

  (required, numeric matrix) of same number of columns as 'y'.

- y:

  (required, numeric matrix).

- distance:

  (optional, character string) distance name from the "names" column of
  the dataset `distances` (see `distances$name`). Default: "euclidean".

- diagonal:

  (optional, logical). If TRUE, diagonals are included in the
  computation of the cost matrix. Default: FALSE.

- weighted:

  (optional, logical). If TRUE, diagonal is set to TRUE, and diagonal
  cost is weighted by a factor of 1.414214 (square root of 2). Default:
  FALSE.

- ignore_blocks:

  (optional, logical). If TRUE, blocks of consecutive path coordinates
  are trimmed to avoid inflating the psi distance. This argument has
  nothing to do with block_size!. Default: FALSE.

- bandwidth:

  (required, numeric) Size of the Sakoe-Chiba band at both sides of the
  diagonal used to constrain the least cost path. Expressed as a
  fraction of the number of matrix rows and columns. Unrestricted by
  default. Default: 1

- repetitions:

  (optional, integer) number of null psi values to generate. Default:
  100

- permutation:

  (optional, character) permutation method. Valid values are listed
  below from higher to lower randomness:

  - "free": unrestricted shuffling of rows and columns. Ignores
    block_size.

  - "free_by_row": unrestricted shuffling of complete rows. Ignores
    block size.

  - "restricted": restricted shuffling of rows and columns within
    blocks.

  - "restricted_by_row": restricted shuffling of rows within blocks.

- block_size:

  (optional, integer) block size in rows for restricted permutation. A
  block size of 3 indicates that a row can only be permuted within a
  block of 3 adjacent rows. Minimum value is 2. Default: 3.

- seed:

  (optional, integer) initial random seed to use for replicability.
  Default: 1

## Value

numeric vector

## See also

Other Rcpp_dissimilarity_analysis:
[`psi_dtw_cpp()`](https://blasbenito.github.io/distantia/reference/psi_dtw_cpp.md),
[`psi_equation_cpp()`](https://blasbenito.github.io/distantia/reference/psi_equation_cpp.md),
[`psi_ls_cpp()`](https://blasbenito.github.io/distantia/reference/psi_ls_cpp.md),
[`psi_null_ls_cpp()`](https://blasbenito.github.io/distantia/reference/psi_null_ls_cpp.md)
