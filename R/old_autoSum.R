#' Computes sum of distances between consecutive samples in a multivariate time-series.
#'
#' @description Computes the sum of distances between consecutive samples in a multivariate time-series. Required to compute the measure of dissimilarity \code{psi} (Birks and Gordon 1985). Distances can be computed through the methods "manhattan", "euclidean", "chi", and "hellinger", and are implemented in the function \code{\link{distance}}.
#'
#' @usage autoSum(
#'   sequences = NULL,
#'   least.cost.path = NULL,
#'   time.column = NULL,
#'   grouping.column = NULL,
#'   exclude.columns = NULL,
#'   method = "manhattan",
#'   parallel.execution = TRUE
#'   )
#'
#' @param sequences dataframe with one or several multivariate time-series identified by a grouping column.
#' @param least.cost.path a list usually resulting from either \code{\link{leastCostPath}} or \code{\link{leastCostPathNoBlocks}}.
#' @param time.column character string, name of the column with time/depth/rank data. The data in this column is not modified.
#' @param grouping.column character string, name of the column in \code{sequences} to be used to identify separates sequences within the file. This argument is ignored if \code{sequence.A} and \code{sequence.B} are provided.
#' @param exclude.columns character string or character vector with column names in \code{sequences}, or \code{squence.A} and \code{sequence.B} to be excluded from the analysis.
#' @param method character string naming a distance metric. Valid entries are: "manhattan", "euclidean", "chi", and "hellinger". Invalid entries will throw an error.
#' @param parallel.execution boolean, if \code{TRUE} (default), execution is parallelized, and serialized if \code{FALSE}.
#' @return A list with slots named according \code{grouping.column} if there are several sequences in \code{sequences} or a number if there is only one sequence.
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
#'
#' \itemize{
#' \item Birks, H.J.B.  and Gordon, A.D. (1985) Numerical Methods in Quaternary Pollen Analysis. Academic Press.
#' }
#' @seealso \code{\link{distance}}
#' @examples
#'
#' \donttest{
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
#'#autosum
#'AB.autosum <- autoSum(
#'  sequences = AB.sequences,
#'  least.cost.path = AB.least.cost.path,
#'  grouping.column = "id",
#'  parallel.execution = FALSE
#'  )
#'AB.autosum
#'
#'}
#'
#'@export
autoSum <- function(
    sequences = NULL,
    least.cost.path = NULL,
    time.column = NULL,
    grouping.column = NULL,
    exclude.columns = NULL,
    method = "manhattan",
    parallel.execution = TRUE
    ){

  #checking sequences
  if(is.data.frame(sequences) == FALSE){
    stop("Argument 'sequences' must be a dataframe with at least two ordered multivariate sequences identified by a 'grouping.column'.")
  }

  #grouping.column
  if(is.null(grouping.column)){
    if("id" %in% colnames(sequences)){
      grouping.column = "id" #default behavior of prepareSequences
    } else {
      #sequences probably has a single sequence, dummy name
      grouping.column = "id"
      sequences$id = "A"
    }
  }

  #groups
  groups <- unique(sequences[, grouping.column])

  #number of sequences to compute the autosum of
  if(!is.null(least.cost.path)){
    n.iterations <- length(least.cost.path)
  }

  #removing time column
  if(!is.null(time.column)){
    sequences <- sequences[, !(colnames(sequences) %in% time.column)]
  }

  #removing exclude columns
  if(!is.null(exclude.columns)){
    sequences <- sequences[, !(colnames(sequences) %in% exclude.columns)]
  }

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
    parallel::clusterExport(cl=my.cluster,
                            varlist=c('n.iterations',
                                      'least.cost.path',
                                      'sequences',
                                      'distance',
                                      'groups'),
                            envir=environment()
    )
  } else {
    #replaces dopar (parallel) by do (serial)
    `%dopar%` <- foreach::`%do%`
    on.exit(`%dopar%` <- foreach::`%dopar%`)
  }


  #parallelized loop
  autosum.sequences <- foreach::foreach(i = 1:n.iterations) %dopar% {

    #getting sequence names
    sequence.names = unlist(strsplit(names(least.cost.path)[i], split='|', fixed=TRUE))

    #getting sequence
    sequence.A <- sequences[sequences[,grouping.column] %in% sequence.names[1], ]
    sequence.B <- sequences[sequences[,grouping.column] %in% sequence.names[2], ]

    #getting numeric columns only
    sequence.A <- sequence.A[,sapply(sequence.A, is.numeric)]
    sequence.B <- sequence.B[,sapply(sequence.B, is.numeric)]

    #getting least.cost.path
    least.cost.path.i <- least.cost.path[[names(least.cost.path)[i]]]

    #checking if it is a least.cost.path and removing cases that are not in the least-cost path after removing blocks
    if(inherits(least.cost.path.i, "data.frame")){
      if(colnames(least.cost.path.i)[1] == sequence.names[1] & colnames(least.cost.path.i)[2] == sequence.names[2]){
        sequence.A <- sequence.A[unique(least.cost.path.i[,sequence.names[1]]), ]
        sequence.B <- sequence.B[unique(least.cost.path.i[,sequence.names[2]]), ]
      }
    }

    #output vector
    distances.A <- vector()
    distances.B <- vector()

    #number of columns
    ncol.sequence.A <- ncol(sequence.A)
    ncol.sequence.B <- ncol(sequence.B)

    #if the sequence has one column only (a vector)
    if(is.null(ncol.sequence.A)){

      #number of elements
      nrow.sequence.A <- length(sequence.A)

      #computing distances
      for (j in 1:(nrow.sequence.A-1)){
        distances.A[j] <- distance(x = sequence.A[j], y = sequence.A[j+1], method = method)
      }
    } else {

      #number of elements
      nrow.sequence.A <- nrow(sequence.A)
      if(nrow.sequence.A == 1){
        distances.A[1] <- 0
      } else {
        for (j in 1:(nrow.sequence.A-1)){
          distances.A[j] <- distance(x = sequence.A[j, ], y = sequence.A[j+1, ], method = method)
        }
      }
    }

    #if the sequence has one column only (a vector)
    if(is.null(ncol.sequence.B)){

      #number of elements
      nrow.sequence.B <- length(sequence.B)

      #computing distances
      for (j in 1:(nrow.sequence.B-1)){
        distances.B[j] <- distance(x = sequence.B[j], y = sequence.B[j+1], method = method)
      }
    } else {

      #number of elements
      nrow.sequence.B <- nrow(sequence.B)
      if(nrow.sequence.B == 1){
        distances.B[1] <- 0
      } else {
        for (j in 1:(nrow.sequence.B-1)){
          distances.B[j] <- distance(x = sequence.B[j, ], y = sequence.B[j+1, ], method = method)
        }
      }
    }

    #returning sum of distances
    return(sum(sum(distances.A), sum(distances.B)))

  } #end of parallel execution

  #stopping cluster
  if(parallel.execution == TRUE){
    parallel::stopCluster(my.cluster)
  } else {
    #creating the correct alias again
    `%dopar%` <- foreach::`%dopar%`
  }

  #naming slots in list
  names(autosum.sequences) <- names(least.cost.path)

  return(autosum.sequences)

} #end of function
