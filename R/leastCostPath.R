#' Extracts the least cost path from a least cost matrix.
#'
#' @description Extracts the least cost path from a least cost matrix.
#'
#' @usage leastCostPath(least.cost.matrix = NULL)
#'
#' #' @param distance.matrix numeric matrix or list of numeric matrices, a distance matrix produced by \code{\link{distanceMatrix}}.
#' @param least.cost.matrix numeric matrix or list of numeric matrices produced by \code{\link{leastCostMatrix}}.
#' @param diagonal boolean, if \code{TRUE}, diagonals are included in the computation of the least cost path. Defaults to \code{FALSE}, as the original algorithm did not include diagonals in the computation of the least cost path.
#' @return A list of dataframes if \code{least.cost.matrix} is a list, or a dataframe if \code{least.cost.matrix} is a matrix. The dataframe/s have the following columns:
#' \itemize{
#' \item \emph{A} row/sample of one of the sequences.
#' \item \emph{B} row/sample of one the other sequence.
#' \item \emph{distance} distance between both samples, extracted from \code{distance.matrix}.
#' \item \emph{cumulative.distance} cumulative distance at the samples \code{A} and \code{B}.
#' }
#' @examples
#'
#' @export
leastCostPath <- function(distance.matrix = NULL,
                          least.cost.matrix = NULL,
                          diagonal = NULL){

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
    n.elements <- length(least.cost.matrix)
  }

  if(inherits(distance.matrix, "list") == TRUE){
    m.elements <- length(distance.matrix)
  }

  if(n.elements != m.elements){
    stop("Arguments 'distance.matrix' and 'least.cost.matrix' don't have the same number of slots.")
  }

  if(n.elements > 1){
    if(sum(names(distance.matrix) %in% names(least.cost.matrix)) != n.elements){
      stop("Elements in arguments 'distance.matrix' and 'least.cost.matrix' don't have the same names.")
    }
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
                                    'least.cost.matrix',
                                    'distance.matrix',
                                    'diagonal'),
                          envir = environment()
                          )


  #parallelized loop
  least.cost.paths <- foreach::foreach(i=1:n.elements) %dopar% {

    #getting distance matrix
    least.cost.matrix.i <- least.cost.matrix[[i]]
    distance.matrix.i <- distance.matrix[[i]]

    if(sum(dim(least.cost.matrix.i) == dim(distance.matrix.i)) != 2){
      stop(paste("The elements ", i, " of 'distance.matrix' and 'least.cost.matrix' don't hav the same dimensions."))
    }

    #dataframe to store the path
    pairings <- data.frame(A = nrow(least.cost.matrix.i),
                           B = ncol(least.cost.matrix.i),
                           distance = distance.matrix.i[nrow(distance.matrix.i), ncol(distance.matrix.i)],
                           cumulative.distance = least.cost.matrix.i[nrow(least.cost.matrix.i), ncol(least.cost.matrix.i)])

    #defining coordinates of the focal cell
    focal.row <- pairings$A
    focal.column <- pairings$B

    #computation for no diaggonal
    if(diagonal == FALSE){

      #going through the matrix
      repeat{

        #defining values o focal row
        focal.cumulative.cost <- least.cost.matrix.i[focal.row, focal.column]
        focal.cost <- distance.matrix.i[focal.row, focal.column]

        #SCANNING NEIGHBORS
        neighbors <- data.frame(A=c(focal.row-1, focal.row),
                                  B=c(focal.column, focal.column-1))

        #removing neighbors with coordinates lower than 1 (out of bounds)
        neighbors[neighbors<1] <- NA
        neighbors <- na.omit(neighbors)
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
        neighbors <- neighbors[which.min(neighbors$cumulative.distance), c("A", "B")]

        #temporal dataframe to rbind with pairings
        pairings.temp <- data.frame(
          A = neighbors$A,
          B = neighbors$B,
          distance = distance.matrix.i[neighbors$A, neighbors$B],
          cumulative.distance = least.cost.matrix.i[neighbors$A, neighbors$B]
        )

        #putting them together
        pairings <- rbind(pairings, pairings.temp)

        #new focal cell
        focal.row <- pairings[nrow(pairings), "A"]
        focal.column <- pairings[nrow(pairings), "B"]

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
        neighbors <- data.frame(A = c(focal.row-1, focal.row-1, focal.row),
                                B=c(focal.column, focal.column-1, focal.column-1))

        #removing neighbors with coordinates lower than 1 (out of bounds)
        neighbors[neighbors<1] <- NA
        neighbors <- na.omit(neighbors)
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
        neighbors <- neighbors[which.min(neighbors$cumulative.distance), c("A", "B")]

        #temporal dataframe to rbind with pairings
        pairings.temp <- data.frame(
          A = neighbors$A,
          B = neighbors$B,
          distance = distance.matrix.i[neighbors$A, neighbors$B],
          cumulative.distance = least.cost.matrix.i[neighbors$A, neighbors$B]
        )

        #putting them together
        pairings<-rbind(pairings, pairings.temp)

        #new focal cell
        focal.row <- pairings[nrow(pairings), "A"]
        focal.column <- pairings[nrow(pairings), "B"]

      }#end of repeat

    } #end of diagonal == TRUE

    return(pairings)

  } #end of %dopar%

  #stopping cluster
  parallel::stopCluster(my.cluster)

  #list names
  names(least.cost.paths) <- names(least.cost.matrix)

  #unlist if there is only one combination
  if(n.elements == 1){
    least.cost.paths <- least.cost.paths[[1]]
  }

  #return output
  return(least.cost.paths)

} #end of function



