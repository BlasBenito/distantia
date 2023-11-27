#' Sum of Distances in Least-cost Path
#'
#' @param path (required, data frame) dataframe produced by [cost_path()]. Default: NULL
#' @return Sum of distances.
#' @examples
#'
#' data(sequenceA, sequenceB)
#'
#' a <- sequenceA |>
#'   na.omit() |>
#'   as.matrix()
#'
#' b <- sequenceB |>
#'   na.omit() |>
#'   as.matrix()
#'
#' d <- distance_matrix(a, b, method = "euclidean")
#'
#' m <- cost_matrix(dist_matrix = d)
#'
#' path <- cost_path(
#'   dist_matrix = d,
#'   cost_matrix = m
#'   )
#'
#' cost_path_sum(path = path)
#'
#' @autoglobal
#' @export
cost_path_sum <- function(path = NULL){

  if(!is.data.frame(path)){
    stop("Argument 'path' must be a data frame.")
  }

  if(all(c("a", "b", "dist", "cost") %in% colnames(path)) == FALSE){
    stop("Argument 'path' must have the columns 'a', 'b', 'dist', and 'cost'.")
  }

  sum(path$dist)

}
