# K-Means Clustering of Dissimilarity Analysis Data Frames

This function combines the dissimilarity scores computed by
[`distantia()`](https://blasbenito.github.io/distantia/reference/distantia.md),
the K-means clustering method implemented in
[`stats::kmeans()`](https://rdrr.io/r/stats/kmeans.html), and the
clustering optimization method implemented in
[`utils_cluster_hclust_optimizer()`](https://blasbenito.github.io/distantia/reference/utils_cluster_hclust_optimizer.md)
to help group together time series with similar features.

When `clusters = NULL`, the function
[`utils_cluster_hclust_optimizer()`](https://blasbenito.github.io/distantia/reference/utils_cluster_hclust_optimizer.md)
is run underneath to perform a parallelized grid search to find the
number of clusters maximizing the overall silhouette width of the
clustering solution (see
[`utils_cluster_silhouette()`](https://blasbenito.github.io/distantia/reference/utils_cluster_silhouette.md)).

This function supports a parallelization setup via
[`future::plan()`](https://future.futureverse.org/reference/plan.html),
and progress bars provided by the package
[progressr](https://CRAN.R-project.org/package=progressr).

## Usage

``` r
distantia_cluster_kmeans(df = NULL, clusters = NULL, seed = 1)
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

- clusters:

  (required, integer) Number of groups to generate. If NULL (default),
  [`utils_cluster_kmeans_optimizer()`](https://blasbenito.github.io/distantia/reference/utils_cluster_kmeans_optimizer.md)
  is used to find the number of clusters that maximizes the mean
  silhouette width of the clustering solution (see
  [`utils_cluster_silhouette()`](https://blasbenito.github.io/distantia/reference/utils_cluster_silhouette.md)).
  Default: NULL

- seed:

  (optional, integer) Random seed to be used during the K-means
  computation. Default: 1

## Value

list:

- `cluster_object`: kmeans object object for further analyses and custom
  plotting.

- `clusters`: integer, number of clusters.

- `silhouette_width`: mean silhouette width of the clustering solution.

- `df`: data frame with time series names, their cluster label, and
  their individual silhouette width scores.

- `d`: psi distance matrix used for clustering.

- `optimization`: only if `clusters = NULL`, data frame with
  optimization results from
  [`utils_cluster_hclust_optimizer()`](https://blasbenito.github.io/distantia/reference/utils_cluster_hclust_optimizer.md).

## See also

Other distantia_support:
[`distantia_aggregate()`](https://blasbenito.github.io/distantia/reference/distantia_aggregate.md),
[`distantia_boxplot()`](https://blasbenito.github.io/distantia/reference/distantia_boxplot.md),
[`distantia_cluster_hclust()`](https://blasbenito.github.io/distantia/reference/distantia_cluster_hclust.md),
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
#weekly covid prevalence in California
tsl <- tsl_initialize(
  x = covid_prevalence,
  name_column = "name",
  time_column = "time"
)

#subset 10 elements to accelerate example execution
tsl <- tsl_subset(
  tsl = tsl,
  names = 1:10
)

if(interactive()){
  #plotting first three time series
  tsl_plot(
    tsl = tsl[1:3],
    guide_columns = 3
  )
}

#dissimilarity analysis
distantia_df <- distantia(
  tsl = tsl,
  lock_step = TRUE
)

#hierarchical clustering
#automated number of clusters
distantia_kmeans <- distantia_cluster_kmeans(
  df = distantia_df,
  clusters = NULL
)

#names of the output object
names(distantia_kmeans)
#> [1] "cluster_object"   "clusters"         "silhouette_width" "df"              
#> [5] "d"                "optimization"    

#kmeans object
distantia_kmeans$cluster_object
#> K-means clustering with 5 clusters of sizes 1, 2, 3, 2, 2
#> 
#> Cluster means:
#>     Alameda  Imperial   Fresno    Butte Contra_Costa     Kings     Kern
#> 1 3.9600000 4.1732283 4.439863 4.233871    4.3809524 3.4817391 4.388889
#> 2 2.7233587 4.4888025 3.879361 1.163636    2.7502548 3.6589408 3.377273
#> 3 3.6957697 3.4930690 1.561499 3.380668    3.6431928 3.0464057 1.933922
#> 4 0.5810277 4.2236158 3.422312 2.848015    0.5810277 3.6756070 3.664084
#> 5 3.8752987 0.9587912 3.082938 4.016253    4.0239241 0.9587912 3.449647
#>   Humboldt El_Dorado Los_Angeles
#> 1 0.000000  3.568627    4.647059
#> 2 3.901249  1.163636    4.261633
#> 3 4.491937  4.298177    1.907577
#> 4 4.170476  2.625598    3.922048
#> 5 3.827484  4.131490    3.276627
#> 
#> Clustering vector:
#>      Alameda     Imperial       Fresno        Butte Contra_Costa        Kings 
#>            4            5            3            2            4            5 
#>         Kern     Humboldt    El_Dorado  Los_Angeles 
#>            3            1            2            3 
#> 
#> Within cluster sum of squares by cluster:
#> [1]  0.000000  7.154225 17.277466  1.538902  5.260079
#>  (between_SS / total_SS =  80.4 %)
#> 
#> Available components:
#> 
#> [1] "cluster"      "centers"      "totss"        "withinss"     "tot.withinss"
#> [6] "betweenss"    "size"         "iter"         "ifault"      

#distance matrix used for clustering
distantia_kmeans$d
#>               Alameda Imperial   Fresno    Butte Contra_Costa    Kings     Kern
#> Alameda      0.000000 4.119107 3.456869 2.962963     1.162055 3.631491 3.658065
#> Imperial     4.119107 0.000000 3.184685 4.408978     4.328125 1.917582 3.696145
#> Fresno       3.456869 3.184685 0.000000 3.324759     3.387755 2.981191 2.381766
#> Butte        2.962963 4.408978 3.324759 0.000000     2.733068 3.623529 2.811688
#> Contra_Costa 1.162055 4.328125 3.387755 2.733068     0.000000 3.719723 3.670103
#> Kings        3.631491 1.917582 2.981191 3.623529     3.719723 0.000000 3.203150
#> Kern         3.658065 3.696145 2.381766 2.811688     3.670103 3.203150 0.000000
#> Humboldt     3.960000 4.173228 4.439863 4.233871     4.380952 3.481739 4.388889
#> El_Dorado    2.483755 4.568627 4.433962 2.327273     2.767442 3.694352 3.942857
#> Los_Angeles  3.972376 3.598377 2.302730 4.005556     3.871720 2.954876 3.420000
#>              Humboldt El_Dorado Los_Angeles
#> Alameda      3.960000  2.483755    3.972376
#> Imperial     4.173228  4.568627    3.598377
#> Fresno       4.439863  4.433962    2.302730
#> Butte        4.233871  2.327273    4.005556
#> Contra_Costa 4.380952  2.767442    3.871720
#> Kings        3.481739  3.694352    2.954876
#> Kern         4.388889  3.942857    3.420000
#> Humboldt     0.000000  3.568627    4.647059
#> El_Dorado    3.568627  0.000000    4.517711
#> Los_Angeles  4.647059  4.517711    0.000000
#> attr(,"distantia_args")
#> data frame with 0 columns and 1 row
#> attr(,"type")
#> [1] "distantia_matrix"
#> attr(,"distance")
#> [1] "psi"

#number of clusters
distantia_kmeans$clusters
#> [1] 5

#clustering data frame
#group label in column "cluster"
distantia_kmeans$df
#>            name cluster silhouette_width
#> 1       Alameda       4        0.5733007
#> 2      Imperial       5        0.4510322
#> 3        Fresno       3        0.2402546
#> 4         Butte       2        0.1828440
#> 5  Contra_Costa       4        0.5774736
#> 6         Kings       5        0.3705427
#> 7          Kern       3        0.1410575
#> 8      Humboldt       1        0.0000000
#> 9     El_Dorado       2        0.1136219
#> 10  Los_Angeles       3        0.1267346

#mean silhouette width of the clustering solution
distantia_kmeans$silhouette_width
#> [1] 0.2776862

#kmeans plot
# factoextra::fviz_cluster(
#   object = distantia_kmeans$cluster_object,
#   data = distantia_kmeans$d,
#   repel = TRUE
# )
```
