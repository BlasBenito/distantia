# Compute Silhouette Width of a Clustering Solution

The silhouette width is a measure of how similar an object is to its own
cluster (cohesion) compared to other clusters (separation).

There are some general guidelines to interpret the individual silhouette
widths of the clustered objects (as returned by this function when
`mean = FALSE`):

- Close to 1: object is well matched to its own cluster and poorly
  matched to neighboring clusters.

- Close to 0: the object is between two neighboring clusters.

- Close to -1: the object is likely to be assigned to the wrong cluster

When `mean = TRUE`, the overall mean of the silhouette widths of all
objects is returned. These values should be interpreted as follows:

- Higher than 0.7: robust clustering .

- Higher than 0.5: reasonable clustering.

- Higher than 0.25: weak clustering.

This metric may not perform well when the clusters have irregular shapes
or sizes.

This code was adapted from
<https://svn.r-project.org/R-packages/trunk/cluster/R/silhouette.R>.

## Usage

``` r
utils_cluster_silhouette(labels = NULL, d = NULL, mean = FALSE)
```

## Arguments

- labels:

  (required, integer vector) Labels resulting from a clustering
  algorithm applied to `d`. Must have the same length as columns and
  rows in `d`. Default: NULL

- d:

  (required, matrix) distance matrix typically resulting from
  [`distantia_matrix()`](https://blasbenito.github.io/distantia/reference/distantia_matrix.md),
  but any other square matrix should work. Default: NULL

- mean:

  (optional, logical) If TRUE, the mean of the silhouette widths is
  returned. Default: FALSE

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
[`utils_cluster_kmeans_optimizer()`](https://blasbenito.github.io/distantia/reference/utils_cluster_kmeans_optimizer.md)

## Examples

``` r
#weekly covid prevalence in three California counties
#load as tsl
#subset first 10 time series
#sum by month
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
    method = max
  )

#compute dissimilarity
distantia_df <- distantia(
  tsl = tsl,
  lock_step = TRUE
)

#generate dissimilarity matrix
psi_matrix <- distantia_matrix(
  df = distantia_df
)

#example with kmeans clustering
#------------------------------------

#kmeans with 3 groups
psi_kmeans <- stats::kmeans(
  x = as.dist(psi_matrix[[1]]),
  centers = 3
)

#case-wise silhouette width
utils_cluster_silhouette(
  labels = psi_kmeans$cluster,
  d = psi_matrix
)
#>            name cluster silhouette_width
#> 1       Alameda       3       0.33810466
#> 2        Fresno       3       0.14246887
#> 3      Imperial       2       0.45256690
#> 4         Butte       3       0.38380943
#> 5  Contra_Costa       3       0.39068538
#> 6          Kern       3       0.22819774
#> 7         Kings       2       0.48073590
#> 8     El_Dorado       3       0.20083919
#> 9      Humboldt       1       0.00000000
#> 10  Los_Angeles       3       0.05147887

#overall silhouette width
utils_cluster_silhouette(
  labels = psi_kmeans$cluster,
  d = psi_matrix,
  mean = TRUE
)
#> [1] 0.2668887


#example with hierarchical clustering
#------------------------------------

#hierarchical clustering
psi_hclust <- stats::hclust(
  d = as.dist(psi_matrix[[1]])
)

#generate labels for three groups
psi_hclust_labels <- stats::cutree(
  tree = psi_hclust,
  k = 3,
)

#case-wise silhouette width
utils_cluster_silhouette(
  labels = psi_hclust_labels,
  d = psi_matrix
)
#>            name cluster silhouette_width
#> 1       Alameda       1       0.42264374
#> 2        Fresno       2       0.19610751
#> 3      Imperial       2       0.32692191
#> 4         Butte       1       0.33171545
#> 5  Contra_Costa       1       0.44437549
#> 6          Kern       2       0.02226525
#> 7         Kings       2       0.31397263
#> 8     El_Dorado       1       0.38899482
#> 9      Humboldt       3       0.00000000
#> 10  Los_Angeles       2       0.18091946

#overall silhouette width
utils_cluster_silhouette(
  labels = psi_hclust_labels,
  d = psi_matrix,
  mean = TRUE
)
#> [1] 0.2627916
```
