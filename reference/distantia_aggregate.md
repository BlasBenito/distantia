# Aggregate `distantia()` Data Frames Across Parameter Combinations

The function
[`distantia()`](https://blasbenito.github.io/distantia/reference/distantia.md)
allows dissimilarity assessments based on several combinations of
arguments at once. For example, when the argument `distance` is set to
`c("euclidean", "manhattan")`, the output data frame will show two
dissimilarity scores for each pair of compared time series, one based on
euclidean distances, and another based on manhattan distances.

This function computes dissimilarity stats across combinations of
parameters.

If psi scores smaller than zero occur in the aggregated output, then the
the smaller psi value is added to the column `psi` to start
dissimilarity scores at zero.

If there are no different combinations of arguments in the input data
frame, no aggregation happens, but all parameter columns are removed.

## Usage

``` r
distantia_aggregate(df = NULL, f = mean, ...)
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

- f:

  (optional, function) Function to summarize psi scores (for example,
  `mean`) when there are several combinations of parameters in `df`.
  Ignored when there is a single combination of arguments in the input.
  Default: `mean`

- ...:

  (optional, arguments of `f`) Further arguments to pass to the function
  `f`.

## Value

data frame

## See also

Other distantia_support:
[`distantia_boxplot()`](https://blasbenito.github.io/distantia/reference/distantia_boxplot.md),
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
#three time series
#climate and ndvi in Fagus sylvatica stands in Spain, Germany, and Sweden
tsl <- tsl_initialize(
  x = fagus_dynamics,
  name_column = "name",
  time_column = "time"
) |>
  tsl_transform(
    f = f_scale_global
  )

if(interactive()){
  tsl_plot(
    tsl = tsl,
    guide_columns = 3
    )
}

#distantia with multiple parameter combinations
#-------------------------------------
df <- distantia(
  tsl = tsl,
  distance = c("euclidean", "manhattan"),
  lock_step = TRUE
)

df[, c(
  "x",
  "y",
  "distance",
  "psi"
)]
#>         x      y  distance       psi
#> 2 Germany Sweden euclidean 0.8576700
#> 5 Germany Sweden manhattan 0.8591195
#> 4 Germany  Spain manhattan 1.2698922
#> 1 Germany  Spain euclidean 1.3061327
#> 3   Spain Sweden euclidean 1.4708497
#> 6   Spain Sweden manhattan 1.4890286

#aggregation using means
df <- distantia_aggregate(
  df = df,
  f = mean
)

df
#>         x      y       psi
#> 2 Germany Sweden 0.8576700
#> 5 Germany Sweden 0.8591195
#> 4 Germany  Spain 1.2698922
#> 1 Germany  Spain 1.3061327
#> 3   Spain Sweden 1.4708497
#> 6   Spain Sweden 1.4890286
```
