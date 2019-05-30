#' Computes sum of distances between consecutive samples in a multivariate time-series.
#'
#' @description Computes the sum of distances between consecutive samples in a multivariate time-series. Required to compute the measure of dissimilarity \code{psi} (Birks and Gordon 1985). Distances can be computed through the methods "manhattan", "euclidean", "chi", and "hellinger", and are implemented in the function \code{\link{distance}}.
#'
#' @usage autoSum <- function(
#'   sequences = NULL,
#'   grouping.column = NULL,
#'   time.column = NULL,
#'   exclude.columns = NULL,
#'   method = "manhattan"
#'   )
#'
#' @param sequences dataframe with one or several multivariate time-series identified by a grouping column.
#' @param time.colum character string, name of the column with time/depth/rank data. The data in this column is not modified.
#' @param grouping.column character string, name of the column in \code{sequences} to be used to identify separates sequences within the file. This argument is ignored if \code{sequence.A} and \code{sequence.B} are provided.
#' @param exclude.columns character string or character vector with column names in \code{sequences}, or \code{squence.A} and \code{sequence.B} to be excluded from the analysis.
#' @param method character string naming a distance metric. Valid entries are: "manhattan", "euclidean", "chi", and "hellinger". Invalid entries will throw an error.
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
#'#autosum
#'AB.autoSum <- autosum(
#'  sequences = AB.sequences,
#'  grouping.column = "id"
#'  )
#'AB.autosum
#'
#'@export
autoSum <- function(sequences = NULL,
                    time.column = NULL,
                    grouping.column = NULL,
                    exclude.columns = NULL,
                    method = "manhattan"){

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
  n.sequences <- length(groups)

  #removing time column
  if(!is.null(time.column)){
    sequences <- sequences[, !(colnames(sequences) %in% time.column)]
  }

  #removing exclude columns
  if(!is.null(exclude.columns)){
    sequences <- sequences[, !(colnames(sequences) %in% exclude.columns)]
  }

  #creating cluster
  n.cores <- parallel::detectCores() - 1
  my.cluster <- parallel::makeCluster(n.cores, type="FORK")
  doParallel::registerDoParallel(my.cluster)

  #exporting cluster variables
  parallel::clusterExport(cl=my.cluster,
                          varlist=c('n.sequences',
                                    'sequences',
                                    'distance',
                                    'groups'),
                          envir=environment()
  )


  #parallelized loop
  autosum.sequences <- foreach::foreach(i=1:n.sequences) %dopar% {

    #getting sequence
    sequence <- sequences[sequences[,grouping.column] == groups[i], ]

    #getting numeric columns only
    sequence <- sequence[,sapply(sequence, is.numeric)]

    #removing grouping column
    sequence[,grouping.column] <- NULL

    #number of rows
    nrow.sequence <- nrow(sequence)

    #output vectors
    distances <- vector()

    #computing distance
      for (i in 1:(nrow.sequence-1)){
        distances[i] <- distance(x = sequence[i, ], y = sequence[i+1, ], method = method)
      }

    return(sum(distances))

} #end of parallel execution

  #stopping cluster
  parallel::stopCluster(my.cluster)

  #naming slots in list
  names(autosum.sequences) <- groups

  #output is a numeric vector if there is only one group
  if(length(groups) == 1){
    autosum.sequences <- autosum.sequences[[1]]
  }

  return(autosum.sequences)

} #end of function
