# Hierarchical Clustering of Dissimilarity Analysis Data Frames

This function combines the dissimilarity scores computed by
[`distantia()`](https://blasbenito.github.io/distantia/reference/distantia.md),
the agglomerative clustering methods provided by
[`stats::hclust()`](https://rdrr.io/r/stats/hclust.html), and the
clustering optimization method implemented in
[`utils_cluster_hclust_optimizer()`](https://blasbenito.github.io/distantia/reference/utils_cluster_hclust_optimizer.md)
to help group together time series with similar features.

When `clusters = NULL`, the function
[`utils_cluster_hclust_optimizer()`](https://blasbenito.github.io/distantia/reference/utils_cluster_hclust_optimizer.md)
is run underneath to perform a parallelized grid search to find the
number of clusters maximizing the overall silhouette width of the
clustering solution (see
[`utils_cluster_silhouette()`](https://blasbenito.github.io/distantia/reference/utils_cluster_silhouette.md)).
When `method = NULL` as well, the optimization also includes all methods
available in [`stats::hclust()`](https://rdrr.io/r/stats/hclust.html) in
the grid search.

This function supports a parallelization setup via
[`future::plan()`](https://future.futureverse.org/reference/plan.html),
and progress bars provided by the package
[progressr](https://CRAN.R-project.org/package=progressr).

## Usage

``` r
distantia_cluster_hclust(df = NULL, clusters = NULL, method = "complete")
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

- method:

  (optional, character string) Argument of
  [`stats::hclust()`](https://rdrr.io/r/stats/hclust.html) defining the
  agglomerative method. One of: "ward.D", "ward.D2", "single",
  "complete", "average" (= UPGMA), "mcquitty" (= WPGMA), "median" (=
  WPGMC) or "centroid" (= UPGMC). Unambiguous abbreviations are accepted
  as well. If NULL (default),
  [`utils_cluster_hclust_optimizer()`](https://blasbenito.github.io/distantia/reference/utils_cluster_hclust_optimizer.md)
  finds the optimal method. Default: "complete".

## Value

list:

- `cluster_object`: hclust object for further analyses and custom
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
#automated method selection
distantia_clust <- distantia_cluster_hclust(
  df = distantia_df,
  clusters = NULL,
  method = NULL
)

#names of the output object
names(distantia_clust)
#> [1] "cluster_object"   "clusters"         "silhouette_width" "df"              
#> [5] "d"                "optimization"    

#cluster object
distantia_clust$cluster_object
#> 
#> Call:
#> stats::hclust(d = d_dist, method = method)
#> 
#> Cluster method   : ward.D 
#> Number of objects: 10 
#> 

#distance matrix used for clustering
distantia_clust$d
#>               Alameda Imperial   Fresno    Butte Contra_Costa    Kings     Kern
#> Imperial     4.119107                                                          
#> Fresno       3.456869 3.184685                                                 
#> Butte        2.962963 4.408978 3.324759                                        
#> Contra_Costa 1.162055 4.328125 3.387755 2.733068                               
#> Kings        3.631491 1.917582 2.981191 3.623529     3.719723                  
#> Kern         3.658065 3.696145 2.381766 2.811688     3.670103 3.203150         
#> Humboldt     3.960000 4.173228 4.439863 4.233871     4.380952 3.481739 4.388889
#> El_Dorado    2.483755 4.568627 4.433962 2.327273     2.767442 3.694352 3.942857
#> Los_Angeles  3.972376 3.598377 2.302730 4.005556     3.871720 2.954876 3.420000
#>              Humboldt El_Dorado
#> Imperial                       
#> Fresno                         
#> Butte                          
#> Contra_Costa                   
#> Kings                          
#> Kern                           
#> Humboldt                       
#> El_Dorado    3.568627          
#> Los_Angeles  4.647059  4.517711

#number of clusters
distantia_clust$clusters
#> [1] 5

#clustering data frame
#group label in column "cluster"
#negatives in column "silhouette_width" higlight anomalous cluster assignation
distantia_clust$df
#>            name cluster silhouette_width
#> 1       Alameda       1        0.5733007
#> 2      Imperial       2        0.4510322
#> 3        Fresno       3        0.2402546
#> 4         Butte       4        0.1828440
#> 5  Contra_Costa       1        0.5774736
#> 6         Kings       2        0.3705427
#> 7          Kern       3        0.1410575
#> 8      Humboldt       5        0.0000000
#> 9     El_Dorado       4        0.1136219
#> 10  Los_Angeles       3        0.1267346

#mean silhouette width of the clustering solution
distantia_clust$silhouette_width
#> [1] 0.2776862

#plot
if(interactive()){

  dev.off()

  clust <- distantia_clust$cluster_object
  k <- distantia_clust$clusters

  #tree plot
  plot(
    x = clust,
    hang = -1
  )

  #highlight groups
  stats::rect.hclust(
    tree = clust,
    k = k,
    cluster = stats::cutree(
      tree = clust,
      k = k
    )
  )

}
```
