#' Hierarchical Clustering of a Distantia Data Frame
#'
#' @param df (required, data frame) Output of [distantia()]. Default: NULL
#' @param clusters (required, integer) Number of groups to generate. If NULL (default), [cluster_hclust_optimizer()] is used to find the number of clusters that maximizes the mean silhouette width (see [cluster_silhouette()]). Default: NULL
#' @param method (optional, character string) The agglomeration method to be used. This should be (an unambiguous abbreviation of) one of "ward.D", "ward.D2", "single", "complete", "average" (= UPGMA), "mcquitty" (= WPGMA), "median" (= WPGMC) or "centroid" (= UPGMC). Default: "complete".
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
#' hc <- distantia_cluster_hclust(
#'   df = df
#' )
#'
#' hc$df
#'
#' plot(
#'   x = hc$hclust,
#'   hang = -1
#'   )
#'
#' stats::rect.hclust(
#'   tree = hc$hclust,
#'   k = hc$clusters,
#'   border = grDevices::hcl.colors(
#'     n = hc$clusters,
#'     palette = "Zissou 1"
#'     )
#'   )
#'
distantia_cluster_hclust <- function(
    df = NULL,
    clusters = NULL,
    method = "complete"
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

  d_dist <- stats::as.dist(d)

  #optimize groups
  if(is.null(clusters)){

    optimization_df <- cluster_hclust_optimizer(
      d = d,
      method = method
    )

    clusters <- optimization_df[
      which.max(optimization_df$silhouette_mean),
      "clusters"
      ]

    method <- optimization_df[
      which.max(optimization_df$silhouette_mean),
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
