#' Optimal Number of Clusters for Hierarchical Clustering
#'
#' @description
#' Generates hierarchical clustering solutions from 2 to `nrow(d) - 1` number of clusters and returns the number of clusters with a higher silhouette width median. See [cluster_silhouette()] for more details.
#'
#'
#' @param d (required, matrix) distance matrix typically resulting from [distantia_matrix()], but any other square matrix should work. Default: NULL
#' @param method (optional, character string) clustering method. One of: "ward.D", "ward.D2", "single", "complete", "average", "mcquitty", "median", "centroid". See [stats::hclust()]. If NULL (default), all methods are used, and the one resulting in a better Silhouette score (see [cluster_silhouette()]) is used. Default: NULL
#'
#' @return Data frame with number of clusters and their respective mean silhouette widths.
#' @export
#' @autoglobal
#' @examples
cluster_hclust_optimizer <- function(
    d = NULL,
    method = NULL
){

  if(!is.matrix(d)){
    stop("Argument 'd' must be a matrix.")
  }

  if(nrow(d) != ncol(d)){
    stop("Argument 'd' must be a square distance matrix")
  }

  d_dist <- stats::as.dist(d)

  clusters_vector <- seq(
    from = 2,
    to = nrow(d),
    by = 1
  )

  if(is.null(method)){
    methods_vector <- c(
      "ward.D",
      "ward.D2",
      "single",
      "complete",
      "average",
      "mcquitty",
      "median",
      "centroid"
    )
  } else {
    methods_vector <- method
  }

  optimization_df <- expand.grid(
    clusters = clusters_vector,
    method = methods_vector,
    stringsAsFactors = FALSE
  )
  optimization_df$silhouette_mean <- NA

  #to silence loading messages
  `%iterator%` <- doFuture::`%dofuture%` |>
    suppressMessages()

  #clustering methods
  hc_methods <- foreach::foreach(
    i = methods_vector
  ) %iterator% {

    tryCatch({
      stats::hclust(
        d = d_dist,
        method = i
      )
    }, error = function(e) {
      NA
    })

  }

  names(hc_methods) <- methods_vector
  hc_methods <- stats::na.omit(hc_methods)

  #clustering groups
  optimization_df <- optimization_df[
    optimization_df$method %in% names(hc_methods),
  ]

  # p <- progressr::progressor(along = groups_vector)

  optimization_df$silhouette_mean <- my_foreach(
    i = seq_len(nrow(optimization_df)),
    .combine = "c"
  ) %iterator% {

    # p()

    k_groups <- tryCatch({
      stats::cutree(
        tree = hc_methods[[optimization_df[i, "method"]]],
        k = optimization_df[i, "clusters"],
      )
    }, error = function(e) {
      NA
    })

    if(!is.integer(k_groups)){
      return(NA)
    }

    k_sil <- tryCatch({
      cluster_silhouette(
        cluster = k_groups,
        distance_matrix = d,
        mean = TRUE
      )
    }, error = function(e) {
      NA
    })

    k_sil

  }

  optimization_df <- optimization_df[order(-optimization_df$silhouette_mean), ]

  rownames(optimization_df) <- NULL

  optimization_df

}
