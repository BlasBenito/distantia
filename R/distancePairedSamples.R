#' Computes distance among pairs of aligned samples in two or more multivariate time-series.
#'
#' @description Computes the distance (one of: "manhattan", "euclidean", "chi", or "hellinger") between pairs of aligned samples (same order/depth/age) in two or more multivariate time-series.
#'
#' @usage distancePairedSamples(
#'   sequences = NULL,
#'   grouping.column = NULL,
#'   time.column = NULL,
#'   exclude.columns = NULL,
#'   method = "manhattan"
#'   )
#'
#' @param sequences dataframe with multiple sequences identified by a grouping column. Generally the ouput of \code{\link{prepareSequences}}.
#' @param grouping.column character string, name of the column in \code{sequences} to be used to identify separates sequences within the file. This argument is ignored if \code{sequence.A} and \code{sequence.B} are provided.
#' @param time.column character string, name of the column with time/depth/rank data. The data in this column is not modified.
#' @param exclude.columns character string or character vector with column names in \code{sequences}, or \code{squence.A} and \code{sequence.B} to be excluded from the analysis.
#' @param method character string naming a distance metric. Valid entries are: "manhattan", "euclidean", "chi", and "hellinger". Invalid entries will throw an error.
#' @return A list with named slots containing numeric vectors with the distance between paired samples of every possible combination of sequences according to \code{grouping.column}.
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
#' #loading data
#' data(climate)
#'
#' #preparing sequences
#' #notice the argument paired.samples
#' seq <- prepareSequences(
#'   sequences = climate,
#'   grouping.column = "sequenceId",
#'   time.column = "time",
#'   paired.samples = TRUE
#'   )
#'
#' #compute pairwise distances between paired samples
#' seq.distances <- distancePairedSamples(
#'   sequences = climate.prepared,
#'   grouping.column = "sequenceId",
#'   time.column = "time",
#'   exclude.columns = NULL,
#'   method = "manhattan"
#'   )
#'
#' @export
  distancePairedSamples <- function(
    sequences = NULL,
    grouping.column = NULL,
    time.column = NULL,
    exclude.columns = NULL,
    method = "manhattan"
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

    #removing exclude columns
    if(!is.null(exclude.columns)){
      sequences <- sequences[,!(colnames(sequences) %in% exclude.columns)]
    }

    #checking if the sequences are actually paired

    #if time.column is true
    if(!is.null(time.column)){

      #counts number of time each "time" value appears
      temp.table.time <- table(sequences[, time.column])
      temp.table.time <- data.frame(value=names(temp.table.time), frequency=as.vector(temp.table.time), stringsAsFactors = FALSE)

      #selecting these that have the same number in frequency as number of sequences we are working with
      valid.time.values <- as.numeric(temp.table.time[temp.table.time$frequency == length(unique(sequences[, grouping.column])), "value"])

      #subsetting sequences
      sequences <- sequences[sequences[, time.column] %in% valid.time.values, ]

    }

    #checking if groups have the same number of rows
    temp.table.rows <- table(sequences[, grouping.column])
    if(length(unique(temp.table.rows)) > 1){
      warning("The argument 'paired.samples' was set to TRUE, but at least one of the sequences don't have the same number of rows than the others. Please, check what is wrong here.")
      print(data.frame(id=names(temp.table.rows), rows=as.vector(temp.table.rows)))
    }

    #removing time column
    if(!is.null(time.column)){
      if(time.column %in% colnames(sequences)){
        time.column.values <- sequences[, time.column]
        sequences[, time.column] <- NULL
      }
    }


    #COMPUTATION OF PAIRWISE DISTANCES BETWEEN SAMPLES
    #generate combinations of groups for subsetting
    combinations <- utils::combn(unique(sequences[, grouping.column]), m=2)

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
    distance.vectors <- foreach::foreach(i=1:n.combinations) %dopar% {

      #getting combination
      combination <- c(combinations[, i])

      #target columns
      target.columns <- which(colnames(sequences) != grouping.column)

      #subsetting sequences
      sequence.A <- as.matrix(sequences[sequences[, grouping.column] %in% combination[1], target.columns])
      sequence.B <- as.matrix(sequences[sequences[, grouping.column] %in% combination[2], target.columns])

      #computing number of rows
      nrow.sequence.A <- nrow(sequence.A)
      nrow.sequence.B <- nrow(sequence.B)
      if(nrow.sequence.A != nrow.sequence.B){
        #unlikely error here
        stop("Something went wrong, two sequences don't have the same number of rows.")
      }

      #creating results vector
      distance.vector <- vector()

      #distance matrix
      for (i in 1:nrow.sequence.A){
        distance.vector[i] <- distance(x = sequence.A[i,], y = sequence.B[i,], method=method)
      }

      #vector names
      names(distance.vector) <- order(unique(time.column.values))
      return(distance.vector)


    } #end of dopar

    #stopping cluster
    parallel::stopCluster(my.cluster)

    return(distance.vectors)

  }#end of function
