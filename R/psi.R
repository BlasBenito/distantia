#' Normalized Dissimilarity Score
#'
#' @description Computes the dissimilarity metric \code{psi} (Birks and Gordon 1985).
#' @param path_sum (required, numeric) Result of [psi_cost_path_sum()] on the least cost path between the sequences to compare.
#' @param auto_sum (required, numeric) Result of [psi_auto_sum()] on the sequences to compare. Default: NULL
#' @param diagonal (optional, logical) If the cost matrix and least cost path were computed using `diagonal = TRUE`, this argument should be `TRUE` as well. Used to correct the computation of `psi` when diagonals are used. Default: TRUE
#' @details The measure of dissimilarity \code{psi} is computed as: \code{least.cost - (autosum of sequences)) / autosum of sequences}. It has a lower limit at 0, while there is no upper limit.
#'
#' @return Psi value.
#'
#' @author Blas Benito <blasbenito@gmail.com>
#'
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
#' @autoglobal
#' @export
psi <- function(
    path_sum = NULL,
    auto_sum = NULL,
    diagonal = TRUE
    ){

  if(!is.numeric(path_sum)){
    stop("Argument 'cost_sum' must be numeric.")
  }

  if(!is.numeric(auto_sum)){
    stop("Argument 'auto_sum' must be numeric.")
  }

  if(is.logical(diagonal) == FALSE){
    stop("Argument 'diagonal' must be logical (TRUE or FALSE)")
  }

  psi <- ((path_sum * 2) - auto_sum) / auto_sum

  if(diagonal == TRUE){
    psi <- psi + 1
  }

  psi

}

