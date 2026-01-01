# Convert Dissimilarity Analysis Data Frame to Distance Matrix

Transforms a data frame resulting from
[`distantia()`](https://blasbenito.github.io/distantia/reference/distantia.md)
into a dissimilarity matrix.

## Usage

``` r
distantia_matrix(df = NULL)
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

numeric matrix

## See also

Other distantia_support:
[`distantia_aggregate()`](https://blasbenito.github.io/distantia/reference/distantia_aggregate.md),
[`distantia_boxplot()`](https://blasbenito.github.io/distantia/reference/distantia_boxplot.md),
[`distantia_cluster_hclust()`](https://blasbenito.github.io/distantia/reference/distantia_cluster_hclust.md),
[`distantia_cluster_kmeans()`](https://blasbenito.github.io/distantia/reference/distantia_cluster_kmeans.md),
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
#weekly covid prevalence in three California counties
#load as tsl
#subset 5 counties
#sum by month
tsl <- tsl_initialize(
  x = covid_prevalence,
  name_column = "name",
  time_column = "time"
) |>
  tsl_subset(
    names = 1:5
  ) |>
  tsl_aggregate(
    new_time = "months",
    method = sum
  )

if(interactive()){

  #plotting first three time series
  tsl_plot(
    tsl = tsl,
    guide_columns = 3
    )

  dev.off()

}

#dissimilarity analysis
#two combinations of arguments
distantia_df <- distantia(
  tsl = tsl,
  lock_step = c(TRUE, FALSE)
)

#to dissimilarity matrix
distantia_matrix <- distantia_matrix(
  df = distantia_df
)

#returns a list of matrices
lapply(
  X = distantia_matrix,
  FUN = class
  )
#> $`1`
#> [1] "matrix" "array" 
#> 
#> $`2`
#> [1] "matrix" "array" 
#> 

#these matrices have attributes tracing how they were generated
lapply(
  X = distantia_matrix,
  FUN = \(x) attributes(x)$distantia_args
)
#> $`1`
#>     distance diagonal lock_step bandwidth group
#> 11 euclidean     TRUE     FALSE         1     1
#> 
#> $`2`
#>    distance diagonal lock_step bandwidth group
#> 1 euclidean       NA      TRUE        NA     2
#> 

#plot matrix
if(interactive()){

  #plot first matrix (default behavior of utils_matrix_plot())
  utils_matrix_plot(
    m = distantia_matrix
  )

  #plot second matrix
  utils_matrix_plot(
    m = distantia_matrix[[2]]
  )

}
```
