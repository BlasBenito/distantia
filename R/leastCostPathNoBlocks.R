#' Extracts the least-cost from a least cost matrix by trimming blocks.
#'
#' @description Extracts the minimum cost of a least-cost path by trimming blocks (straight segments of the path that appear in highly dissimilar regions of the sequences). Blocks inflate psi values when two sequences are similar but have very different numbers of rows. This function is for internal use of other functions in the package.
#'
#' @usage leastCostPathNoBlocks(
#'   least.cost.path = NULL,
#'   parallel.execution = TRUE
#'   )
#'
#' @param least.cost.path dataframe produced by \code{\link{leastCostPath}}.
#' @param parallel.execution boolean, if \code{TRUE} (default), execution is parallelized, and serialized if \code{FALSE}.
#' @return A named list with least cost values.
#'
#'@export
leastCostPathNoBlocks <- function(least.cost.path, parallel.execution = TRUE){

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
  least.cost.paths <- foreach::foreach(i=1:n.iterations) %dopar% {

    #getting sequence names
    sequence.names = unlist(strsplit(names(least.cost.path)[i], split='|', fixed=TRUE))

    #extracting least.cost path
    path <- least.cost.path[[i]]
    path <- path[nrow(path):1, ]
    rownames(path) <- 1:nrow(path)

    #add keep column
    path$keep <- NA

    #keeping first and last rows
    path[c(1, nrow(path)) , "keep"] <- TRUE

    #vectors to introduce used indices
    used <- list()
    used[[1]] <- vector()
    used[[2]] <- vector()
    names(used) <- sequence.names

    #starting values for dynamic variables
    target.index <- 1
    target.sequence <- sequence.names[1]

    #switch if this index is not repeated in this sequence
    if(!(sum(path[,target.sequence] == target.index) > 1)){
      target.sequence <- sequence.names[sequence.names != target.sequence]
    }

    #adding 1 to used
    used[[target.sequence]] <- c(used[[target.sequence]], path[target.index, target.sequence])

    #first row of path
    j <- 2

    #iterating through AB.index.unique
    ##################################
    while(j < (nrow(path) - 1)){

      #IS REPEATED?
      if(path[j, target.sequence] %in% used[[target.sequence]]){

        #IS EQUAL TO THE NEXT ONE?
        if(path[j, target.sequence] == path[j + 1, target.sequence]){

          #YES
          j <- j + 1
          next

          #NO
        } else {

          #ADD IT
          path[j , "keep"] <- TRUE

          #SWITCH
          target.sequence <- sequence.names[sequence.names != target.sequence]

          #add index to used
          used[[target.sequence]] <- c(used[[target.sequence]], path[j, target.sequence])

          j <- j + 1
          next

        }
      } else {

        #ADD IT
        path[j , "keep"] <- TRUE

        #SWITCH
        target.sequence <- sequence.names[sequence.names != target.sequence]

        #add index to used
        used[[target.sequence]] <- c(used[[target.sequence]], path[j, target.sequence])

        j <- j + 1
        next

      }

    }

    #removing na
    path <- na.omit(path)

    return(path)

  } #end of dopar

  #stopping cluster
  if(parallel.execution == TRUE){
    parallel::stopCluster(my.cluster)
  } else {
    #creating the correct alias again
    `%dopar%` <- foreach::`%dopar%`
  }

  #list names
  names(least.cost.paths) <- names(least.cost.path)

  #return output
  return(least.cost.paths)

}
