#' Normalized Dissimilarity Score
#'
#' @description Computes the dissimilarity metric \code{psi} (Birks and Gordon 1985).
#' @param path_sum (required, numeric) Result of [cost_path_sum()] on the least cost path between the sequences to compare.
#' @param auto_sum (required, numeric) Result of [auto_sum()] on the sequences to compare. Default: NULL
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
#' a <- sequenceA |>
#'   na.omit() |>
#'   as.matrix()
#'
#' b <- sequenceB |>
#'   na.omit() |>
#'   as.matrix()
#'
#' d <- distance_matrix(
#'   a,
#'   b
#' )
#'
#' m <- cost_matrix(
#'   dist_matrix = d
#' )
#'
#' path <- cost_path(
#'   dist_matrix = d,
#'   cost_matrix = m
#' )
#'
#' path_sum <- cost_path_sum(path)
#'
#' ab_sum <- auto_sum(
#'   a = a,
#'   b = b,
#'   path = path
#' )
#'
#' psi <- psi_value(
#'   cost_path_sum = path_sum,
#'   auto_sum = ab_sum
#' )
#'
#' @autoglobal
#' @export
psi_value <- function(
    cost_path_sum = NULL,
    auto_sum = NULL,
    diagonal = FALSE
    ){

  if(is.null(cost_path_sum)){
    stop("Argument 'cost_sum' is required.")
  }

  if(is.null(auto_sum)){
    stop("Argument 'auto_sum' is required.")
  }

  psi <- ((cost_path_sum * 2) - auto_sum) / auto_sum

  if(diagonal == TRUE){
    psi <- psi + 1
  }

  psi

}
