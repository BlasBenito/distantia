#' Optimal Number of Clusters for Kmeans
#'
#' @description
#' Generates k-means solutions from 2 to `nrow(d) - 1` number of clusters and returns the number of clusters with a higher silhouette width median. See [cluster_silhouette()] for more details.
#'
#'
#' @param d (required, matrix) distance matrix typically resulting from [distantia_matrix()], but any other square matrix should work. Default: NULL
#' @param seed (optional, integer) Random seed to be used during the K-means computation. Default: 1
#'
#' @return Data frame with number of clusters and their respective mean silhouette widths.
#' @export
#' @autoglobal
#' @examples
cluster_kmeans_optimizer <- function(
    d = NULL,
    seed = 1
    ){

  if(!is.matrix(d)){
    stop("Argument 'd' must be a matrix.")
  }

  if(nrow(d) != ncol(d)){
    stop("Argument 'd' must be a square distance matrix")
  }

  groups_vector <- seq(
    from = 2,
    to = nrow(d) - 1,
    by = 1
  )

  # p <- progressr::progressor(along = groups_vector)

  #to silence loading messages
  `%iterator%` <- doFuture::`%dofuture%` |>
    suppressMessages()

  my_foreach <- foreach::foreach |>
    suppressMessages()

  sil <- my_foreach(
    i = groups_vector,
    .combine = "c",
    .errorhandling = "pass",
    .options.future = list(seed = TRUE)
  ) %iterator% {

    # p()

    set.seed(seed)

    k <- stats::kmeans(
      x = d,
      centers = i,
      algorithm = "Hartigan-Wong",
      nstart = nrow(d)
    )

    cluster_silhouette(
      cluster = k,
      distance_matrix = d,
      mean = TRUE
    )

  }

  if(is.vector(sil) == FALSE){

    stop("Function cluster_kmeans_optimizer() failed. Error message was: '", paste0(sil$message), "'.")

  }

  data.frame(
    clusters = groups_vector,
    silhouette_mean = sil
  )

}
