#' Cost Matrix
#'
#' @description Computes the cost matrix from a distance matrix.
#'
#' @param dist_matrix (required, numeric matrix). Distance matrix.
#' @param diagonal (optional, logical). If `TRUE`, diagonals are included in the computation of the cost matrix Default: FALSE.
#' @param weighted (optional, logical). Only relevant if `diagonal = TRUE`. If `TRUE`, weights diagonal cost by a factor of 1.414214.
#' @return A cost matrix.
#' @examples
#' data(
#'   sequenceA,
#'   sequenceB
#' )
#'
#' a <- sequenceA |>
#'   na.omit() |>
#'   as.matrix()
#'
#' b <- sequenceB |>
#'   na.omit() |>
#'   as.matrix()
#'
#' distance.matrix <- distance_matrix(
#'   a = a,
#'   b = b,
#'   distance = "manhattan"
#' )
#'
#' cost.matrix <- cost_matrix(
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
cost_matrix <- function(dist_matrix = NULL, diagonal = FALSE, weighted = FALSE){

  if(is.null(dist_matrix)){
    stop("Argument 'dist_matrix' must not be NULL.")
  }
  if(!is.numeric(dist_matrix) | !is.matrix(dist_matrix)){
    stop("Argument 'dist_matrix' must be a numeric matrix.")
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
  rownames(m) <- rownames(dist_matrix)
  colnames(m) <- colnames(dist_matrix)

  m

}
