#' Distance Matrix
#'
#' @param y (required, data frame or matrix) a time series.
#' @param x (required, data frame or matrix) a time series.
#' @param distance (optional, character string) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#' @examples
#' #simulate two time series
#' tsl <- tsl_simulate(
#'   n = 2
#' )
#'
#' if(interactive()){
#'   tsl_plot(tsl = tsl)
#' }
#'
#' #step by step computation of psi
#'
#' #common distance method
#' dist_method <- "euclidean"
#'
#' #distance matrix
#' d <- psi_dist_matrix(
#'   x = tsl[[1]],
#'   y = tsl[[2]],
#'   distance = dist_method
#' )
#'
#' if(interactive()){
#'   utils_matrix_plot(m = d)
#' }
#'
#' #cost matrix
#' m <- psi_cost_matrix(
#'   dist_matrix = d
#' )
#'
#' if(interactive()){
#'   utils_matrix_plot(m = m)
#' }
#'
#' #least cost path
#' path <- psi_cost_path(
#'   dist_matrix = d,
#'   cost_matrix = m
#' )
#'
#' if(interactive()){
#'   utils_matrix_plot(
#'     m = m,
#'     path = path
#'     )
#' }
#'
#' #sum of least cost path
#' path_sum <- psi_cost_path_sum(path = path)
#'
#' #auto sum of the time series
#' xy_sum <- psi_auto_sum(
#'   x = tsl[[1]],
#'   y = tsl[[2]],
#'   path = path,
#'   distance = dist_method
#' )
#'
#' #dissimilarity
#' psi <- psi(
#'   path_sum = path_sum,
#'   auto_sum = xy_sum
#' )
#'
#' psi
#'
#' #full computation in one line
#' distantia(
#'   tsl = tsl
#' )$psi
#'
#' #dissimilarity plot
#' distantia_plot(
#'   tsl = tsl
#' )
#' @return A distance matrix.
#' @export
#' @autoglobal
psi_dist_matrix <- function(
    x = NULL,
    y = NULL,
    distance = "euclidean"
){

  distance <- utils_check_distance_args(
    distance = distance
  )[1]

  #computing distance matrix
  m <- distance_matrix_cpp(
    x = x,
    y = y,
    distance = distance
    )

  #adding names
  dimnames(m) <- list(
    as.character(attributes(y)$index),
    as.character(attributes(x)$index)
  )

  #adding attributes
  attr(x = m, which = "x_time") <- attributes(x)$index
  attr(x = m, which = "y_time") <- attributes(y)$index
  attr(x = m, which = "x_name") <- attributes(x)$name
  attr(x = m, which = "y_name") <- attributes(y)$name
  attr(x = m, which = "type") <- "distance"
  attr(x = m, which = "distance") <- distance

  m

}
