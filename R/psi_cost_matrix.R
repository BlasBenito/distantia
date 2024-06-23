#' Cost Matrix
#'
#' @description Computes the cost matrix from a distance matrix.
#'
#' @param dist_matrix (required, numeric matrix). Distance matrix.
#' @param diagonal (optional, logical). If `TRUE`, diagonals are included in the computation of the cost matrix Default: FALSE.
#' @param weighted (optional, logical). Only relevant if `diagonal = TRUE`. If `TRUE`, weights diagonal cost by a factor of 1.414214.
#' @return A cost matrix.
#' @examples
#'
#' distance.matrix <- psi_dist_matrix(
#'   x = x,
#'   y = y,
#'   distance = "manhattan"
#' )
#'
#' cost.matrix <- psi_cost_matrix(
#'   dist_matrix = distance.matrix,
#'   diagonal = FALSE
#'   )
#'
#' if(interactive()){
#'  plotMatrix(distance.matrix = cost.matrix)
#' }
#'
#'
#' @autoglobal
#' @export
psi_cost_matrix <- function(
    dist_matrix = NULL,
    diagonal = FALSE,
    weighted = FALSE
    ){

  dist_matrix <- utils_check_matrix_args(
    m = dist_matrix,
    arg_name = "dist_matrix"
  )

  if(is.logical(diagonal) == FALSE){
    stop("Argument 'diagonal' must be logical (TRUE or FALSE)")
  }

  if(is.logical(weighted) == FALSE){
    stop("Argument 'weighted' must be logical (TRUE or FALSE)")
  }

  #diagonal is TRUE
  if(diagonal == TRUE){

    if(weighted == TRUE){

      m <- cost_matrix_weighted_diag_cpp(dist_matrix = dist_matrix)

    } else {

      m <- cost_matrix_diag_cpp(dist_matrix = dist_matrix)

    }

  } else {

    m <- cost_matrix_cpp(dist_matrix = dist_matrix)

  }

  #adding names
  dimnames(m) <- dimnames(dist_matrix)

  #adding attributes

  attr(x = m, which = "y_time") <- attributes(dist_matrix)$y_time
  attr(x = m, which = "x_time") <- attributes(dist_matrix)$x_time
  attr(x = m, which = "y_name") <- attributes(dist_matrix)$y_name
  attr(x = m, which = "x_name") <- attributes(dist_matrix)$x_name
  attr(x = m, which = "type") <- "cost"
  attr(x = m, which = "distance") <- attributes(dist_matrix)$distance

  m

}
