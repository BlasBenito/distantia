# (C++) Equation of the Psi Dissimilarity Score

Equation to compute the `psi` dissimilarity score (Birks and Gordon
1985). Psi is computed as \\\psi = (2a / b) - 1\\, where \\a\\ is the
sum of distances between the relevant samples of two time series, and
\\b\\ is the cumulative sum of distances between consecutive samples in
the two time series. If `a` is computed with dynamic time warping, and
diagonals are used in the computation of the least cost path, then one
is added to the result of the equation above.

## Usage

``` r
psi_equation_cpp(a, b, diagonal = TRUE)
```

## Arguments

- a:

  (required, numeric) output of
  [`cost_path_sum_cpp()`](https://blasbenito.github.io/distantia/reference/cost_path_sum_cpp.md)
  on a least cost path.

- b:

  (required, numeric) auto sum of both sequences, result of
  [`auto_sum_cpp()`](https://blasbenito.github.io/distantia/reference/auto_sum_cpp.md).

- diagonal:

  (optional, logical). Must be TRUE when diagonals are used in dynamic
  time warping and for lock-step distances. Default: FALSE.

## Value

numeric

## See also

Other Rcpp_dissimilarity_analysis:
[`psi_dtw_cpp()`](https://blasbenito.github.io/distantia/reference/psi_dtw_cpp.md),
[`psi_ls_cpp()`](https://blasbenito.github.io/distantia/reference/psi_ls_cpp.md),
[`psi_null_dtw_cpp()`](https://blasbenito.github.io/distantia/reference/psi_null_dtw_cpp.md),
[`psi_null_ls_cpp()`](https://blasbenito.github.io/distantia/reference/psi_null_ls_cpp.md)
