#' Computes sum of distances between consecutive samples in a multivariate time-series.
#'
#' @description Computes the sum of distances between consecutive samples in a multivariate time-series. Required to compute the measure of dissimilarity \code{psi} (Birks and Gordon 1985). Distances can be computed through the methods "manhattan", "euclidean", "chi", and "hellinger", and are implemented in the function \code{\link{distance}}.
#'
#' @usage
#'
#' @param autosum dataframe with one or several multivariate time-series identified by a grouping column.
#' @param least.cost character string, name of the column with time/depth/rank data. The data in this column is not modified.
#' @return A list with named slots, each one with a psi value.
#'
#' @author Blas Benito <blasbenito@gmail.com>
#'
#' \itemize{
#' \item Birks, H.J.B.  and Gordon, A.D. (1985) Numerical Methods in Quaternary Pollen Analysis. Academic Press.
#' }
#' @examples
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
#'  sequences = sequences,
#'  grouping.column = "id",
#'  method = "manhattan"
#'  )
#'
#'#computing least cost matrix
#'AB.least.cost.matrix <- leastCostMatrix(
#'  distance.matrix = AB.distance.matrix,
#'  diagonal = FALSE
#'  )
#'
#'#extracting least cost
#'AB.least.cost <- leastCost(
#'  least.cost.matrix = AB.least.cost.matrix
#'  )
#'
#'#autosum
#'AB.autosum <- autosum(
#'  sequences = AB.sequences,
#'  grouping.column = "id"
#'  )
#'AB.autosum
#'
#'AB.psi <- psi(
#'  least.cost = AB.least.cost,
#'  distance.matrix = AB.distance.matrix,
#'  autosum = AB.autosum
#'  )
#'AB.psi
#'
#'
#'
#'@export
psi <- function(least.cost = NULL,
                distance.matrix = NULL,
                autosum = NULL){


  #computing number of elements
  if(inherits(least.cost, "list") == TRUE){
    n.elements <- length(least.cost)
  } else {
    temp <- list()
    temp[[1]] <- least.cost
    least.cost <- temp
    names(least.cost) <- "A|B"
    n.elements <- 1
  }

  #computing number of elements
  if(inherits(distance.matrix, "list") == TRUE){
    m.elements <- length(distance.matrix)
  } else {
    temp <- list()
    temp[[1]] <- distance.matrix
    distance.matrix <- temp
    names(distance.matrix) <- "A|B"
    n.elements <- 1
  }

  if(n.elements != m.elements){
    stop("Arguments 'distance.matrix' and 'least.cost' don't have the same number of slots.")
  }

  if(n.elements > 1){
    if(sum(names(distance.matrix) %in% names(least.cost)) != n.elements){
      stop("Elements in arguments 'distance.matrix' and 'least.cost' don't have the same names.")
    }
  }


  #iterating to compute psi on each element
  #creating cluster
  n.cores <- parallel::detectCores() - 1
  my.cluster <- parallel::makeCluster(n.cores, type="FORK")
  doParallel::registerDoParallel(my.cluster)

  #exporting cluster variables
  parallel::clusterExport(cl = my.cluster,
                          varlist = c('n.elements',
                                      'distance.matrix',
                                      'least.cost',
                                      'autosum'),
                          envir = environment()
  )

  #parallelized loop
  psi.values <- foreach::foreach(i=1:n.elements) %dopar% {

    #getting element i of least.cost
    least.cost.i <- least.cost[[i]]

    #getting distance matrix
    distance.matrix.i <- distance.matrix[[i]]

    #getting names of the sequences
    sequence.names = unlist(strsplit(names(least.cost)[i], split='|', fixed=TRUE))

    #computing autosum of both sequences
    sum.autosum <- autosum[[sequence.names[1]]] + autosum[[sequence.names[2]]]

    #cost of the best solution
    optimal.cost <- (least.cost.i * 2) + (distance.matrix.i[1,1] * 2)

    #computing psi
    #if optimal.cost equals 0, they are the same sequence, and psi is zero
    if(optimal.cost <= 0){
      psi.value <- 0
      } else {
        psi.value <- (optimal.cost - sum.autosum) / sum.autosum
      }

    return(psi.value)

  }

  #stopping cluster
  parallel::stopCluster(my.cluster)

  #naming slots in list
  names(psi.values) <- names(least.cost)

  return(psi.values)

} #end of function
