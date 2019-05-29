#' Computes distance matrix among the samples of two multivariate time-series.
#'
#' @description Computes a distance matrix among the samples of two or several multivariate time-series provided in a single dataframe, identified by a grouping column. Distances can be computed through the methods "manhattan", "euclidean", "chi", and "hellinger", and are implemented in the function \code{\link{distance}}. The function uses the packages \code{\link[parallel]{parallel}} and \code{\link[doParallel]{doParallel}} to compute distances matrices among different sequences in parallel.
#'
#' @usage distanceMatrix(
#'   sequences = NULL,
#'   grouping.column = NULL,
#'   time.column = NULL,
#'   method = "manhattan"
#'   )
#'
#' @param sequences dataframe with multiple sequences identified by a grouping column.
#' @param grouping.column character string, name of the column in \code{sequences} to be used to identify separates sequences within the file. This argument is ignored if \code{sequence.A} and \code{sequence.B} are provided.
#' @param time.colum character string, name of the column with time/depth/rank data. The data in this column is not modified.
#' @param exclude.columns character string or character vector with column names in \code{sequences}, or \code{squence.A} and \code{sequence.B} to be excluded from the analysis.
#' @param method character string naming a distance metric. Valid entries are: "manhattan", "euclidean", "chi", and "hellinger". Invalid entries will throw an error.
#' @return A matrix with the distances among samples of both sequences if there are only two groups in \code{sequences} according to \code{grouping.column}. A list with named slots containing the the distance matrices of every possible combination of sequences according to \code{grouping.column}.
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
#'#loading data
#'data(sequenceA)
#'data(sequenceB)
#'
#'#preparing datasets
#'sequences <- prepareSequences(
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
#'D <- distanceMatrix(
#'  sequences = sequences,
#'  grouping.column = "id",
#'  method = "manhattan"
#'  )
#'
#'#plot
#'image(D)
#'
#' @export
distanceMatrix <- function(sequences = NULL,
                           grouping.column = NULL,
                           time.column = NULL,
                           method = "manhattan"
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
      stop("Argument grouping.column must be a column of the dataframe 'sequences'.")
    }
  }

  #CHECKING IF grouping.column EXISTS
  if(!(grouping.column %in% colnames(sequences))){
    stop("The argument 'grouping.column' must be a column name of the 'sequences' dataset.")
  }

  #CHECKING IF THERE IS MORE THAN ONE GROUP
  if(length(unique(sequences[, grouping.column])) < 2){
    stop("According to 'grouping.column' there is only one sequence in the 'sequences' dataset. At least two sequences are required!")
  }

  #REMOVING TIME COLUMN
  if(!is.null(time.column)){
    if(time.column %in% colnames(sequences)){
      sequences[, time.column] <- NULL
    }
  }

  #generate combinations of groups for subsetting
  combinations <- combn(unique(sequences[, grouping.column]), m=2)

  #number of combinations
  n.combinations <- dim(combinations)[2]

  #creating cluster
  n.cores <- parallel::detectCores() - 1
  my.cluster <- parallel::makeCluster(n.cores, type="FORK")
  doParallel::registerDoParallel(my.cluster)

  #exporting cluster variables
  parallel::clusterExport(cl=my.cluster,
                varlist=c('combinations', 'sequences', 'distance'),
                envir=environment()
                )

  #parallelized loop
  distance.matrices <- foreach::foreach(i=1:n.combinations) %dopar% {

    #getting combination
    combination <- c(combinations[, i])

    #target columns
    target.columns <- which(colnames(sequences) != grouping.column)

    #subsetting sequences
    sequence.A <- as.matrix(sequences[sequences[, grouping.column] %in% combination[1], target.columns])
    sequence.B <- as.matrix(sequences[sequences[, grouping.column] %in% combination[2], target.columns])

    #computing row size
    nrow.sequence.A <- nrow(sequence.A)
    nrow.sequence.B <- nrow(sequence.B)

    #creating results matrix
    distance.matrix <- matrix(ncol = nrow.sequence.B, nrow = nrow.sequence.A)

    #distance matrix
    for (i in 1:nrow.sequence.A){
      for (j in 1:nrow.sequence.B){
        distance.matrix[i,j] <- distance(x = sequence.A[i,], y = sequence.B[j,], method=method)
      }
    }

    return(distance.matrix)

  } #end of dopar

  #stopping cluster
  parallel::stopCluster(my.cluster)

  #combination names
  names(distance.matrices) <- paste(combinations[1, 1:n.combinations], combinations[2, 1:n.combinations], sep="|")

  #unlist if there is only one combination
  if(n.combinations == 1){
    distance.matrices <- distance.matrices[[1]]
  }

  #return output
  return(distance.matrices)
}
