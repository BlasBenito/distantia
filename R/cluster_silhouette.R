#' Silhouette Width of a Clustering Solution
#'
#' @description
#'
#' The silhouette width is a measure of how similar an object is to its own cluster (cohesion) compared to other clusters (separation).
#'
#' There are some general guidelines to interpret the  individual silhouette widths of the clustered objects (as returned by this function when `mean = FALSE`):
#'
#' \itemize{
#'   \item Close to 1: object is well matched to its own cluster and poorly matched to neighboring clusters.
#'   \item Close to 0: the object is between two neighboring clusters.
#'   \item Close to -1: the object is likely to be assigned to the wrong cluster
#' }
#'
#' When `mean = TRUE`, the overall mean of the silhouette widths of all objects is returned. These values should be interpreted as follows:
#'
#' \itemize{
#'  \item Higher than 0.7: robust clustering .
#'  \item Higher than 0.5: reasonable clustering.
#'  \item Higher than 0.25: weak clustering.
#'
#' }
#'
#' This metric may not perform well when the clusters have irregular shapes or sizes.
#'
#' This code was adapted from https://svn.r-project.org/R-packages/trunk/cluster/R/silhouette.R
#'
#'
#' @param cluster (required, clustering object) Result of [stats::kmeans()]. Default: NULL
#' @param distance_matrix (required, matrix) Distance matrix typically resulting from [distantia_matrix()]. Default: NULL
#' @param mean (optional, logical) If TRUE, the mean of the silhouette widths is returned. Default: FALSE
#'
#' @return If mean = FALSE, data frame with silhouette widths of the clustering, and numeric indicating the mean silhouette width otherwise.
#' @export
#' @autoglobal
#' @examples
cluster_silhouette <- function(
    cluster = NULL,
    distance_matrix = NULL,
    mean = FALSE
){

  if(inherits(x = cluster, what = "kmeans")){
    clustering <- cluster$cluster
  } else {
    clustering <- cluster
  }

  if(inherits(x = distance_matrix, what = "matrix") == FALSE){
    stop("Argument 'distance_matrix' must be a square matrix.")
  }

  clustering_length <- length(clustering)

  clustering_groups <- sort(unique(clustering))

  output <- matrix(
    data = NA,
    nrow = clustering_length,
    ncol = 3,
    dimnames = list(
      names(clustering),
      c("cluster","neighbor","silhouette_width")
    )
  )

  # j-th cluster:
  for(i in seq_len(length(clustering_groups))){

    cluster_i_members <- clustering == clustering_groups[i]

    cluster_i_size <- sum(cluster_i_members)

    output[cluster_i_members, "cluster"] <- clustering_groups[i]

    ## minimal distances to points in all other clusters:
    cluster_i_distances <- rbind(
      apply(
        X = distance_matrix[
          !cluster_i_members,
          cluster_i_members,
          drop = FALSE
          ],
        MARGIN = 2,
        FUN = function(r) tapply(
          X = r,
          INDEX = clustering[!cluster_i_members],
          FUN = mean
          )
      )
    )

    cluster_i_min_distance <- apply(
      X = cluster_i_distances,
      MARGIN = 2,
      FUN = which.min
      )

    output[cluster_i_members,"neighbor"] <- clustering_groups[-i][cluster_i_min_distance]

    if(cluster_i_size > 1){

      #cluster cohesion
        cluster_i_cohesion <- colSums(
          distance_matrix[cluster_i_members, cluster_i_members]
          )/(cluster_i_size - 1)

        #cluster separation
        cluster_i_separation <- cluster_i_distances[
          cbind(
            cluster_i_min_distance,
            seq(along = cluster_i_min_distance)
            )
          ]

        cluster_i_silhouette <- ifelse(
          test = cluster_i_cohesion != cluster_i_separation,
          yes = (cluster_i_separation - cluster_i_cohesion) / pmax(cluster_i_separation, cluster_i_cohesion),
          no = 0
          )

    } else {
      cluster_i_silhouette <- 0
    }

    output[
      cluster_i_members,
      "silhouette_width"
      ] <- cluster_i_silhouette

  }

  if(mean == FALSE){

    output <- output[, c("cluster", "silhouette_width")] |>
      as.data.frame()

    output$name <- rownames(output)

    rownames(output) <- NULL

    output <- output[, c("name", "cluster", "silhouette_width")]

  } else {
    output <- mean(output[, "silhouette_width"])
  }

  output

}
