#' Normalized Dissimilarity Score
#'
#' @description Computes the dissimilarity metric \code{psi} (Birks and Gordon 1985).
#' @param path_sum (required, numeric) Result of [path_sum()] on the least cost path between the sequences to compare.
#' @param auto_sum (required, numeric) Result of [psi_auto_sum()] on the sequences to compare. Default: NULL
#' @param diagonal (optional, logical) If the cost matrix and least cost path were computed using `diagonal = TRUE`, this argument should be `TRUE` as well. Used to correct the computation of `psi` when diagonals are used.
#' @details The measure of dissimilarity \code{psi} is computed as: \code{least.cost - (autosum of sequences)) / autosum of sequences}. It has a lower limit at 0, while there is no upper limit.
#'
#' @return Psi value.
#'
#' @author Blas Benito <blasbenito@gmail.com>
#'
#' \itemize{
#' \item Birks, H.J.B.  and Gordon, A.D. (1985) Numerical Methods in Quaternary Pollen Analysis. Academic Press.
#' }
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
#'
#' d <- psi_dist_matrix(
#'   x,
#'   y
#' )
#'
#' m <- psi_cost_matrix(
#'   dist_matrix = d
#' )
#'
#' path <- psi_cost_path(
#'   dist_matrix = d,
#'   cost_matrix = m
#' )
#'
#' path_sum <- path_sum(path)
#'
#' xy_sum <- psi_auto_sum(
#'   x = x,
#'   y = y,
#'   path = path
#' )
#'
#' psi <- psi(
#'   path_sum = path_sum,
#'   auto_sum = xy_sum
#' )
#'
#' @autoglobal
#' @export
psi <- function(
    path_sum = NULL,
    auto_sum = NULL,
    diagonal = FALSE
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
