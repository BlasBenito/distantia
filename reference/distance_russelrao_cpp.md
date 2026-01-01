# (C++) Russell-Rao Distance Between Two Binary Vectors

Computes the Russell-Rao distance between two binary vectors.

## Usage

``` r
distance_russelrao_cpp(x, y)
```

## Arguments

- x:

  (required, numeric). Binary vector of 1s and 0s.

- y:

  (required, numeric) Binary vector of 1s and 0s of same length as `x`.

## Value

numeric

## See also

Other Rcpp_distance_methods:
[`distance_bray_curtis_cpp()`](https://blasbenito.github.io/distantia/reference/distance_bray_curtis_cpp.md),
[`distance_canberra_cpp()`](https://blasbenito.github.io/distantia/reference/distance_canberra_cpp.md),
[`distance_chebyshev_cpp()`](https://blasbenito.github.io/distantia/reference/distance_chebyshev_cpp.md),
[`distance_chi_cpp()`](https://blasbenito.github.io/distantia/reference/distance_chi_cpp.md),
[`distance_cosine_cpp()`](https://blasbenito.github.io/distantia/reference/distance_cosine_cpp.md),
[`distance_euclidean_cpp()`](https://blasbenito.github.io/distantia/reference/distance_euclidean_cpp.md),
[`distance_hamming_cpp()`](https://blasbenito.github.io/distantia/reference/distance_hamming_cpp.md),
[`distance_hellinger_cpp()`](https://blasbenito.github.io/distantia/reference/distance_hellinger_cpp.md),
[`distance_jaccard_cpp()`](https://blasbenito.github.io/distantia/reference/distance_jaccard_cpp.md),
[`distance_manhattan_cpp()`](https://blasbenito.github.io/distantia/reference/distance_manhattan_cpp.md),
[`distance_sorensen_cpp()`](https://blasbenito.github.io/distantia/reference/distance_sorensen_cpp.md)

## Examples

``` r
distance_russelrao_cpp(c(0, 1, 0, 1), c(1, 1, 0, 0))
#> [1] 0.5
```
