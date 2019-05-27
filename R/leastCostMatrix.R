#' Computes a least cost matrix from a distance matrix.
#'
#' @description Computes a least cost matrix from a distance matrix, constrained by the order of the samples in the two sequences used to compute the distance matrix.
#'
#' @usage leastCostMatrix <- function(
#'   distance.matrix = NULL,
#'   diagonal = FALSE
#'   )
#'
#' @param distance.matrix numeric matrix, a distance matrix produced by \code{\link{distanceMatrix}}.
#' @param diagonal boolean, if \code{TRUE}, diagonals are included in the computation of the least cost path. Defaults to \code{FALSE}, as the original algorithm did not include diagonals in the computation of the least cost path.
#' @return A matrix with the same dimensions as \code{distance.matrix}.
#' @examples
#'#loading data
#'data(sequenceA)
#'data(sequenceB)
#'
#'#preparing datasets
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
#'#computing distance matrix
#'D <- distanceMatrix(
#'  sequences = sequences,
#'  grouping.column = "id",
#'  method = "manhattan"
#'  )
#'
#'#plot
#'image(D)
#'
#'#computing least cost matrix
#'L <- leastCostMatrix(
#'  distance.matrix = D,
#'  diagonal = TRUE
#'  )
#'
#'#plot
#'image(L)
#'
#' @export
leastCostMatrix <- function(distance.matrix, diagonal = FALSE){

  #setting diagonal if it's empty
  if(is.null(diagonal)){diagonal <- FALSE}

  #stopping if it is not a matrix
  if(is.matrix(distance.matrix) == FALSE){
    stop("This is not a distance matrix.")
  }

  #dimensions
  least.cost.columns <- ncol(distance.matrix)
  least.cost.rows <- nrow(distance.matrix)

  #matrix to store least cost
  least.cost.matrix <- matrix(nrow = least.cost.rows, ncol = least.cost.columns)
  rownames(least.cost.matrix) <- rownames(distance.matrix)
  colnames(least.cost.matrix) <- colnames(distance.matrix)

  #first value
  least.cost.matrix[1,1] <- distance.matrix[1,1]
  rownames(least.cost.matrix) <- rownames(distance.matrix)
  colnames(least.cost.matrix) <- colnames(distance.matrix)

  #initiating first column
  least.cost.matrix[1, ] <-cumsum(distance.matrix[1, ])

  #initiating the first row
  least.cost.matrix[, 1] <- cumsum(distance.matrix[, 1])

  #compute least cost if diagonal is TRUE
  if(diagonal == TRUE){
    for (column in 1:(least.cost.columns-1)){
      for (row in 1:(least.cost.rows-1)){

        next.row <- row+1
        next.column <- column+1

        least.cost.matrix[next.row, next.column]  <-  min(least.cost.matrix[row, next.column], least.cost.matrix[next.row, column], least.cost.matrix[row, column]) + distance.matrix[next.row, next.column]

      }
    }
  }

  #computing least cost id diagonal is FALSE
  if(diagonal == FALSE){
    for (column in 1:(least.cost.columns-1)){
      for (row in 1:(least.cost.rows-1)){

        next.row <- row+1
        next.column <- column+1

          least.cost.matrix[next.row, next.column]  <-  min(least.cost.matrix[row, next.column], least.cost.matrix[next.row, column]) + distance.matrix[next.row, next.column]

      }
    }
  }

  return(least.cost.matrix)
}



