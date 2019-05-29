#' Computes a least cost matrix from a distance matrix.
#'
#' @description Computes a least cost matrix from a distance matrix, constrained by the order of the samples in the two sequences used to compute the distance matrix.
#'
#' @usage leastCostMatrix <- function(
#'   distance.matrix = NULL,
#'   diagonal = FALSE
#'   )
#'
#' @param distance.matrix numeric matrix or list of numeric matrices, a distance matrix produced by \code{\link{distanceMatrix}}.
#' @param diagonal boolean, if \code{TRUE}, diagonals are included in the computation of the least cost path. Defaults to \code{FALSE}, as the original algorithm did not include diagonals in the computation of the least cost path.
#' @return A matrix with the same dimensions as \code{distance.matrix}.
#' @examples
#'
#' @export
leastCostMatrix <- function(distance.matrix, diagonal = FALSE){

  #if input is matrix, get it into list
  if(inherits(distance.matrix, "matrix") == TRUE | is.matrix(distance.matrix) == TRUE){
    temp <- list()
    temp[[1]] <- distance.matrix
    distance.matrix <- temp
    names(distance.matrix) <- ""
  }

  if(inherits(distance.matrix, "list") == TRUE){
    n.elements <- length(distance.matrix)
  }

  #setting diagonal if it's empty
  if(is.null(diagonal)){diagonal <- FALSE}


  #creating cluster
  n.cores <- parallel::detectCores() - 1
  my.cluster <- parallel::makeCluster(n.cores, type="FORK")
  doParallel::registerDoParallel(my.cluster)

  #exporting cluster variables
  parallel::clusterExport(cl = my.cluster,
                          varlist = c('n.elements',
                                    'distance.matrix',
                                    'diagonal'),
                          envir = environment()
                          )


  least.cost.matrices <- foreach::foreach(i=1:n.elements) %dopar% {

  #getting distance matrix
  distance.matrix.i <- distance.matrix[[i]]

  #dimensions
  least.cost.columns <- ncol(distance.matrix.i)
  least.cost.rows <- nrow(distance.matrix.i)

  #matrix to store least cost
  least.cost.matrix <- matrix(nrow = least.cost.rows, ncol = least.cost.columns)
  rownames(least.cost.matrix) <- rownames(distance.matrix.i)
  colnames(least.cost.matrix) <- colnames(distance.matrix.i)


  #first value
  least.cost.matrix[1,1] <- distance.matrix.i[1,1]
  rownames(least.cost.matrix) <- rownames(distance.matrix.i)
  colnames(least.cost.matrix) <- colnames(distance.matrix.i)

  #initiating first column
  least.cost.matrix[1, ] <-cumsum(distance.matrix.i[1, ])

  #initiating the first row
  least.cost.matrix[, 1] <- cumsum(distance.matrix.i[, 1])

  #compute least cost if diagonal is TRUE
  if(diagonal == TRUE){
    for (column in 1:(least.cost.columns-1)){
      for (row in 1:(least.cost.rows-1)){

        next.row <- row+1
        next.column <- column+1

        least.cost.matrix[next.row, next.column]  <-  min(least.cost.matrix[row, next.column], least.cost.matrix[next.row, column], least.cost.matrix[row, column]) + distance.matrix.i[next.row, next.column]

      }
    }
  }

  #computing least cost id diagonal is FALSE
  if(diagonal == FALSE){
    for (column in 1:(least.cost.columns-1)){
      for (row in 1:(least.cost.rows-1)){

        next.row <- row+1
        next.column <- column+1

          least.cost.matrix[next.row, next.column]  <-  min(least.cost.matrix[row, next.column], least.cost.matrix[next.row, column]) + distance.matrix.i[next.row, next.column]

      }
    }
  }

  return(least.cost.matrix)

  } #end of %dopar%

  #stopping cluster
  parallel::stopCluster(my.cluster)

  #list names
  names(least.cost.matrices) <- names(distance.matrix)

#unlist if there is only one combination
if(n.elements == 1){
  least.cost.matrices <- least.cost.matrices[[1]]
}

#return output
return(least.cost.matrices)

} #end of function



