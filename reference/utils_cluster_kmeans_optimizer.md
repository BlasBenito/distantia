# Optimize the Silhouette Width of K-Means Clustering Solutions

Generates k-means solutions from 2 to `nrow(d) - 1` number of clusters
and returns the number of clusters with a higher silhouette width
median. See
[`utils_cluster_silhouette()`](https://blasbenito.github.io/distantia/reference/utils_cluster_silhouette.md)
for more details.

This function supports a parallelization setup via
[`future::plan()`](https://future.futureverse.org/reference/plan.html),
and progress bars provided by the package
[progressr](https://CRAN.R-project.org/package=progressr).

## Usage

``` r
utils_cluster_kmeans_optimizer(d = NULL, seed = 1)
```

## Arguments

- d:

  (required, matrix) distance matrix typically resulting from
  [`distantia_matrix()`](https://blasbenito.github.io/distantia/reference/distantia_matrix.md),
  but any other square matrix should work. Default: NULL

- seed:

  (optional, integer) Random seed to be used during the K-means
  computation. Default: 1

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
[`distantia_stats()`](https://blasbenito.github.io/distantia/reference/distantia_stats.md),
[`distantia_time_delay()`](https://blasbenito.github.io/distantia/reference/distantia_time_delay.md),
[`utils_block_size()`](https://blasbenito.github.io/distantia/reference/utils_block_size.md),
[`utils_cluster_hclust_optimizer()`](https://blasbenito.github.io/distantia/reference/utils_cluster_hclust_optimizer.md),
[`utils_cluster_silhouette()`](https://blasbenito.github.io/distantia/reference/utils_cluster_silhouette.md)

## Examples

``` r
#weekly covid prevalence
#in 10 California counties
#aggregated by month
tsl <- tsl_initialize(
  x = covid_prevalence,
  name_column = "name",
  time_column = "time"
) |>
  tsl_subset(
    names = 1:10
  ) |>
  tsl_aggregate(
    new_time = "months",
    fun = max
  )

if(interactive()){
  #plotting first three time series
  tsl_plot(
    tsl = tsl_subset(
      tsl = tsl,
      names = 1:3
    ),
    guide_columns = 3
  )
}

#compute dissimilarity matrix
psi_matrix <- distantia(
  tsl = tsl,
  lock_step = TRUE
) |>
  distantia_matrix()

#optimize hierarchical clustering
kmeans_optimization <- utils_cluster_kmeans_optimizer(
  d = psi_matrix
)

#best solution in first row
head(kmeans_optimization)
#>   clusters silhouette_mean
#> 1        5       0.3127728
#> 2        4       0.2888716
#> 3        6       0.2746665
#> 4        3       0.2597968
#> 5        2       0.2285407
#> 6        7       0.2103172
```
