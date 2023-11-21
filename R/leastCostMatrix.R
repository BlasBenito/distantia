#' Computes a least cost matrix from a distance matrix.
#'
#' @description Computes the constrained (by sample order) minimum sum of distances among samples in two multivariate time-series by finding the least cost path between the first and last samples in a distance matrix computed by \code{\link{distanceMatrix}}. The minimum distance is found trough an efficient dynamic programming algorithm that first solves the local least cost path between adjacent samples, and uses the partial solutions to find the global solution.
#'
#' The algorithm is based on the sequence slotting algorithm described by Birks and Gordon (1985). In its original version, the algorithm searches for the least cost path between a given sample of one sequence (A) and the samples of the other sequence (B) in orthogonal directions (either one step in the x axis or one step in the y axis), which allows to locate the two samples in B between which the target sample in A "belongs" (has the least distance to). Therefore, the algorithm is in fact ordering the samples in both sequences to virtually create a single sequence (as in \code{B1, A1, A2, B2, etc}) with the samples ordered in the way that minimizes the global distance among them.
#'
#' This function provides an additional option that allows to include the diagonals in the search of the least cost path through the \code{diagonal} argument (which is \code{FALSE} by default). This modification allows to find, for each sample in A, the most similar sample in B, and align them together, if the distance among them is lower than the one found in the orthogonal directions. Both options give highly correlated least cost distances for the same matrices, but have different applications.
#'
#'
#' @usage leastCostMatrix(
#'   distance.matrix = NULL,
#'   diagonal = FALSE,
#'   parallel.execution = TRUE
#'   )
#'
#' @param distance.matrix numeric matrix or list of numeric matrices, a distance matrix produced by \code{\link{distanceMatrix}}.
#' @param diagonal boolean, if \code{TRUE}, diagonals are included in the computation of the least cost path. Defaults to \code{FALSE}, as the original algorithm did not include diagonals in the computation of the least cost path.
#' @param parallel.execution boolean, if \code{TRUE} (default), execution is parallelized, and serialized if \code{FALSE}.
#'
#' @return A list of matrices with the same dimensions as \code{distance.matrix} with the cumulative least cost among samples. The value of the lower-right cell (in the actual data matrix, not in the plotted version!) represents the sum of the least cost path across all samples.
#'
#' \itemize{
#' \item Birks, H.J.B.  and Gordon, A.D. (1985) Numerical Methods in Quaternary Pollen Analysis. Academic Press.
#' \item Clark, R.M., (1985) A FORTRAN program for constrained sequence-slotting based on minimum combined path length. Computers & Geosciences, Volume 11, Issue 5, Pages 605-617. Doi: https://doi.org/10.1016/0098-3004(85)90089-5.
#' \item Thompson, R., Clark, R.M. (1989) Sequence slotting for stratigraphic correlation between cores: theory and practice. Journal of Paleolimnology, Volume 2, Issue 3, pp 173–184
#' }
#'
#' @examples
#'
#' \donttest{
#'
#'#loading data
#'data(sequenceA)
#'data(sequenceB)
#'
#'#preparing datasets
#'AB.sequences <- prepareSequences(
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
#'AB.distance.matrix <- distanceMatrix(
#'  sequences = AB.sequences,
#'  grouping.column = "id",
#'  method = "manhattan",
#'  parallel.execution = FALSE
#'  )
#'
#'#computing least cost matrix
#'AB.least.cost.matrix <- leastCostMatrix(
#'  distance.matrix = AB.distance.matrix,
#'  diagonal = FALSE,
#'  parallel.execution = FALSE
#'  )
#'
#'#plot
#' #plotMatrix(distance.matrix = AB.distance.matrix)
#' #plotMatrix(distance.matrix = AB.least.cost.matrix)
#'
#'}
#'
#' @export
leastCostMatrix <- function(distance.matrix = NULL,
                            diagonal = FALSE,
                            parallel.execution = TRUE
                            ){

  #checking if it is a list
  if(inherits(distance.matrix, "list") == FALSE){
    #if not, gets it into a list if it's a matrix
    if(inherits(distance.matrix, "matrix") == TRUE){
      temp <- list()
      temp[[1]] <- distance.matrix
      distance.matrix <- temp
      names(distance.matrix) <- "A|B"
    } else {
      stop("The input is not a matrix")
    }
    }

  n.iterations <- length(distance.matrix)

  #setting diagonal if it's empty
  if(is.null(diagonal)){diagonal <- FALSE}

  #making sure %dopar% gets recognized
  `%dopar%` <- foreach::`%dopar%`

  #parallel execution = TRUE
  if(parallel.execution == TRUE){
    `%dopar%` <- foreach::`%dopar%`
    n.cores <- parallel::detectCores() - 1
    if(n.iterations < n.cores){n.cores <- n.iterations}

    if(.Platform$OS.type == "windows"){
      my.cluster <- parallel::makeCluster(n.cores, type="PSOCK")
    } else {
      my.cluster <- parallel::makeCluster(n.cores, type="FORK")
    }

    doParallel::registerDoParallel(my.cluster)

  #exporting cluster variables
  parallel::clusterExport(cl = my.cluster,
                          varlist = c('n.iterations',
                                    'distance.matrix',
                                    'diagonal'),
                          envir = environment()
                          )
  } else {
    #replaces dopar (parallel) by do (serial)
    `%dopar%` <- foreach::`%do%`
    on.exit(`%dopar%` <- foreach::`%dopar%`)
    }

  #parallelized loop
  least.cost.matrices <- foreach::foreach(
    i=1:n.iterations
    ) %dopar% {

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
    least.cost.matrix[1, ] <- cumsum(distance.matrix.i[1, ])

    #initiating the first row
    least.cost.matrix[, 1] <- cumsum(distance.matrix.i[, 1])

    #if both sequences have more than one sample
    if(least.cost.columns != 1 & least.cost.rows != 1){

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
    } else {
      #both sequences have one sample
      if(least.cost.columns == 1 & least.cost.rows == 1){
        least.cost.matrix <- as.matrix(distance.matrix.i)
      }

      if(least.cost.columns == 1 & least.cost.rows > 1){
        least.cost.matrix <- as.matrix(cumsum(distance.matrix.i))
      }

      if(least.cost.columns > 1 & least.cost.rows == 1){
        least.cost.matrix <- t(as.matrix(cumsum(distance.matrix.i)))
      }

    }

    #adding the value of the first cell to the last cell (it is not counted by the algorithm)
    least.cost.matrix[least.cost.rows, least.cost.columns] <- least.cost.matrix[least.cost.rows, least.cost.columns] + least.cost.matrix[1, 1]

    return(least.cost.matrix)

  } #end of %dopar%

  #stopping cluster
  if(parallel.execution == TRUE){
    parallel::stopCluster(my.cluster)
  } else {
    #creating the correct alias again
    `%dopar%` <- foreach::`%dopar%`
  }

  #list names
  names(least.cost.matrices) <- names(distance.matrix)

  #return output
  return(least.cost.matrices)

} #end of function



