#' Hierarchical Clustering of Dissimilarity Analysis Data Frames
#'
#' @description
#' This function combines the dissimilarity scores computed by [distantia()], the agglomerative clustering methods provided by [stats::hclust()], and the clustering optimization method implemented in [utils_cluster_hclust_optimizer()] to help group together time series with similar features.
#'
#' When `clusters = NULL`, the function [utils_cluster_hclust_optimizer()] is run underneath to perform a parallelized grid search to find the  number of clusters maximizing the overall silhouette width of the clustering solution (see [utils_cluster_silhouette()]). When `method = NULL` as well, the optimization also includes all methods available in [stats::hclust()] in the grid search.
#'
#' This function supports a parallelization setup via [future::plan()], and progress bars provided by the package [progressr](https://CRAN.R-project.org/package=progressr).
#'
#'
#' @param df (required, data frame) Output of [distantia()]. Default: NULL
#' @param clusters (required, integer) Number of groups to generate. If NULL (default), [utils_cluster_kmeans_optimizer()] is used to find the number of clusters that maximizes the mean silhouette width of the clustering solution (see [utils_cluster_silhouette()]). Default: NULL
#' @param method (optional, character string) Argument of [stats::hclust()] defining the agglomerative method. One of: "ward.D", "ward.D2", "single", "complete", "average" (= UPGMA), "mcquitty" (= WPGMA), "median" (= WPGMC) or "centroid" (= UPGMC). Unambiguous abbreviations are accepted as well. If NULL (default), [utils_cluster_hclust_optimizer()] finds the optimal method. Default: "complete".
#' @return list:
#' \itemize{
#'   \item `cluster_object`: hclust object for further analyses and custom plotting.
#'   \item `clusters`: integer, number of clusters.
#'   \item `silhouette_width`: mean silhouette width of the clustering solution.
#'   \item `df`: data frame with time series names, their cluster label, and their individual silhouette width scores.
#'   \item `d`: psi distance matrix used for clustering.
#'   \item `optimization`: only if `clusters = NULL`, data frame with optimization results from [utils_cluster_hclust_optimizer()].
#' }
#'
#' @export
#' @autoglobal
#' @examples
#'
#' #weekly covid prevalence in California
#' tsl <- tsl_initialize(
#'   x = covid_prevalence,
#'   name_column = "name",
#'   time_column = "time"
#' )
#'
#' #subset 10 elements to accelerate example execution
#' tsl <- tsl_subset(
#'   tsl = tsl,
#'   names = 1:10
#' )
#'
#' if(interactive()){
#'   #plotting first three time series
#'   tsl_plot(
#'     tsl = tsl[1:3],
#'     guide_columns = 3
#'   )
#' }
#'
#' #dissimilarity analysis
#' distantia_df <- distantia(
#'   tsl = tsl,
#'   lock_step = TRUE
#' )
#'
#' #hierarchical clustering
#' #automated number of clusters
#' #automated method selection
#' distantia_clust <- distantia_cluster_hclust(
#'   df = distantia_df,
#'   clusters = NULL,
#'   method = NULL
#' )
#'
#' #names of the output object
#' names(distantia_clust)
#'
#' #cluster object
#' distantia_clust$cluster_object
#'
#' #distance matrix used for clustering
#' distantia_clust$d
#'
#' #number of clusters
#' distantia_clust$clusters
#'
#' #clustering data frame
#' #group label in column "cluster"
#' #negatives in column "silhouette_width" higlight anomalous cluster assignation
#' distantia_clust$df
#'
#' #mean silhouette width of the clustering solution
#' distantia_clust$silhouette_width
#'
#' #plot
#' if(interactive()){
#'
#'   dev.off()
#'
#'   clust <- distantia_clust$cluster_object
#'   k <- distantia_clust$clusters
#'
#'   #tree plot
#'   plot(
#'     x = clust,
#'     hang = -1
#'   )
#'
#'   #highlight groups
#'   stats::rect.hclust(
#'     tree = clust,
#'     k = k,
#'     cluster = stats::cutree(
#'       tree = clust,
#'       k = k
#'     )
#'   )
#'
#' }
#'
#' @family distantia_support
distantia_cluster_hclust <- function(
    df = NULL,
    clusters = NULL,
    method = "complete"
){

  #aggregate df if needed
  df <- distantia_aggregate(
    df = df,
    f = mean
  )

  d <- distantia_matrix(
    df = df
  )[[1]]

  d_dist <- stats::as.dist(d)

  #optimize groups
  if(is.null(clusters)){

    optimization_df <- utils_cluster_hclust_optimizer(
      d = d,
      method = method
    )

    best_index <- which.max(optimization_df$silhouette_mean)

    clusters <- optimization_df[
      best_index,
      "clusters"
    ]

    method <- optimization_df[
      best_index,
      "method"
    ]

  }

  if(clusters < 2){
    clusters <- 2
  }

  if(clusters >= nrow(d)){
    clusters <- nrow(d) - 1
  }

  hc <- stats::hclust(
    d = d_dist,
    method = method
  )

  hc_groups <- stats::cutree(
    tree = hc,
    k = clusters,
  )

  hc_silhouette <- utils_cluster_silhouette(
    labels = hc_groups,
    d = d,
    mean = FALSE
  )

  out <- list(
    cluster_object = hc,
    clusters = clusters,
    silhouette_width = mean(hc_silhouette$silhouette_width),
    df = hc_silhouette,
    d = d_dist
  )

  if(exists("optimization_df")){
    out$optimization <- optimization_df
  }

  out

}
