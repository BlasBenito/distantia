#' Psi Distance Between Time Series
#'
#' @param a (required, data frame or matrix) a time series.
#' @param b (required, data frame or matrix) a time series.
#' @param method (optional, character string) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `methods`. Default: "euclidean".
#' @param diagonal (optional, logical). If TRUE, diagonals are included in the computation of the cost matrix. Default: FALSE.
#' @param weighted If TRUE, diagonal is set to TRUE, and diagonal cost is weighted by a factor of 1.414214. Default: FALSE.
#' @param trim_blocks (optional, logical). If TRUE, blocks of consecutive path coordinates are trimmed to avoid inflating the psi distance. Default: FALSE.
#' @param paired_samples (optional, logical) If TRUE, time-series are compared row wise and no least-cost path is computed. Default: FALSE
#' @examples
#'
#' data(
#'   sequenceA,
#'   sequenceB
#' )
#'
#' ab.psi <- distantia(
#'   a = sequenceA,
#'   b = sequenceB,
#'   method = "manhattan"
#' )
#'
#' @return Psi distance
#' @export
#' @autoglobal
distantia <- function(
    a = NULL,
    b = NULL,
    method = "euclidean",
    diagonal = FALSE,
    weighted = FALSE,
    trim_blocks = FALSE,
    paired_samples = FALSE
){

  if(paired_samples == TRUE){

    psi_distance <- distantia_pairwise_cpp(
      a,
      b,
      method
      )

  } else {

    psi_distance <- distantia_cpp(
      a,
      b,
      method,
      diagonal,
      weighted,
      trim_blocks
    )

  }

  psi_distance

}
