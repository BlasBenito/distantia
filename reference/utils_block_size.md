# Default Block Size for Restricted Permutation in Dissimilarity Analyses

Default Block Size for Restricted Permutation in Dissimilarity Analyses

## Usage

``` r
utils_block_size(tsl = NULL, block_size = NULL)
```

## Arguments

- tsl:

  (required, list) Time series list. Default: NULL

- block_size:

  (optional, integer vector) Row block sizes for restricted permutation
  tests. Only relevant when permutation methods are "restricted" or
  "restricted_by_row". A block of size `n` indicates that a row can only
  be permuted within a block of `n` adjacent rows. If NULL, defaults to
  the 20% rows of the shortest time series in `tsl`. Minimum value is 2,
  and maximum value is 50% rows of the shortest time series in `tsl`.
  Default: NULL.

## Value

integer

## See also

Other distantia_support:
[`distantia_aggregate()`](https://blasbenito.github.io/distantia/reference/distantia_aggregate.md),
[`distantia_boxplot()`](https://blasbenito.github.io/distantia/reference/distantia_boxplot.md),
[`distantia_cluster_hclust()`](https://blasbenito.github.io/distantia/reference/distantia_cluster_hclust.md),
[`distantia_cluster_kmeans()`](https://blasbenito.github.io/distantia/reference/distantia_cluster_kmeans.md),
[`distantia_matrix()`](https://blasbenito.github.io/distantia/reference/distantia_matrix.md),
[`distantia_model_frame()`](https://blasbenito.github.io/distantia/reference/distantia_model_frame.md),
[`distantia_spatial()`](https://blasbenito.github.io/distantia/reference/distantia_spatial.md),
[`distantia_stats()`](https://blasbenito.github.io/distantia/reference/distantia_stats.md),
[`distantia_time_delay()`](https://blasbenito.github.io/distantia/reference/distantia_time_delay.md),
[`utils_cluster_hclust_optimizer()`](https://blasbenito.github.io/distantia/reference/utils_cluster_hclust_optimizer.md),
[`utils_cluster_kmeans_optimizer()`](https://blasbenito.github.io/distantia/reference/utils_cluster_kmeans_optimizer.md),
[`utils_cluster_silhouette()`](https://blasbenito.github.io/distantia/reference/utils_cluster_silhouette.md)
