#' Computes the dissimilarity measure \emph{psi} on restricted permutations of two or more sequences.
#'
#' @description The function first computes psi on the observed sequences, and then computes it on permutations of the input sequences by the \code{repetitions} argument. The data is randomized as follows: within each column, each data-point can be: 1) left as is; 2) replaced by the previous case; 3) replaced by the next case. The action applied to each data-point is selected randomly, and independently from the actions applied to other data-points. This type of randomization generates versions of the dataset that have the same general structure as the original one, but small local and independent changes only ocurring within the immediate neighborhood (one row up or down) of each case in the table. The method should generate very conservative random values of \code{psi}.
#'
#' @usage workflowNullPsi(
#'   sequences = NULL,
#'   grouping.column = NULL,
#'   time.column = NULL,
#'   exclude.columns = NULL,
#'   method = "manhattan",
#'   diagonal = FALSE,
#'   paired.samples = FALSE,
#'   same.time = FALSE,
#'   ignore.blocks = FALSE,
#'   parallel.execution = TRUE,
#'   repetitions = 9
#'   )
#'
#' @param sequences dataframe with multiple sequences identified by a grouping column generated by \code{\link{prepareSequences}}.
#' @param grouping.column character string, name of the column in \code{sequences} to be used to identify separates sequences within the file.
#' @param time.column character string, name of the column with time/depth/rank data.
#' @param exclude.columns character string or character vector with column names in \code{sequences} to be excluded from the analysis.
#' @param method character string naming a distance metric. Valid entries are: "manhattan", "euclidean", "chi", and "hellinger". Invalid entries will throw an error.
#' @param diagonal boolean, if \code{TRUE}, diagonals are included in the computation of the least cost path. Defaults to \code{FALSE}, as the original algorithm did not include diagonals in the computation of the least cost path. If \code{paired.samples} is \code{TRUE}, then \code{diagonal} is irrelevant.
#' @param paired.samples boolean, if \code{TRUE}, the sequences are assumed to be aligned, and distances are computed for paired-samples only (no distance matrix required). Default value is \code{FALSE}.
#' @param same.time boolean. If \code{TRUE}, samples in the sequences to compare will be tested to check if they have the same time/age/depth according to \code{time.column}. This argument is only useful when the user needs to compare two sequences taken at different sites but same time frames.
#' @param ignore.blocks boolean. If \code{TRUE}, the function \code{\link{leastCostPathNoBlocks}} analyzes the least-cost path of the best solution, and removes blocks (straight-orthogonal sections of the least-cost path), which happen in highly dissimilar sections of the sequences, and inflate output psi values.
#' @param parallel.execution boolean, if \code{TRUE} (default), execution is parallelized, and serialized if \code{FALSE}.
#' @param repetitions integer, number of null psi values to obtain.
#'
#' @return A list with two slots:
#' \itemize{
#' \item \emph{psi}: a dataframe. The first two columns contain the names of the sequences being compared, the third column contains the real \code{psi} value, and the rest of the column contain \code{psi} values computed on permutated versions of the datasets.
#' \item \emph{p}: a dataframe. The first two columns are as above, the third column contains the probability of obtaining a \code{random psi} lower than the real \code{psi} by chance.
#' }
#'
#' @author Blas Benito <blasbenito@gmail.com>
#'
#' @examples
#'
#' \donttest{
#' #load data
#' data("sequencesMIS")
#'
#' #prepare sequences
#' MIS.sequences <- prepareSequences(
#'   sequences = sequencesMIS,
#'   grouping.column = "MIS",
#'   transformation = "hellinger"
#'   )
#'
#'#execute workflow to compute psi
#'MIS.null.psi <- workflowNullPsi(
#'  sequences = MIS.sequences[MIS.sequences$MIS %in% c("MIS-1", "MIS-2"), ],
#'  grouping.column = "MIS",
#'  method = "manhattan",
#'  repetitions = 3,
#'  parallel.execution = FALSE
#'  )
#'
#'MIS.null.psi
#'}
#'
#' @export
workflowNullPsi <- function(sequences = NULL,
                        grouping.column = NULL,
                        time.column = NULL,
                        exclude.columns = NULL,
                        method = "manhattan",
                        diagonal = FALSE,
                        paired.samples = FALSE,
                        same.time = FALSE,
                        ignore.blocks = FALSE,
                        parallel.execution = TRUE,
                        repetitions = 9
                        ){

  #COMPUTING PSI ON OBSERVED SEQUENCES
  ####################################

  psi.real <- workflowPsi(
    sequences = sequences,
    grouping.column = grouping.column,
    time.column = time.column,
    exclude.columns = exclude.columns,
    method = method,
    diagonal = diagonal,
    paired.samples = paired.samples,
    same.time = same.time,
    format = "dataframe",
    parallel.execution = parallel.execution
  )


   #COMPUTING PSI ON PERMUTATED SEQUENCES
   ######################################

    #sequences into matrix
    sequences.matrix <- as.matrix(sequences[, !(colnames(sequences) %in% c(time.column, exclude.columns, grouping.column))])
    sequences.matrix.ncol <- ncol(sequences.matrix)
    sequences.matrix.nrow <- nrow(sequences.matrix)

    #grouping column data
    grouping.column.data <- sequences[, grouping.column]

    #cluster to go through iterations
    if(parallel.execution == TRUE){

      `%dopar%` <- foreach::`%dopar%`
      n.cores <- parallel::detectCores() - 1

      if(.Platform$OS.type == "windows"){
        my.cluster <- parallel::makeCluster(n.cores, type="PSOCK")
      } else {
        my.cluster <- parallel::makeCluster(n.cores, type="FORK")
      }

      doParallel::registerDoParallel(my.cluster)

      #exporting cluster variables
      parallel::clusterExport(cl = my.cluster,
                              varlist = c('sequences',
                                          'sequences.matrix',
                                          'sequences.matrix.ncol',
                                          'sequences.matrix.nrow',
                                          'grouping.column.data',
                                          'grouping.column',
                                          'time.column',
                                          'exclude.columns',
                                          'method',
                                          'diagonal',
                                          'paired.samples',
                                          'same.time',
                                          'workflowPsi'
                                          ),
                              envir = environment()
      )
    } else {
      #replaces dopar (parallel) by do (serial)
      `%dopar%` <- foreach::`%do%`
      on.exit(`%dopar%` <- foreach::`%dopar%`)
    }

    #parallelized loop
    #---------------------------------------
    psi.random <- foreach::foreach(i = 1:repetitions) %dopar% {

      #permutating sequences
      set.seed(i)

      #random matrix of -1, 0, and 1
      decision.matrix <- matrix(sample(-1:1, sequences.matrix.ncol * sequences.matrix.nrow, replace = TRUE), ncol = sequences.matrix.ncol, nrow = sequences.matrix.nrow)

      #first row to zeros to avoid falling out of bounds
      decision.matrix[1,] <- 0

      #last row to zeros to avoid falling out of bounds
      decision.matrix[sequences.matrix.nrow,] <- 0

      #iterates through columns
      for(column in 1:sequences.matrix.ncol){

        #if 0, does nothing
        #if -1, gets previous case
        #if 1, gets next case
        #rewrites decision matrix so we don't need to create another object
        decision.matrix[, column] <- sequences.matrix[1:sequences.matrix.nrow + decision.matrix[, column], column]
      }
      colnames(decision.matrix) <- colnames(sequences.matrix)

      #to sequences
      sequences.randomized <- data.frame(grouping.column = grouping.column.data, decision.matrix, stringsAsFactors = FALSE)
      colnames(sequences.randomized)[1] <- grouping.column

      #computes psi on permutated sequences
      psi.random.i <- workflowPsi(
        sequences = sequences.randomized,
        grouping.column = grouping.column,
        time.column = time.column,
        exclude.columns = exclude.columns,
        method = method,
        diagonal = diagonal,
        paired.samples = paired.samples,
        same.time = same.time,
        format = "list",
        parallel.execution = FALSE
      )

      return(psi.random.i)

    }#end of parallelized loop
    #---------------------------------------

    #stopping cluster
    if(parallel.execution == TRUE){
      parallel::stopCluster(my.cluster)
    } else {
      #creating the correct alias again
      `%dopar%` <- foreach::`%dopar%`
    }

    #lists to dataframe
    psi.random.df <- data.frame(
      matrix(
        unlist(psi.random),
        nrow = nrow(psi.real),
        byrow = F
        ), stringsAsFactors=FALSE
      )
    colnames(psi.random.df) <- paste("r", 1:ncol(psi.random.df), sep="")

    #columns with the compared datasets
    psi.df <- data.frame(psi.real, psi.random.df)

    #compute p on each row
    p.df <- psi.df[, 1:2]
    p.df$p <- NA
    for(i in 1:nrow(p.df)){
      p.df[i, "p"] <- sum(psi.df[i ,3:ncol(psi.df)] <= psi.df[i ,3]) / (ncol(psi.df) - 2)
    }

    #output list
    output.list <- list()
    output.list$psi <- psi.df
    output.list$p <- p.df

    #return
    return(output.list)

} #END OF FUNCTION
