# (C++) Unrestricted Permutation of Cases

Unrestricted shuffling of cases within the whole sequence.

## Usage

``` r
permute_free_cpp(x, block_size, seed = 1L)
```

## Arguments

- x:

  (required, numeric matrix). Numeric matrix to permute.

- block_size:

  (optional, integer) this function ignores this argument and sets it to
  x.nrow().

- seed:

  (optional, integer) random seed to use.

## Value

numeric matrix

## See also

Other Rcpp_permutation:
[`permute_free_by_row_cpp()`](https://blasbenito.github.io/distantia/reference/permute_free_by_row_cpp.md),
[`permute_restricted_by_row_cpp()`](https://blasbenito.github.io/distantia/reference/permute_restricted_by_row_cpp.md),
[`permute_restricted_cpp()`](https://blasbenito.github.io/distantia/reference/permute_restricted_cpp.md)
