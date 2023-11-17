#' Find the least cost path in a least cost matrix.
#'
#' @description Uses the original distance matrix created by \code{\link{distanceMatrix}} and the least cost path matrix created by \code{\link{leastCostMatrix}} to find the least cost path between the first and the last cells of the matrix. If \code{diagonal} was \code{TRUE} in \code{\link{leastCostMatrix}}, then it must be \code{TRUE} when using this function. Otherwise, the default is \code{FALSE} in both.
#'
#' @usage leastCostPath(
#'   distance.matrix = NULL,
#'   least.cost.matrix = NULL,
#'   diagonal = FALSE,
#'   parallel.execution = TRUE
#'   )
#'
#' @param distance.matrix numeric matrix or list of numeric matrices, a distance matrix produced by \code{\link{distanceMatrix}}.
#' @param least.cost.matrix numeric matrix or list of numeric matrices produced by \code{\link{leastCostMatrix}}.
#' @param diagonal boolean, if \code{TRUE}, diagonals are included in the computation of the least cost path. Defaults to \code{FALSE}, as the original algorithm did not include diagonals in the computation of the least cost path.
#' @param parallel.execution boolean, if \code{TRUE} (default), execution is parallelized, and serialized if \code{FALSE}.
#' @return Alist of dataframes if \code{least.cost.matrix} is a list, or a dataframe if \code{least.cost.matrix} is a matrix. The dataframe/s have the following columns:
#' \itemize{
#' \item \emph{A} row/sample of one of the sequences.
#' \item \emph{B} row/sample of one the other sequence.
#' \item \emph{distance} distance between both samples, extracted from \code{distance.matrix}.
#' \item \emph{cumulative.distance} cumulative distance at the samples \code{A} and \code{B}.
#' }
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
#'AB.least.cost.path <- leastCostPath(
#'  distance.matrix = AB.distance.matrix,
#'  least.cost.matrix = AB.least.cost.matrix,
#'  parallel.execution = FALSE
#'  )
#'
#' #plot
#' #plotMatrix(
#' #  distance.matrix = AB.distance.matrix,
#' #  least.cost.path = AB.least.cost.path,
#' #)
#'
#'}
#'
#' @export
leastCostPath <- function(distance.matrix = NULL,
                          least.cost.matrix = NULL,
                          diagonal = FALSE,
                          parallel.execution = TRUE){

  #if input is matrix, get it into list
  if(inherits(least.cost.matrix, "matrix") == TRUE | is.matrix(least.cost.matrix) == TRUE){
    temp <- list()
    temp[[1]] <- least.cost.matrix
    least.cost.matrix <- temp
    names(least.cost.matrix) <- ""
  }

  #if input is matrix, get it into list
  if(inherits(distance.matrix, "matrix") == TRUE | is.matrix(distance.matrix) == TRUE){
    temp <- list()
    temp[[1]] <- distance.matrix
    distance.matrix <- temp
    names(distance.matrix) <- ""
  }

  if(inherits(least.cost.matrix, "list") == TRUE){
    n.iterations <- length(least.cost.matrix)
  }

  if(inherits(distance.matrix, "list") == TRUE){
    m.elements <- length(distance.matrix)
  }

  if(n.iterations != m.elements){
    stop("Arguments 'distance.matrix' and 'least.cost.matrix' don't have the same number of slots.")
  }

  if(n.iterations > 1){
    if(sum(names(distance.matrix) %in% names(least.cost.matrix)) != n.iterations){
      stop("Elements in arguments 'distance.matrix' and 'least.cost.matrix' don't have the same names.")
    }
  }

  #setting diagonal if it's empty
  if(is.null(diagonal)){diagonal <- FALSE}

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
                          varlist = c('least.cost.matrix',
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
  least.cost.paths <- foreach::foreach(i=1:n.iterations) %dopar% {

    #getting distance matrix
    least.cost.matrix.i <- least.cost.matrix[[i]]
    distance.matrix.i <- distance.matrix[[i]]

    if(sum(dim(least.cost.matrix.i) == dim(distance.matrix.i)) != 2){
      stop(paste("The elements ", i, " of 'distance.matrix' and 'least.cost.matrix' don't hav the same dimensions."))
    }

    #dimensions
    dimensions <- dim(least.cost.matrix.i)

    #dataframe to store the path
    path <- data.frame(
      A = c(
        dimensions[1],
        rep(NA, sum(dimensions))
        ),
      B = c(
        dimensions[2],
        rep(NA, sum(dimensions))),
      distance = c(
        distance.matrix.i[dimensions[1], dimensions[2]],
        rep(NA, sum(dimensions))
        ),
      cumulative.distance = c(
        least.cost.matrix.i[dimensions[1], dimensions[2]],
        rep(NA, sum(dimensions)))
      )

    #defining coordinates of the focal cell
    focal.row <- path$A
    focal.column <- path$B
    path.row <- 1

    #computation for no diaggonal
    if(diagonal == FALSE){

      #going through the matrix
      repeat{

        #defining values o focal row
        focal.cumulative.cost <- least.cost.matrix.i[focal.row, focal.column]
        focal.cost <- distance.matrix.i[focal.row, focal.column]

        #SCANNING NEIGHBORS
        neighbors <- data.frame(
          A = c(focal.row-1, focal.row),
          B = c(focal.column, focal.column-1)
          )

        #removing neighbors with coordinates lower than 1 (out of bounds)
        neighbors[neighbors<1] <- NA
        neighbors <- stats::na.omit(neighbors)
        if(nrow(neighbors) == 0){break}

        #computing cost and cumulative cost values for the neighbors
        if(nrow(neighbors) > 1){
          neighbors$distance <- diag(distance.matrix.i[neighbors$A, neighbors$B])
          neighbors$cumulative.distance <- diag(x = least.cost.matrix.i[neighbors$A, neighbors$B])
        } else {
          neighbors$distance <- distance.matrix.i[neighbors$A, neighbors$B]
          neighbors$cumulative.distance <- least.cost.matrix.i[neighbors$A, neighbors$B]
        }

        #getting the neighbor with a minimum least.cost.matrix.i
        neighbors <- neighbors[which.min(neighbors$cumulative.distance), ]

        #putting them together
        path.row <- path.row + 1
        path[path.row, ] <- neighbors

        #new focal cell
        focal.row <- neighbors$A
        focal.column <- neighbors$B

      }#end of repeat

    } #end of diagonal == FALSE


    #computation for  diaggonal
    if(diagonal == TRUE){

      #going through the matrix
      repeat{

        #defining values o focal row
        focal.cumulative.cost <- least.cost.matrix.i[focal.row, focal.column]
        focal.cost <- distance.matrix.i[focal.row, focal.column]

        #SCANNING NEIGHBORS
        neighbors <- data.frame(
          A = c(focal.row-1, focal.row-1, focal.row),
          B=c(focal.column, focal.column-1, focal.column-1)
          )

        #removing neighbors with coordinates lower than 1 (out of bounds)
        neighbors[neighbors<1] <- NA
        neighbors <- stats::na.omit(neighbors)
        if(nrow(neighbors) == 0){break}

        #computing cost and cumulative cost values for the neighbors
        if(nrow(neighbors) > 1){

          neighbors$distance <- diag(distance.matrix.i[neighbors$A, neighbors$B])
          neighbors$cumulative.distance <- diag(x = least.cost.matrix.i[neighbors$A, neighbors$B])

        }else{

          neighbors$distance <- distance.matrix.i[neighbors$A, neighbors$B]
          neighbors$cumulative.distance <- least.cost.matrix.i[neighbors$A, neighbors$B]

        }

        #getting the neighbor with a minimum least.cost.matrix.i
        neighbors <- neighbors[which.min(neighbors$cumulative.distance), ]

        #putting them together
        path.row <- path.row + 1
        path[path.row, ] <- neighbors

        #new focal cell
        focal.row <- neighbors$A
        focal.column <- neighbors$B

      }#end of repeat

    } #end of diagonal == TRUE

    #getting names of the sequences
    sequence.names = unlist(strsplit(names(distance.matrix)[i], split='|', fixed=TRUE))

    #remove empty rows of path
    path <- stats::na.omit(path)

    #renaming path
    colnames(path)[1] <- sequence.names[1]
    colnames(path)[2] <- sequence.names[2]

    return(path)

  } #end of %dopar%

  #stopping cluster
  if(parallel.execution == TRUE){
    parallel::stopCluster(my.cluster)
  } else {
    #creating the correct alias again
    `%dopar%` <- foreach::`%dopar%`
  }

  #list names
  names(least.cost.paths) <- names(least.cost.matrix)

  #return output
  return(least.cost.paths)

} #end of function



