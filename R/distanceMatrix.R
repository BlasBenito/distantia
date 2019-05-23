#' Computes distance matrix among the samples of two multivariate time-series.
#'
#' @description Computes a distance matrix among the samples of two multivariate time-series. Distances can be computed through the methods "manhattan", "euclidean", "chi", and "hellinger", and are implemented in the function \code{\link{distance}}.
#'
#' @usage distanceMatrix <- function(
#'   sequence.A = NULL,
#'   sequence.B = NULL,
#'   time.column = NULL,
#'   exclude.columns = NULL,
#'   method = "manhattan"
#'   )
#'
#' @param sequence.A dataframe, a multivariate time-series.
#' @param sequence.B dataframe, a multivariate time-series.
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
#'data(sequenceB)
#'
#'#matching datasets
#'sequences <- prepareSequences(
#'  sequence.A = sequenceA,
#'  sequence.A.name = "A",
#'  sequence.B = sequenceB,
#'  sequence.B.name = "B",
#'  merge.mode = "complete",
#'  if.empty.cases = "zero",
#'  transformation = "hellinger"
#'  )
#'
#'#separating them again
#'#(not actually required in a normal workflow)
#'A <- sequences[sequences$id == "A", ]
#'B <- sequences[sequences$id == "B", ]
#'
#'#computing distance matrix
#'D <- distanceMatrix(
#'  sequence.A = A,
#'  sequence.B = B,
#'  time.column = NULL,
#'  exclude.columns = "id",
#'  method = "manhattan"
#'  )
#'
#'#plot
#'image(D)
#'
#' @export
distanceMatrix <- function(sequence.A = NULL,
                           sequence.B = NULL,
                           time.column = NULL,
                           exclude.columns = NULL,
                           method = "manhattan"
                           ){

  #removing time column
  if(!is.null(time.column)){
  sequence.A <- sequence.A[, !(colnames(sequence.A) %in% time.column)]
  sequence.B <- sequence.B[, !(colnames(sequence.B) %in% time.column)]
  }

  #removing exclude columns
  if(!is.null(exclude.columns)){
    sequence.A <- sequence.A[, !(colnames(sequence.A) %in% exclude.columns)]
    sequence.B <- sequence.B[, !(colnames(sequence.B) %in% exclude.columns)]
  }

  #computing row size
  nrow.sequence.A <- nrow(sequence.A)
  nrow.sequence.B <- nrow(sequence.B)

  #creating results matrix
  distance.matrix <- matrix(ncol = nrow.sequence.B, nrow = nrow.sequence.A)

  #COMPUTING DISTANCE MATRIX
  ############################################################################################
  #computing manhattan distance
  for (i in 1:nrow.sequence.A){
    for (j in 1:nrow.sequence.B){
      distance.matrix[i,j] <- distance(x = sequence.A[i,], y = sequence.B[j,], method=method)
    }
  }

  #seting col and row names
  colnames(distance.matrix) <- rownames(sequence.B)
  rownames(distance.matrix) <- rownames(sequence.A)

  return(distance.matrix)
}
