# (C++) Bray-Curtis Distance Between Two Vectors

Computes the Bray-Curtis distance, suitable for species abundance data.

## Usage

``` r
distance_bray_curtis_cpp(x, y)
```

## Arguments

- x:

  (required, numeric vector).

- y:

  (required, numeric vector) of same length as `x`.

## Value

numeric

## See also

Other Rcpp_distance_methods:
[`distance_canberra_cpp()`](https://blasbenito.github.io/distantia/reference/distance_canberra_cpp.md),
[`distance_chebyshev_cpp()`](https://blasbenito.github.io/distantia/reference/distance_chebyshev_cpp.md),
[`distance_chi_cpp()`](https://blasbenito.github.io/distantia/reference/distance_chi_cpp.md),
[`distance_cosine_cpp()`](https://blasbenito.github.io/distantia/reference/distance_cosine_cpp.md),
[`distance_euclidean_cpp()`](https://blasbenito.github.io/distantia/reference/distance_euclidean_cpp.md),
[`distance_hamming_cpp()`](https://blasbenito.github.io/distantia/reference/distance_hamming_cpp.md),
[`distance_hellinger_cpp()`](https://blasbenito.github.io/distantia/reference/distance_hellinger_cpp.md),
[`distance_jaccard_cpp()`](https://blasbenito.github.io/distantia/reference/distance_jaccard_cpp.md),
[`distance_manhattan_cpp()`](https://blasbenito.github.io/distantia/reference/distance_manhattan_cpp.md),
[`distance_russelrao_cpp()`](https://blasbenito.github.io/distantia/reference/distance_russelrao_cpp.md),
[`distance_sorensen_cpp()`](https://blasbenito.github.io/distantia/reference/distance_sorensen_cpp.md)

## Examples

``` r
distance_bray_curtis_cpp(x = runif(100), y = runif(100))
#> [1] 0.326113
```
