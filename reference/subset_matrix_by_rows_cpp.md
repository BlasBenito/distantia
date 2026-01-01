# (C++) Subset Matrix by Rows

Subsets a time series matrix to the coordinates of a trimmed least-cost
path when blocks are ignored during a dissimilarity analysis.

## Usage

``` r
subset_matrix_by_rows_cpp(m, rows)
```

## Arguments

- m:

  (required, numeric matrix) a univariate or multivariate time series.

- rows:

  (required, integer vector) vector of rows to subset from a least-cost
  path data frame.

## Value

numeric matrix

## See also

Other Rcpp_auto_sum:
[`auto_distance_cpp()`](https://blasbenito.github.io/distantia/reference/auto_distance_cpp.md),
[`auto_sum_cpp()`](https://blasbenito.github.io/distantia/reference/auto_sum_cpp.md),
[`auto_sum_full_cpp()`](https://blasbenito.github.io/distantia/reference/auto_sum_full_cpp.md),
[`auto_sum_path_cpp()`](https://blasbenito.github.io/distantia/reference/auto_sum_path_cpp.md)

## Examples

``` r
#simulate a time series
m <- zoo_simulate(seed = 1)

#sample some rows
rows <- sample(
  x = nrow(m),
  size = 10
  ) |>
  sort()

#subset by rows
m_subset <- subset_matrix_by_rows_cpp(
  m = m,
  rows = rows
  )

#compare with original
m[rows, ]
#>                    a         b         c         d         e
#> 2010-06-15 0.5577262 0.4963594 0.2662721 0.1651134 0.5160559
#> 2011-08-11 0.4853985 0.1920699 0.2034930 0.2256599 0.5121917
#> 2012-02-10 0.5046172 0.2269883 0.2609874 0.3730869 0.5566889
#> 2013-08-14 0.5719184 0.3731751 0.3478408 0.3344399 0.4395588
#> 2013-09-20 0.5324252 0.3389782 0.4051191 0.3932731 0.5122154
#> 2015-05-18 0.6255854 0.5995674 0.5951206 0.6872253 0.6527355
#> 2016-06-25 0.6465068 0.6766877 0.5900437 0.6013624 0.6435012
#> 2017-06-27 0.5057219 0.5587751 0.6883220 0.7603664 0.4707236
#> 2018-02-02 0.4534827 0.5420206 0.6063876 0.6067925 0.4729409
#> 2018-12-11 0.1963668 0.1476422 0.7414715 0.5586704 0.3289944
```
