#' Sum of Distances in Least-cost Path
#'
#' @param path (required, data frame) dataframe produced by [psi_cost_path()]. Default: NULL
#' @return Sum of distances.
#' @examples
#'
#' data(sequenceA, sequenceB)
#'
#' x <- sequenceB |>
#'   na.omit() |>
#'   as.matrix()
#'
#' y <- sequenceA |>
#'   na.omit() |>
#'   as.matrix()
#'
#' d <- distance_matrix(x, y, distance = "euclidean")
#'
#' m <- cost_matrix(dist_matrix = d)
#'
#' path <- psi_cost_path(
#'   dist_matrix = d,
#'   cost_matrix = m
#'   )
#'
#' cost_path_sum(path = path)
#'
#' @autoglobal
#' @export
psi_cost_path_sum <- function(path = NULL){

  path <- utils_check_path_args(
    path = path
  )

  sum(path$dist)

}
