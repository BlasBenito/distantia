#' Extracts the least cost from a least cost matrix.
#'
#' @description Extracts the minimum cost (cell in the lower right corner) of a least cost matrix. this function is for internal use of other functions in the package.
#'
#' @usage leastCost(least.cost.matrix = NULL)
#'
#' @param least.cost.matrix numeric matrix or list of numeric matrices produced by \code{\link{leastCostMatrix}}.
#' @return A list if \code{least.cost.matrix} is a list, or a numeric vector if \code{least.cost.matrix} is a matrix.
#'
#' @export
leastCost <- function(least.cost.matrix = NULL){

  #if input is matrix, get it into list
  if(inherits(least.cost.matrix, "matrix") == TRUE | is.matrix(least.cost.matrix) == TRUE){
    temp <- list()
    temp[[1]] <- least.cost.matrix
    least.cost.matrix <- temp
    names(least.cost.matrix) <- ""
    n.elements <- 1
  }

  if(inherits(least.cost.matrix, "list") == TRUE){
    n.elements <- length(least.cost.matrix)
  }



  #creating cluster
  n.cores <- parallel::detectCores() - 1
  my.cluster <- parallel::makeCluster(n.cores, type="FORK")
  doParallel::registerDoParallel(my.cluster)

  #exporting cluster variables
  parallel::clusterExport(cl = my.cluster,
                          varlist = c('n.elements',
                                    'least.cost.matrix'),
                          envir = environment()
                          )


  least.costs <- foreach::foreach(i=1:n.elements) %dopar% {

  #getting distance matrix
  least.cost.matrix.i <- least.cost.matrix[[i]]

  #dimensions
  least.cost.columns <- ncol(least.cost.matrix.i)
  least.cost.rows <- nrow(least.cost.matrix.i)

  #getting least cost
  least.cost <- least.cost.matrix.i[least.cost.rows, least.cost.columns]

  return(least.cost)

  } #end of %dopar%

  #stopping cluster
  parallel::stopCluster(my.cluster)

  #list names
  names(least.costs) <- names(least.cost.matrix)

#unlist if there is only one combination
if(n.elements == 1){
  least.costs <- least.costs[[1]]
}

#return output
return(least.costs)

} #end of function



