# Stats of Dissimilarity Data Frame

Takes the output of
[`distantia()`](https://blasbenito.github.io/distantia/reference/distantia.md)
to return a data frame with one row per time series with the stats of
its dissimilarity scores with all other time series.

## Usage

``` r
distantia_stats(df = NULL)
```

## Arguments

- df:

  (required, data frame) Output of
  [`distantia()`](https://blasbenito.github.io/distantia/reference/distantia.md),
  [`distantia_ls()`](https://blasbenito.github.io/distantia/reference/distantia_ls.md),
  [`distantia_dtw()`](https://blasbenito.github.io/distantia/reference/distantia_dtw.md),
  or
  [`distantia_time_delay()`](https://blasbenito.github.io/distantia/reference/distantia_time_delay.md).
  Default: NULL

## Value

data frame

## See also

Other distantia_support:
[`distantia_aggregate()`](https://blasbenito.github.io/distantia/reference/distantia_aggregate.md),
[`distantia_boxplot()`](https://blasbenito.github.io/distantia/reference/distantia_boxplot.md),
[`distantia_cluster_hclust()`](https://blasbenito.github.io/distantia/reference/distantia_cluster_hclust.md),
[`distantia_cluster_kmeans()`](https://blasbenito.github.io/distantia/reference/distantia_cluster_kmeans.md),
[`distantia_matrix()`](https://blasbenito.github.io/distantia/reference/distantia_matrix.md),
[`distantia_model_frame()`](https://blasbenito.github.io/distantia/reference/distantia_model_frame.md),
[`distantia_spatial()`](https://blasbenito.github.io/distantia/reference/distantia_spatial.md),
[`distantia_time_delay()`](https://blasbenito.github.io/distantia/reference/distantia_time_delay.md),
[`utils_block_size()`](https://blasbenito.github.io/distantia/reference/utils_block_size.md),
[`utils_cluster_hclust_optimizer()`](https://blasbenito.github.io/distantia/reference/utils_cluster_hclust_optimizer.md),
[`utils_cluster_kmeans_optimizer()`](https://blasbenito.github.io/distantia/reference/utils_cluster_kmeans_optimizer.md),
[`utils_cluster_silhouette()`](https://blasbenito.github.io/distantia/reference/utils_cluster_silhouette.md)

## Examples

``` r
tsl <- tsl_simulate(
  n = 5,
  irregular = FALSE
  )

df <- distantia(
  tsl = tsl,
  lock_step = TRUE
  )

df_stats <- distantia_stats(df = df)

df_stats
#>   name     mean      min       q1   median       q3      max        sd    range
#> 1    A 3.296808 1.761407 2.482497 3.401601 4.215912 4.622621 1.2985348 2.861214
#> 2    B 3.155373 1.761407 2.408483 3.134579 3.881469 4.590924 1.2282561 2.829517
#> 3    C 3.389109 2.624174 2.698189 3.309487 4.000408 4.313287 0.8446247 1.689113
#> 4    D 4.270175 3.644984 3.833332 3.988229 4.425071 5.459258 0.8125554 1.814273
#> 5    E 4.746523 4.313287 4.521515 4.606773 4.831780 5.459258 0.4950579 1.145971
```
