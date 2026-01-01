# (C++) Psi Dissimilarity Score of Two Aligned Time Series

Computes the psi dissimilarity score between two time series observed at
the same times. Time series `y` and `x` with the same number of columns
and rows. NA values should be removed before using this function. If the
selected distance function is "chi" or "cosine", pairs of zeros should
be either removed or replaced with pseudo-zeros (i.e. 0.00001).

## Usage

``` r
psi_ls_cpp(x, y, distance = "euclidean")
```

## Arguments

- x:

  (required, numeric matrix) of same number of columns as 'y'.

- y:

  (required, numeric matrix) of same number of columns as 'x'.

- distance:

  (optional, character string) distance name from the "names" column of
  the dataset `distances` (see `distances$name`). Default: "euclidean".

## Value

numeric

## See also

Other Rcpp_dissimilarity_analysis:
[`psi_dtw_cpp()`](https://blasbenito.github.io/distantia/reference/psi_dtw_cpp.md),
[`psi_equation_cpp()`](https://blasbenito.github.io/distantia/reference/psi_equation_cpp.md),
[`psi_null_dtw_cpp()`](https://blasbenito.github.io/distantia/reference/psi_null_dtw_cpp.md),
[`psi_null_ls_cpp()`](https://blasbenito.github.io/distantia/reference/psi_null_ls_cpp.md)
