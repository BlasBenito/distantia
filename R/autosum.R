#' Computes sum of distances between samples in a multivariate time-series.
#'
#' @description Computes the autosum of distances between consecutive samples in a multivariate time-series. Required to compute the measure of dissimilarity \code{psi}. Distances can be computed through the methods "manhattan", "euclidean", "chi", and "hellinger", and are implemented in the function \code{\link{distance}}.
#'
#' @usage autosum <- function(
#'   sequence = NULL,
#'   time.column = NULL,
#'   exclude.columns = NULL,
#'   method = "manhattan"
#'   )
#'
#' @param sequence dataframe, a multivariate time-series.
#' @param time.colum character string, name of the column with time/depth/rank data. The data in this column is not modified.
#' @param exclude.columns character string or character vector with column names in \code{sequences}, or \code{squence.A} and \code{sequence.B} to be excluded from the analysis.
#' @param method character string naming a distance metric. Valid entries are: "manhattan", "euclidean", "chi", and "hellinger". Invalid entries will throw an error.
#' @return A matrix with the distances among samples of both sequences.
#' @details Distances are computed as:
#' \itemize{
#' \item \code{manhattan}: \code{d <- sum(abs(x - y))}
#' \item \code{euclidean}: \code{d <- sqrt(sum((x - y)^2))}
#' \item \code{chi}: \code{
#'     xy <- x + y
#'     y. <- y / sum(y)
#'     x. <- x / sum(x)
#'     d <- sqrt(sum(((x. - y.)^2) / (xy / sum(xy))))}
#' \item \code{hellinger}: \code{d <- sqrt(1/2 * sum(sqrt(x) - sqrt(y))^2)}
#' }
#' Note that zeroes are replaced by 0.00001 whem \code{method} equals "chi" or "hellinger".
#' @author Blas Benito <blasbenito@gmail.com>
#' @seealso \code{\link{distance}}
#' @examples
#'
#'#loading data
#'data(sequenceA)
#'
#'#computing sum of distances between samples
#'autosum(sequence = sequenceA, method = "manhattan")
#'
autosum <- function(sequence = NULL,
                    time.column = NULL,
                    exclude.columns = NULL,
                    method = "manhattan"){

  #removing time column
  if(!is.null(time.column)){
    sequence <- sequence[, !(colnames(sequence) %in% time.column)]

  }

  #removing exclude columns
  if(!is.null(exclude.columns)){
    sequence <- sequence[, !(colnames(sequence) %in% exclude.columns)]  }

  #number of rows
  nrow.sequence <- nrow(sequence)

  #output vectors
  distances <- vector()

  #computing manhattan distance
    for (i in 1:(nrow.sequence-1)){
      distances[i] <- distance(x = sequence[i, ], y = sequence[i+1, ], method = method)
    }


  #SUM
  sum.distances <- sum(distances)

  return(sum.distances)

}
