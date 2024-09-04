#' Normalized Dissimilarity Score
#'
#' @description
#'
#' Demonstration function to computes the `psi` dissimilarity score (Birks and Gordon 1985). Psi is computed as \eqn{\psi = (2a / b) - 1}, where \eqn{a} is the sum of distances between the relevant samples of two time series, and \eqn{b} is the cumulative sum of distances between consecutive samples in the two time series.
#'
#' If `a` is computed with dynamic time warping, and diagonals are used in the computation of the least cost path, then one is added to the result of the equation above.
#'
#' @param a (required, numeric) Result of [psi_cost_path_sum()], the sum of distances of the least cost path between two time series. Default: NULL
#' @param b (required, numeric) Result of [psi_auto_sum()], the cumulative sum of the consecutive cases of two time series. Default: NULL
#' @param diagonal (optional, logical) Used to correct the computation of `psi` when diagonals are used during the computation of the least cost path. If the cost matrix and least cost path were computed using `diagonal = TRUE`, this argument should be `TRUE` as well. Default: TRUE
#'
#' @return numeric value
#' @examples
#' #distance metric
#' d <- "euclidean"
#'
#' #use diagonals in least cost computations
#' diagonal <- TRUE
#'
#' #remove blocks from least cost path
#' ignore_blocks <- TRUE
#'
#' #simulate two irregular time series
#' x <- zoo_simulate(
#'   name = "x",
#'   rows = 100,
#'   seasons = 2,
#'   seed = 1
#'   )
#'
#' y <- zoo_simulate(
#'   name = "y",
#'   rows = 80,
#'   seasons = 2,
#'   seed = 2
#'   )
#'
#' if(interactive()){
#'   zoo_plot(x = x)
#'   zoo_plot(x = y)
#' }
#'
#' #dynamic time warping
#'
#' #distance matrix
#' dist_matrix <- psi_distance_matrix(
#'   x = x,
#'   y = y,
#'   distance = d
#' )
#'
#' #cost matrix
#' cost_matrix <- psi_cost_matrix(
#'   dist_matrix = dist_matrix,
#'   diagonal = diagonal
#' )
#'
#' #least cost path
#' cost_path <- psi_cost_path(
#'   dist_matrix = dist_matrix,
#'   cost_matrix = cost_matrix,
#'   diagonal = diagonal
#' )
#'
#' if(interactive()){
#'   utils_matrix_plot(
#'     m = cost_matrix,
#'     path = cost_path
#'     )
#' }
#'
#' #remove blocks from least cost path
#' if(ignore_blocks == TRUE){
#'   cost_path <- psi_cost_path_ignore_blocks(
#'     path = cost_path
#'   )
#' }
#'
#' #computation of psi score
#'
#' #sum of distances in least cost path
#' a <- psi_cost_path_sum(
#'   path = cost_path
#'   )
#'
#' #auto sum of both time series
#' b <- psi_auto_sum(
#'   x = x,
#'   y = y,
#'   path = cost_path,
#'   distance = d
#' )
#'
#' #dissimilarity score
#' psi_equation(
#'   a = a,
#'   b = b,
#'   diagonal = diagonal
#' )
#'
#' #full computation with distantia()
#' tsl <- list(
#'   x = x,
#'   y = y
#' )
#'
#' distantia(
#'   tsl = tsl,
#'   distance = d,
#'   diagonal = diagonal,
#'   ignore_blocks = ignore_blocks
#' )$psi
#'
#' if(interactive()){
#'   distantia_plot(
#'     tsl = tsl,
#'     distance = d,
#'     diagonal = diagonal,
#'     ignore_blocks = ignore_blocks
#'   )
#' }
#' @autoglobal
#' @export
#' @family psi_demo
psi_equation <- function(
    a = NULL,
    b = NULL,
    diagonal = TRUE
    ){

  if(!is.numeric(a)){
    stop("Argument 'a' must be numeric.")
  }

  if(!is.numeric(b)){
    stop("Argument 'b' must be numeric.")
  }

  if(is.logical(diagonal) == FALSE){
    stop("Argument 'diagonal' must be logical (TRUE or FALSE)")
  }

  psi_equation_cpp(
    a,
    b,
    diagonal
  )

}

