#' Extracts the least cost from a least-cost path.
#'
#' @description Sums the the distances of the samples in a least-cost path.
#'
#' @usage leastCost(
#'   least.cost.path = NULL,
#'   parallel.execution = TRUE
#'   )
#'
#' @param least.cost.path dataframe produced by \code{\link{leastCostPath}}.
#' @param parallel.execution boolean, if \code{TRUE} (default), execution is parallelized, and serialized if \code{FALSE}.
#' @return A named list with least-cost values.
#' @return A named list with least cost values.
#'
#' @export
leastCost <- function(least.cost.path = NULL, parallel.execution = TRUE){

  #number of iterations
  if(inherits(least.cost.path, "list") == TRUE){
    n.iterations <- length(least.cost.path)
  } else {
    if(inherits(least.cost.path, "data.frame") == TRUE){
      n.iterations <- 1
    }
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
                                        'least.cost.path'),
                            envir = environment()
    )
  } else {
    #replaces dopar (parallel) by do (serial)
    `%dopar%` <- foreach::`%do%`
  }

  #iterating through available elements
  least.costs <- foreach::foreach(i=1:n.iterations) %dopar% {

    #getting sequence names
    sequence.names = unlist(strsplit(names(least.cost.path)[i], split='|', fixed=TRUE))

    #extracting least.cost path
    path <- least.cost.path[[i]]
    path <- path[nrow(path):1, ]
    rownames(path) <- 1:nrow(path)

    #least cost
    least.cost <- sum(path$distance)

    return(least.cost)

  } #end of dopar

  #stopping cluster
  if(parallel.execution == TRUE){
    parallel::stopCluster(my.cluster)
  } else {
    #creating the correct alias again
    `%dopar%` <- foreach::`%dopar%`
  }

  #list names
  names(least.costs) <- names(least.cost.path)

  #return output
  return(least.costs)

}
