#' Computes sum of distances between consecutive samples in a multivariate time-series.
#'
#' @description Computes the sum of distances between consecutive samples in a multivariate time-series. Required to compute the measure of dissimilarity \code{psi} (Birks and Gordon 1985). Distances can be computed through the methods "manhattan", "euclidean", "chi", and "hellinger", and are implemented in the function \code{\link{distance}}.
#'
#' @usage psi(
#'   least.cost = NULL,
#'   autosum = NULL,
#'   parallel.execution = TRUE)
#'
#' @param autosum dataframe with one or several multivariate time-series identified by a grouping column.
#' @param least.cost character string, name of the column with time/depth/rank data. The data in this column is not modified.
#' @param parallel.execution boolean, if \code{TRUE} (default), execution is parallelized, and serialized if \code{FALSE}.
#'
#' @details The measure of dissimilarity \code{psi} is computed as: \code{least.cost - (autosum of sequences)) / autosum of sequences}. It has a lower limit at 0, while there is no upper limit.
#'
#' @return A list with named slots, each one with a psi value.
#'
#' @author Blas Benito <blasbenito@gmail.com>
#'
#' \itemize{
#' \item Birks, H.J.B.  and Gordon, A.D. (1985) Numerical Methods in Quaternary Pollen Analysis. Academic Press.
#' }
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
#'#extracting least cost
#'AB.least.cost <- leastCost(
#'  least.cost.matrix = AB.least.cost.matrix,
#'  parallel.execution = FALSE
#'  )
#'
#'#autosum
#'AB.autosum <- autosum(
#'  sequences = AB.sequences,
#'  grouping.column = "id",
#'  parallel.execution = FALSE
#'  )
#'AB.autosum
#'
#'AB.psi <- psi(
#'  least.cost = AB.least.cost,
#'  distance.matrix = AB.distance.matrix,
#'  autosum = AB.autosum,
#'  parallel.execution = FALSE
#'  )
#'AB.psi
#'
#'}
#'
#'@export
psi <- function(least.cost = NULL,
                autosum = NULL,
                parallel.execution = TRUE){


  #computing number of elements
  if(inherits(least.cost, "list") == TRUE){
    n.iterations <- length(least.cost)
  } else {
    temp <- list()
    temp[[1]] <- least.cost
    least.cost <- temp
    names(least.cost) <- "A|B"
    n.iterations <- 1
  }

  #parallel execution = TRUE
  if(parallel.execution == TRUE){
    `%dopar%` <- foreach::`%dopar%`
    n.cores <- parallel::detectCores() - 1
    if(n.iterations < n.cores){n.cores <- n.iterations}
    my.cluster <- parallel::makeCluster(n.cores, type="FORK")
    doParallel::registerDoParallel(my.cluster)

  #exporting cluster variables
  parallel::clusterExport(cl = my.cluster,
                          varlist = c('n.iterations',
                                      'least.cost',
                                      'autosum'),
                          envir = environment()
  )
  } else {
    #replaces dopar (parallel) by do (serial)
    `%dopar%` <- foreach::`%do%`
  }

  #parallelized loop
  psi.values <- foreach::foreach(i = 1:n.iterations) %dopar% {

    #cost of the best solution
    optimal.cost <- least.cost[[i]] * 2

    #getting names of the sequences
    sequence.names = unlist(strsplit(names(least.cost)[i], split='|', fixed=TRUE))

    #computing autosum of both sequences
    sum.autosum <- autosum[[sequence.names[1]]] + autosum[[sequence.names[2]]]

    #computing psi
    #if optimal.cost equals 0, they are the same sequence, and psi is zero
    if(optimal.cost <= 0){
      psi.value <- 0
      } else {
        psi.value <- abs((optimal.cost - sum.autosum) / sum.autosum)
        if(is.na(psi.value)){print(i)}
      }

    return(psi.value)

  } #end of parallelized loop

  #stopping cluster
  if(parallel.execution == TRUE){
    parallel::stopCluster(my.cluster)
  } else {
    #creating the correct alias again
    `%dopar%` <- foreach::`%dopar%`
  }

  #naming slots in list
  names(psi.values) <- names(least.cost)

  return(psi.values)

} #end of function
