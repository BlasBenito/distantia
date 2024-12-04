#' K-Means Clustering of Dissimilarity Analysis Data Frames
#'
#' @description
#' This function combines the dissimilarity scores computed by [distantia()], the K-means clustering method implemented in [stats::kmeans()], and the clustering optimization method implemented in [utils_cluster_hclust_optimizer()] to help group together time series with similar features.
#'
#' When `clusters = NULL`, the function [utils_cluster_hclust_optimizer()] is run underneath to perform a parallelized grid search to find the  number of clusters maximizing the overall silhouette width of the clustering solution (see [utils_cluster_silhouette()]).
#'
#' This function supports a parallelization setup via [future::plan()], and progress bars provided by the package [progressr](https://CRAN.R-project.org/package=progressr).
#'
#' @param df (required, data frame) Output of [distantia()]. Default: NULL
#' @param clusters (required, integer) Number of groups to generate. If NULL (default), [utils_cluster_kmeans_optimizer()] is used to find the number of clusters that maximizes the mean silhouette width of the clustering solution (see [utils_cluster_silhouette()]). Default: NULL
#' @param seed (optional, integer) Random seed to be used during the K-means computation. Default: 1
#' @return list:
#' \itemize{
#'   \item `cluster_object`: kmeans object object for further analyses and custom plotting.
#'   \item `clusters`: integer, number of clusters.
#'   \item `silhouette_width`: mean silhouette width of the clustering solution.
#'   \item `df`: data frame with time series names, their cluster label, and their individual silhouette width scores.
#'   \item `d`: psi distance matrix used for clustering.
#'   \item `optimization`: only if `clusters = NULL`, data frame with optimization results from [utils_cluster_hclust_optimizer()].
#' }
#' @export
#' @autoglobal
#' @examples
#'
#' #parallelization setup (not worth it for this data size)
#' future::plan(
#'   future::multisession,
#'   workers = 2 #set to parallelly::availableCores() - 1
#' )
#'
#' # progress bar (does not work in examples)
#' # progressr::handlers(global = TRUE)
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
#' distantia_kmeans <- distantia_cluster_kmeans(
#'   df = distantia_df,
#'   clusters = NULL
#' )
#'
#' #names of the output object
#' names(distantia_kmeans)
#'
#' #kmeans object
#' distantia_kmeans$cluster_object
#'
#' #distance matrix used for clustering
#' distantia_kmeans$d
#'
#' #number of clusters
#' distantia_kmeans$clusters
#'
#' #clustering data frame
#' #group label in column "cluster"
#' distantia_kmeans$df
#'
#' #mean silhouette width of the clustering solution
#' distantia_kmeans$silhouette_width
#'
#' #kmeans plot
#' # factoextra::fviz_cluster(
#' #   object = distantia_kmeans$cluster_object,
#' #   data = distantia_kmeans$d,
#' #   repel = TRUE
#' # )
#'
#' #disable parallelization
#' future::plan(
#'   future::sequential
#' )
#'
#' @family dissimilarity_analysis
distantia_cluster_kmeans <- function(
    df = NULL,
    clusters = NULL,
    seed = 1
){

  df_list <- utils_distantia_df_split(
    df = df
  )

  if(length(df_list) > 1){

    message(
      "distantia::distantia_cluster_kmeans(): there are ",
      length(df_list),
      "  combinations of arguments in 'df'. Applying distantia_aggregate(..., f = mean) to combine them into a single one."
      )

    df <- distantia_aggregate(
      df = df,
      f = mean
    )

  }

  d <- distantia_matrix(
    df = df
  )[[1]]

  #optimize kmeans
  if(is.null(clusters)){

    optimization_df <- utils_cluster_kmeans_optimizer(
      d = d,
      seed = seed
    )

    clusters <- optimization_df[
      which.max(optimization_df$silhouette_mean),
      "clusters"
      ]

  }

  if(clusters < 2){
    clusters <- 2
  }

  if(clusters >= nrow(d)){
    clusters <- nrow(d) - 1
  }

  set.seed(seed)

  k <- stats::kmeans(
    x = d,
    centers = clusters,
    algorithm = "Hartigan-Wong",
    nstart = nrow(df)
  )

  k_silhouette <- utils_cluster_silhouette(
    labels = k$cluster,
    d = d,
    mean = FALSE
  )

  out <- list(
    cluster_object = k,
    clusters = clusters,
    silhouette_width = mean(k_silhouette$silhouette_width),
    df = k_silhouette,
    d = d

  )

  if(exists("optimization_df")){
    out$optimization <- optimization_df
  }

  out

}
