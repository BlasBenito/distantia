#' Kmeans Clustering of a Distantia Data Frame
#'
#' @param df (required, data frame) Output of [distantia()]. Default: NULL
#' @param clusters (required, integer) Number of groups to generate. If NULL (default), [cluster_kmeans_optimizer()] is used to find the number of clusters that maximizes the mean silhouette width (see [cluster_silhouette()]). Default: NULL
#' @param seed (optional, integer) Random seed to be used during the K-means computation. Default: 1
#' @return List with the following objects:
#' \itemize{
#'   \item `df`: data frame with names of the time series, their group assignation, and their silhouette width scores.
#'   \item `d`: psi distance matrix.
#'   \item `k`: kmeans object.
#'   \item `silhouette_width`: mean silhouette width of the kmeans clustering.
#'   \item `silhouette_optimization`: only if `clusters = NULL`, data frame with optimization results from [cluster_kmeans_optimizer()].
#' }
#' @export
#' @autoglobal
#' @seealso [stats::kmeans()]
#' @examples
#'
#' tsl <- tsl_simulate(
#'   n = 10,
#'   time_range = c(
#'     "2010-01-01 12:00:25",
#'     "2024-12-31 11:15:45"
#'   )
#' )
#'
#' df <- distantia(
#'   tsl = tsl
#' )
#'
#' k <- distantia_kmeans(
#'   df = df
#' )
#'
#' k$df
#'
#' # #Optional: kmeans plot
#' # k_plot <- factoextra::fviz_cluster(
#' #   object = k$k,
#' #   data = k$d,
#' #   repel = TRUE
#' # )
#'
distantia_kmeans <- function(
    df = NULL,
    clusters = NULL,
    seed = 1
){

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

  }

  d <- distantia_matrix(
    df = df
  )[[1]]

  #optimize kmeans
  if(is.null(clusters)){

    optimization_df <- cluster_kmeans_optimizer(
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

  k_silhouette <- cluster_silhouette(
    cluster = k,
    distance_matrix = d,
    mean = FALSE
  )

  out <- list(
    df = k_silhouette,
    d = d,
    k = k,
    silhouette_width = mean(k_silhouette$silhouette_width)
  )

  if(exists("clusters_df")){
    out$silhouette_optimization <- optimization_df
  }

  out

}
