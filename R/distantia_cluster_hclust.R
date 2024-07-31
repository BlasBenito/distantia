#' Hierarchical Clustering of Time Series
#'
#' @description
#' This function combines the dissimilarity scores computed by [distantia()], the agglomerative clustering methods provided by [stats::hclust()], and the clustering optimization method implemented in [cluster_hclust_optimizer()] to help group together time series with similar features. The optimization method uses a parallelized grid search to find the combination of number of clusters and agglomerative method (optional) maximizing the overall silhouette score of the solution (see [cluster_silhouette()]).
#'
#'
#' @param df (required, data frame) Output of [distantia()]. Default: NULL
#' @param clusters (required, integer) Number of groups to generate. If NULL (default), [cluster_hclust_optimizer()] optimizes the number of clusters. Default: NULL
#' @param method (optional, character string) Argument of [stats::hclust()] defining the agglomerative method. One of: "ward.D", "ward.D2", "single", "complete", "average" (= UPGMA), "mcquitty" (= WPGMA), "median" (= WPGMC) or "centroid" (= UPGMC). Unambiguous abbreviations are accepted as well. If NULL (default), [cluster_hclust_optimizer()] finds the optimal method. Default: "complete".
#' @return List with the following objects:
#' \itemize{
#'   \item `hclust`: hclust object.
#'   \item `clusters`: integer, number of clusters.
#'   \item `silhouette_width`: mean silhouette width of the hierarchical clustering.
#'   \item `df`: data frame with names of the time series, their group assignation, and their silhouette width scores.
#'   \item `d`: psi distance matrix.
#'   \item `optimization`: only if `clusters = NULL`, data frame with optimization results from [cluster_hclust_optimizer()].
#' }
#' @details
#' All relevant details about clustering methods and relevant references are available in the help file of [stats::hclust()].
#'
#' @export
#' @autoglobal
#' @seealso [stats::kmeans()]
#' @examples
#' #daily covid prevalence in California counties
#' data("covid_prevalence")
#'
#' #load as tsl and aggregate to monthly data to accelerate example execution
#' tsl <- tsl_initialize(
#'   x = covid_prevalence,
#'   id_column = "county",
#'   time_column = "date"
#' ) |>
#'   tsl_aggregate(
#'     new_time = "months",
#'     fun = sum
#'   )
#'
#' if(interactive()){
#'   #plotting first three time series
#'   tsl_plot(
#'     tsl = tsl[1:3],
#'     guide_columns = 3
#'     )
#' }
#'
#' #dissimilarity analysis
#' distantia_df <- distantia(
#'   tsl = tsl
#' )
#'
#' #hierarchical clustering with a given number of clusters
#' #-------------------------------------------------------
#' distantia_clust <- distantia_cluster_hclust(
#'   df = distantia_df,
#'   clusters = 5, #arbitrary number!
#'   method = "complete"
#' )
#'
#' #names of the output object
#' names(distantia_clust)
#'
#' #distance matrix used for clustering
#' distantia_clust$d
#'
#' #number of clusters
#' distantia_clust$clusters
#'
#' #clustering data frame
#' #group assignation in column "cluster"
#' #negatives in column "silhouette_width" higlight anomalous cluster assignation
#' distantia_clust$df
#'
#' #mean silhouette width of the clustering solution
#'
#' distantia_clust$silhouette_width
#'
#' #plot
#' if(interactive()){
#'
#'   clust <- distantia_clust$hclust
#'   k <- distantia_clust$clusters
#'
#'   #tree plot
#'   plot(
#'     x = clust,
#'     hang = -1
#'     )
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
#'
#' #optimized hierarchical clustering
#' #---------------------------------
#'
#' #for large datasets, parallelization accelerates cluster optimization
#' future::plan(
#'  future::multisession,
#'  workers = 2 #set to parallelly::availableWorkers() - 1
#' )
#'
#' #progress bar
#' progressr::handlers(global = TRUE)
#'
#' #auto-optimization of clusters and method
#' distantia_clust <- distantia_cluster_hclust(
#'   df = distantia_df,
#'   clusters = NULL,
#'   method = NULL
#' )
#'
#' #names of the output object
#' #a new object named "optimization" should appear
#' names(distantia_clust)
#'
#' #first rows of the optimization data frame
#' #optimized clustering in first row
#' head(distantia_clust$optimization)
#'
#' #plot
#' if(interactive()){
#'
#'   clust <- distantia_clust$hclust
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
#' #disable parallelization
#' future::plan(
#'   future::sequential
#' )
distantia_cluster_hclust <- function(
    df = NULL,
    clusters = NULL,
    method = "complete"
){

  #aggregate df if needed
  df_list <- utils_distantia_df_split(
    df = df
  )

  if(length(df_list) > 1){

    message(
      "There are ",
      length(df_list),
      "  combinations of arguments in 'df'. Applying distantia_aggregate(..., f = mean) to combine them into a single one."
      )

    df <- distantia_aggregate(
      df = df,
      f = mean
    )

    rm(df_list)

  }

  d <- distantia_matrix(
    df = df
  )[[1]]

  d_dist <- stats::as.dist(d)

  #optimize groups
  if(is.null(clusters)){

    optimization_df <- cluster_hclust_optimizer(
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

  hc_silhouette <- cluster_silhouette(
    cluster = hc_groups,
    distance_matrix = d,
    mean = FALSE
  )

  out <- list(
    hclust = hc,
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
