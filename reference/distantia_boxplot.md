# Distantia Boxplot

Boxplot of a data frame returned by
[`distantia()`](https://blasbenito.github.io/distantia/reference/distantia.md)
summarizing the stats of the psi scores of each time series against all
others.

## Usage

``` r
distantia_boxplot(df = NULL, fill_color = NULL, f = median, text_cex = 1)
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

- fill_color:

  (optional, character vector) boxplot fill color. Default: NULL

- f:

  (optional, function) function used to aggregate the input data frame
  and arrange the boxes. One of `mean` or `median`. Default: `median`.

- text_cex:

  (optional, numeric) Multiplier of the text size. Default: 1

## Value

boxplot

## See also

Other distantia_support:
[`distantia_aggregate()`](https://blasbenito.github.io/distantia/reference/distantia_aggregate.md),
[`distantia_cluster_hclust()`](https://blasbenito.github.io/distantia/reference/distantia_cluster_hclust.md),
[`distantia_cluster_kmeans()`](https://blasbenito.github.io/distantia/reference/distantia_cluster_kmeans.md),
[`distantia_matrix()`](https://blasbenito.github.io/distantia/reference/distantia_matrix.md),
[`distantia_model_frame()`](https://blasbenito.github.io/distantia/reference/distantia_model_frame.md),
[`distantia_spatial()`](https://blasbenito.github.io/distantia/reference/distantia_spatial.md),
[`distantia_stats()`](https://blasbenito.github.io/distantia/reference/distantia_stats.md),
[`distantia_time_delay()`](https://blasbenito.github.io/distantia/reference/distantia_time_delay.md),
[`utils_block_size()`](https://blasbenito.github.io/distantia/reference/utils_block_size.md),
[`utils_cluster_hclust_optimizer()`](https://blasbenito.github.io/distantia/reference/utils_cluster_hclust_optimizer.md),
[`utils_cluster_kmeans_optimizer()`](https://blasbenito.github.io/distantia/reference/utils_cluster_kmeans_optimizer.md),
[`utils_cluster_silhouette()`](https://blasbenito.github.io/distantia/reference/utils_cluster_silhouette.md)

## Examples

``` r
tsl <- tsl_initialize(
  x = distantia::albatross,
  name_column = "name",
  time_column = "time"
) |>
  tsl_transform(
    f = f_scale_global
  )

df <- distantia(
  tsl = tsl,
  lock_step = TRUE
  )

distantia_boxplot(
  df = df,
  text_cex = 1.5
  )
```
