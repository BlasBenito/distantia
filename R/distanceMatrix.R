#' Computes distance matrices among the samples of two or more multivariate time-series.
#'
#' @description Computes distance matrices among the samples of two or more multivariate time-series provided in a single dataframe (generally produced by \code{\link{prepareSequences}}), identified by a grouping column (argument \code{grouping.column}). Distances can be computed with the methods "manhattan", "euclidean", "chi", and "hellinger", and are implemented in the function \code{\link{distance}}. The function uses the packages \code{\link[parallel]{parallel}}, \code{\link[foreach]{foreach}}, and \code{\link[doParallel]{doParallel}} to compute distances matrices among different sequences in parallel. It is configured to use all processors available minus one.
#'
#' @usage distanceMatrix(
#'   sequences = NULL,
#'   grouping.column = NULL,
#'   time.column = NULL,
#'   exclude.columns = NULL,
#'   method = "manhattan",
#'   parallel.execution = TRUE
#'   )
#'
#' @param sequences dataframe with multiple sequences identified by a grouping column. Generally the ouput of \code{\link{prepareSequences}}.
#' @param grouping.column character string, name of the column in \code{sequences} to be used to identify separates sequences within the file. This argument is ignored if \code{sequence.A} and \code{sequence.B} are provided.
#' @param time.column character string, name of the column with time/depth/rank data. The data in this column is not modified.
#' @param exclude.columns character string or character vector with column names in \code{sequences}, or \code{squence.A} and \code{sequence.B} to be excluded from the analysis.
#' @param method character string naming a distance metric. Valid entries are: "manhattan", "euclidean", "chi", and "hellinger". Invalid entries will throw an error.
#' @param parallel.execution boolean, if \code{TRUE} (default), execution is parallelized, and serialized if \code{FALSE}.
#' @return A list with named slots containing the the distance matrices of every possible combination of sequences according to \code{grouping.column}.
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
#' @seealso \code{\link{distance}}
#' @examples
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
#'
#'#plot
#'plotMatrix(distance.matrix = AB.distance.matrix)
#'
#' @export
distanceMatrix <- function(sequences = NULL,
                           grouping.column = NULL,
                           time.column = NULL,
                           exclude.columns = NULL,
                           method = "manhattan",
                           parallel.execution = TRUE
                           ){

  #checking sequences
  if(is.data.frame(sequences) == FALSE){
    stop("Argument 'sequences' must be a dataframe with at least two ordered multivariate sequences identified by a 'grouping.column'.")
  }

  #exclude.columns
  if(!is.null(exclude.columns) & !is.character(exclude.columns)){
    stop("Argument 'exclude.columns' must be of type character.")
  }

  #grouping.column
  if(is.null(grouping.column)){
    if("id" %in% colnames(sequences)){
    grouping.column = "id" #default behavior of prepareSequences
    } else {
      stop("Argument grouping.column must be a column of the dataframe 'sequences'.")
    }
  }
  if(!(grouping.column %in% colnames(sequences))){
    stop("The argument 'grouping.column' must be a column name of the 'sequences' dataset.")
  }

  #how many groups?
  if(length(unique(sequences[, grouping.column])) < 2){
    stop("According to 'grouping.column' there is only one sequence in the 'sequences' dataset. At least two sequences are required!")
  }

  #removing time column
  if(!is.null(time.column)){
    if(time.column %in% colnames(sequences)){
      sequences[, time.column] <- NULL
    }
  }

  #removing exclude columns
  if(!is.null(exclude.columns)){
    sequences <- sequences[,!(colnames(sequences) %in% exclude.columns)]
  }

  #generate combinations of groups for subsetting
  combinations <- t(arrangements::permutations(unique(sequences[, grouping.column]), k = 2))

  #number of combinations
  n.iterations <- dim(combinations)[2]


  #target columns
  target.columns <- which(colnames(sequences) != grouping.column)

  #parallel execution = TRUE
  if(parallel.execution == TRUE){
    `%dopar%` <- foreach::`%dopar%`
    n.cores <- parallel::detectCores() - 1
    if(n.iterations < n.cores){n.cores <- n.iterations}
    my.cluster <- parallel::makeCluster(n.cores, type="FORK")
    doParallel::registerDoParallel(my.cluster)

  #exporting cluster variables
  parallel::clusterExport(cl=my.cluster,
                varlist=c('combinations', 'sequences', 'distance', 'target.columns'),
                envir=environment()
                )
  } else {
    #replaces dopar (parallel) by do (serial)
    `%dopar%` <- foreach::`%do%`
  }

  #parallelized loop
  distance.matrices <- foreach::foreach(i=1:n.iterations) %dopar% {

    #getting combination
    combination <- c(combinations[, i])

    #subsetting sequences
    sequence.A <- as.matrix(sequences[sequences[, grouping.column] %in% combination[1], target.columns])
    sequence.B <- as.matrix(sequences[sequences[, grouping.column] %in% combination[2], target.columns])

    #computing number of rows
    nrow.sequence.A <- nrow(sequence.A)
    nrow.sequence.B <- nrow(sequence.B)

    #creating results matrix
    # distance.matrix <- matrix(ncol = nrow.sequence.B, nrow = nrow.sequence.A)

    #distance matrix
    # for (j in 1:nrow.sequence.A){
    #   for (k in 1:nrow.sequence.B){
    #     distance.matrix[j,k] <- distance(x = sequence.A[j,], y = sequence.B[k,], method=method)
    #   }
    # }

    #with outer
    distance.matrix <- outer(
      1:nrow.sequence.A,
      1:nrow.sequence.B,
      FUN = Vectorize(
        function(x, y) distance(
          sequence.A[x,],
          sequence.B[y,],
          method = method)
        )
      )

    return(distance.matrix)

  } #end of dopar

  #stopping cluster
  if(parallel.execution == TRUE){
    parallel::stopCluster(my.cluster)
  } else {
    #creating the correct alias again
    `%dopar%` <- foreach::`%dopar%`
  }

  #combination names
  names(distance.matrices) <- paste(combinations[1, 1:n.iterations], combinations[2, 1:n.iterations], sep="|")

  #return output
  return(distance.matrices)
}
