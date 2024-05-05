#' Silhouette Width of a Clustering Solution
#'
#' @description
#' Adapted from https://svn.r-project.org/R-packages/trunk/cluster/R/silhouette.R
#'
#'
#' @param cluster (required, clustering object) Result of [stats::kmeans()]. Default: NULL
#' @param distance_matrix (required, matrix) Distance matrix typically resulting from [distantia_matrix()]. Default: NULL
#' @param median (optional, logical) If TRUE, the median of the silhouette widths is returned. Default: FALSE
#'
#' @return If median = FALSE, data frame with silhouette widths of the clustering, and numeric indicating the median silhouette width otherwise.
#' @export
#' @autoglobal
#' @examples
cluster_silhouette <- function(
    cluster = NULL,
    distance_matrix = NULL,
    median = FALSE
){

  if(inherits(x = cluster, what = "kmeans")){
    clustering <- cluster$cluster
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

  if(median == FALSE){
    output <- output[, c("cluster", "silhouette_width")] |>
      as.data.frame()
  } else {
    output <- stats::median(output[, "silhouette_width"])
  }

  output

}
