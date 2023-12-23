#' Distance Matrix Between Multivariate Time Series.
#'
#' @description Computes distance matrices among the samples of two or more multivariate time-series provided in a single dataframe (generally produced by [prepareSequences](), identified by a grouping column (argument `grouping.column`). Distances can be computed with the methods "manhattan", "euclidean", "chi", and "hellinger", and are implemented in the function [distance].
#'
#' The function uses the packages \code{\link[parallel]{parallel}}, \code{\link[foreach]{foreach}}, and \code{\link[doParallel]{doParallel}} to compute distances matrices among different sequences in parallel. It is configured to use all processors available minus one.
#'
#' @param sequences (required, data frame) dataframe with multiple sequences identified by a grouping column. Generally the ouput of [prepareSequences()]. Default: NULL
#' @param grouping.column (required, character string) name of the column in `sequences` grouping separate time series. This argument is ignored if `sequence.A` and `sequence.B` are provided. Default: NULL
#' @param time.column (required, character string) name of the column with time/depth/rank data. Default: NULL
#' @param exclude.columns (optional, character vector) names of columns to be excluded from the distance computation. Default: NULL
#' @param method (optional, character string) name of the distance metric. Valid entries are: "manhattan", "euclidean", "chi", and "hellinger". Default: "manhattan
#' @param parallel.execution (optional, logical) if `TRUE`, execution is parallelized. Default: `FALSE`
#' @return A list with named slots containing the the distance matrices of every possible combination of sequences according to \code{grouping.column}.
#' @details Distances are computed as:
#' \itemize{
#' \item "manhattan": `sum(abs(x - y))`
#' \item "euclidean": `qrt(sum((x - y)^2))`.
#' \item "chi":
#'     `xy <- x + y`
#'     `y. <- y / sum(y)`
#'     `x. <- x / sum(x)`
#'     `sqrt(sum(((x. - y.)^2) / (xy / sum(xy))))`
#' \item "hellinger": `sqrt(1/2 * sum((sqrt(x) - sqrt(y))^2))`
#' }
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
#'if(interactive()){
#'  plotMatrix(distance.matrix = AB.distance.matrix)
#'}
#'
#'
#' @export
distanceMatrix <- function(
    sequences = NULL,
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
  combinations <- t(arrangements::combinations(unique(sequences[, grouping.column]), k = 2))

  #number of combinations
  n.iterations <- dim(combinations)[2]


  #target columns
  target.columns <- which(colnames(sequences) != grouping.column)

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
                varlist=c('combinations', 'sequences', 'distance', 'target.columns'),
                envir=environment()
                )
  } else {
    #replaces dopar (parallel) by do (serial)
    `%dopar%` <- foreach::`%do%`
    on.exit(`%dopar%` <- foreach::`%dopar%`)
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
