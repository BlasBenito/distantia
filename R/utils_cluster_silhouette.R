#' Compute Silhouette Width of a Clustering Solution
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
#' This code was adapted from [https://svn.r-project.org/R-packages/trunk/cluster/R/silhouette.R](https://svn.r-project.org/R-packages/trunk/cluster/R/silhouette.R).
#'
#'
#' @param labels (required, integer vector) Labels resulting from a clustering algorithm applied to `d`. Must have the same length as columns and rows in `d`. Default: NULL
#' @param d (required, matrix) distance matrix typically resulting from [distantia_matrix()], but any other square matrix should work. Default: NULL
#' @param mean (optional, logical) If TRUE, the mean of the silhouette widths is returned. Default: FALSE
#'
#' @return data frame
#' @export
#' @autoglobal
#' @examples
#' #weekly covid prevalence in three California counties
#' #load as tsl
#' #subset first 10 time series
#' #sum by month
#' tsl <- tsl_initialize(
#'   x = covid_prevalence,
#'   name_column = "name",
#'   time_column = "time"
#' ) |>
#'   tsl_subset(
#'     names = 1:10
#'   ) |>
#'   tsl_aggregate(
#'     new_time = "months",
#'     method = max
#'   )
#'
#' #compute dissimilarity
#' distantia_df <- distantia(
#'   tsl = tsl,
#'   lock_step = TRUE
#' )
#'
#' #generate dissimilarity matrix
#' psi_matrix <- distantia_matrix(
#'   df = distantia_df
#' )
#'
#' #example with kmeans clustering
#' #------------------------------------
#'
#' #kmeans with 3 groups
#' psi_kmeans <- stats::kmeans(
#'   x = as.dist(psi_matrix[[1]]),
#'   centers = 3
#' )
#'
#' #case-wise silhouette width
#' utils_cluster_silhouette(
#'   labels = psi_kmeans$cluster,
#'   d = psi_matrix
#' )
#'
#' #overall silhouette width
#' utils_cluster_silhouette(
#'   labels = psi_kmeans$cluster,
#'   d = psi_matrix,
#'   mean = TRUE
#' )
#'
#'
#' #example with hierarchical clustering
#' #------------------------------------
#'
#' #hierarchical clustering
#' psi_hclust <- stats::hclust(
#'   d = as.dist(psi_matrix[[1]])
#' )
#'
#' #generate labels for three groups
#' psi_hclust_labels <- stats::cutree(
#'   tree = psi_hclust,
#'   k = 3,
#' )
#'
#' #case-wise silhouette width
#' utils_cluster_silhouette(
#'   labels = psi_hclust_labels,
#'   d = psi_matrix
#' )
#'
#' #overall silhouette width
#' utils_cluster_silhouette(
#'   labels = psi_hclust_labels,
#'   d = psi_matrix,
#'   mean = TRUE
#' )
#' @family internal_dissimilarity_analysis
utils_cluster_silhouette <- function(
    labels = NULL,
    d = NULL,
    mean = FALSE
){

  if(is.list(d)){
    d <- d[[1]]
  }

  if(!is.matrix(d)){
    stop("distantia::utils_cluster_silhouette(): argument 'd' must be a matrix.", call. = FALSE)
  }

  if(nrow(d) != ncol(d)){
    stop("distantia::utils_cluster_silhouette(): argument 'd' must be a square distance matrix.", call. = FALSE)
  }

  if(length(labels) != ncol(d)){
    stop("distantia::utils_cluster_silhouette(): argument 'labels' must have the same length as ncol(d) or nrow(d).", call. = FALSE)
  }

  labels_length <- length(labels)

  labels_groups <- sort(unique(labels))

  output <- matrix(
    data = NA,
    nrow = labels_length,
    ncol = 3,
    dimnames = list(
      names(labels),
      c("cluster","neighbor","silhouette_width")
    )
  )

  # j-th cluster:
  for(i in seq_len(length(labels_groups))){

    cluster_i_members <- labels == labels_groups[i]

    cluster_i_size <- sum(cluster_i_members)

    output[cluster_i_members, "cluster"] <- labels_groups[i]

    ## minimal distances to points in all other clusters:
    cluster_i_distances <- rbind(
      apply(
        X = d[
          !cluster_i_members,
          cluster_i_members,
          drop = FALSE
          ],
        MARGIN = 2,
        FUN = function(r) tapply(
          X = r,
          INDEX = labels[!cluster_i_members],
          FUN = mean
          )
      )
    )

    cluster_i_min_distance <- apply(
      X = cluster_i_distances,
      MARGIN = 2,
      FUN = which.min
      )

    output[cluster_i_members,"neighbor"] <- labels_groups[-i][cluster_i_min_distance]

    if(cluster_i_size > 1){

      #cluster cohesion
        cluster_i_cohesion <- colSums(
          d[cluster_i_members, cluster_i_members]
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
