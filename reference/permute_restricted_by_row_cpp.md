# (C++) Restricted Permutation of Complete Rows Within Blocks

Divides a sequence in blocks of a given size and permutes rows within
these blocks. Larger block sizes increasingly disrupt the data structure
over time.

## Usage

``` r
permute_restricted_by_row_cpp(x, block_size, seed = 1L)
```

## Arguments

- x:

  (required, numeric matrix). Numeric matrix to permute.

- block_size:

  (optional, integer) block size in number of rows. Minimum value is 2,
  and maximum value is nrow(x).

- seed:

  (optional, integer) random seed to use.

## Value

numeric matrix

## See also

Other Rcpp_permutation:
[`permute_free_by_row_cpp()`](https://blasbenito.github.io/distantia/reference/permute_free_by_row_cpp.md),
[`permute_free_cpp()`](https://blasbenito.github.io/distantia/reference/permute_free_cpp.md),
[`permute_restricted_cpp()`](https://blasbenito.github.io/distantia/reference/permute_restricted_cpp.md)
