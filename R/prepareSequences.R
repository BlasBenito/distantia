#' Prepare input sequences.
#'
#' @description Takes two dataframes containing multivariate time-series (\code{sequence.A} and \code{sequence.B}), checks the integrity of both datasets, and tries to adapt \code{sequence.B} to the characteristics of\code{sequence.A} by matching number of columns, column names, and missing data. Missing data can be handled in two ways: 1) setting NA to zero; 2) deleting rows with NA or empty cases.
#'
#' @usage
#'
#' @param sequence.A dataframe containing a multivariate time-series.
#' @param sequence.A.name character string with the name of the sequence.
#' @param sequence.B dataframe containing a multivariate time-series. Must have same column names and units as \code{sequence.A}.
#' @param sequence.B.name character string with the name of the sequence.
#' @param sequences dataframe with multiple sequences identified by a grouping column.
#' @param grouping.column character string, name of the column in \code{sequences} to be used to identify separates sequences within the file.
#' @param exclude.columns character string or character vector with column names in \code{sequences}, or \code{squence.A} and \code{sequence.B} to be excluded from the analysis.
#' @param if.empty.cases character string with two possible values: "omit", or "zero". If "zero" (default), \code{NA} values are replaced by zeroes. If "omit", rows with \code{NA} data are removed.
#' @param transformation character string. Defines what data transformations to apply to the sequences. One of: "none" (default), "percentage", "proportion", and "hellinger".
#' @param silent boolean, set to TRUE to hide all messages, and set to FALSE otherwise.
#' @return A list with four slots:
#' \itemize{
#' \item \emph{taxa} Common column names of the sequences, listing the taxa included in them.
#' \item \emph{metadata} A dataframe with details about the processing of the sequences.
#' \item \emph{sequence.A} Dataframe, a processed pollen sequence.
#' \item \emph{sequence.B} Dataframe, a processed pollen sequence.
#' }
#' @author Blas Benito <blasbenito@gmail.com>
#' @examples
#' data(InputDataExample)
#' @export
prepareSequences=function(sequence.A = NULL,
                          sequence.A.name = "A",
                          sequence.B = NULL,
                          sequence.B.name = "B",
                          sequences = NULL,
                          grouping.column = NULL,
                          exclude.columns = NULL,
                          if.empty.cases = "zero",
                          transformation = "none",
                          silent = FALSE){

  #INTERNAL PARAMETERS
  input.mode <- NULL


  #CHECKING if.empty.cases
  ##############################################################
  if (!(if.empty.cases) %in% c("zero", "ZERO", "Zero", "omit", "Omit", "OMIT")){
    stop("if.empty.cases' must be one of: 'zero', 'omit'.")
    }


  #CHECKING transformation
  ##############################################################
  if (!(transformation %in% c("none", "None", "NONE", "percentage", "Percentage", "PERCENTAGE", "percent", "Percent", "PERCENT", "proportion", "Proportion", "PROPORTION", "hellinger", "Hellinger", "HELLINGER"))){
    stop("Argument 'transformation' must be one of: 'none', 'percentage', 'proportion', 'hellinger'.")
  }

  #SILENT?
  ##############################################################
  if (is.null(silent)){silent=FALSE}


  #DETECTING MODE
  #mode "two.sequences": two sequences are provided through arguments sequence.A and sequence.B
  #mode "many.sequences": more than two sequences are provided through the sequences argument
  ##############################################################
  if(!is.null(sequence.A) & !is.null(sequence.B) & is.null(sequences)){
    if(is.data.frame(sequence.A) & is.data.frame(sequence.B)){
      input.mode <- "two.sequences"
    } else {
      stop("sequence.A and sequence.B must be dataframes.")
    }
  }

  if(!is.null(sequences)){
    if(is.data.frame(sequences)){
      input.mode <- "many.sequences"
    } else {
      stop("sequences must be a dataframe with multiple sequences identified by different values in a grouping.column.")
    }
  }


  if(input.mode == "many.sequences"){

  }

  if(input.mode == "two.sequences"){

  }

  #TESTING DATASETS AND SUBSETTING COLUMNS
  ##############################################################
  ##############################################################
  if (silent == FALSE){cat("Checking input datasets...", sep="\n")}

  #OVERLAP OF COMMON COLUMN NAMES
  common.column.names=intersect(colnames(sequence.A), colnames(sequence.B))


  #ORIGINAL DIMENSIONS OF THE DATAFRAMES
  sequence.A[is.na(sequence.A == "")]=NA
  sequence.B[is.na(sequence.B == "")]=NA
  original.na.sequence.A=sum(is.na(sequence.A))
  original.na.sequence.B <- sum(is.na(sequence.B))
  original.nrow.sequence.A <- nrow(sequence.A)
  original.nrow.sequence.B <- nrow(sequence.B)
  original.ncol.sequence.A <- ncol(sequence.A)
  original.ncol.sequence.B <- ncol(sequence.B)


  #WHAT COLUMNS WERE REMOVED FROM THE TARGET DATASET?
  removed.column.names.sequence.A <- setdiff(colnames(sequence.A), common.column.names)
  removed.column.names.sequence.B <- setdiff(colnames(sequence.B), common.column.names)


  if (length(removed.column.names.sequence.A) == 0){
    removed.column.names.sequence.A <- ""
  }

  if (length(removed.column.names.sequence.B) == 0){
    removed.column.names.sequence.B <- ""
  }


  #SUBSET BY COMMON COLUMN NAMES
  sequence.A <- sequence.A[, common.column.names]
  sequence.B <- sequence.B[, common.column.names]


  #messages
  if (silent  ==  FALSE){
    if (length(removed.column.names.sequence.A) == 1){
      message(paste("WARNING: the column", removed.column.names.sequence.A, "was removed from the sequence A.", sep=" "))
    }

    if (length(removed.column.names.sequence.A)>1){
      message(paste("WARNING: the columns", removed.column.names.sequence.A, "were removed from the sequence A.", sep=" "))
    }

    if (length(removed.column.names.sequence.B) == 1){
      message(paste("WARNING: the column", removed.column.names.sequence.B, "was removed from the sequence B.", sep=" "))
    }

    if (length(removed.column.names.sequence.B)>1){
      message(paste("WARNING: the columns", removed.column.names.sequence.B, "were removed from the sequence B.", sep=" "))
    }
  }


  #HANDLING NA DATA
  ##############################################################
  ##############################################################
  sequence.A <- HandleNACases(sequence = sequence.A, sequence.name = sequence.A.name, if.empty.cases = if.empty.cases, silent = silent)
  sequence.B <- HandleNACases(sequence = sequence.B, sequence.name = sequence.B.name, if.empty.cases = if.empty.cases, silent = silent)

  #counting NAs again for the metadata table
  final.na.sequence.A <- sum(is.na(sequence.A))
  final.na.sequence.B <- sum(is.na(sequence.B))

  #APPLYING TRANSFORMATIONS "none", "percentage", "proportion", "hellinger"
  ##############################################################
  ##############################################################

  #COMPUTING PROPORTION
  #############################
  if (transformation %in% c("proportion", "prop", "Proportion", "Prop", "PROPORTION", "PROP")){

    sequence.A <- sweep(sequence.A, 1, rowSums(sequence.A), FUN = "/")
    sequence.B <- sweep(sequence.B, 1, rowSums(sequence.B), FUN = "/")

  }

  #COMPUTING PERCENTAGE
  ############################
  if (transformation %in% c("percentage", "percent", "Percentage", "Percent", "PERCENTAGE", "PERCENT")){

    sequence.A <- sweep(sequence.A, 1, rowSums(sequence.A), FUN = "/")*100
    sequence.B <- sweep(sequence.B, 1, rowSums(sequence.B), FUN = "/")*100

  }

  #COMPUTING HELLINGER TRANSFORMATION
  #############################
  if (transformation %in% c("hellinger", "Hellinger", "HELLINGER", "Hell", "hell", "HELL")){

    sequence.A <- sqrt(sweep(sequence.A, 1, rowSums(sequence.A), FUN = "/"))
    sequence.B <- sqrt(sweep(sequence.B, 1, rowSums(sequence.B), FUN = "/"))

  }


  #WRAPPING UP RESULT
  ###################
  #CREATING ROWNAMES FOR DATAFRAMES (to be used for the matrixes also)
  rownames.sequence.A <- 1:nrow(sequence.A)
  rownames.sequence.B <- 1:nrow(sequence.B)

  #COERCING INTO MATRIX
  sequence.A <- as.matrix(sequence.A)
  sequence.B <- as.matrix(sequence.B)

  #NAMES TO COLS AND ROWS
  colnames(sequence.A) <- common.column.names
  colnames(sequence.B) <- common.column.names
  rownames(sequence.A) <- rownames.sequence.A
  rownames(sequence.B) <- rownames.sequence.B


  #PREPARING RESULTS
  ##################
  #filling metadata
  metadata <- data.frame(detail = character(10),sequence.A = character(10), sequence.B = character(10), stringsAsFactors = FALSE)
  metadata[1,1:3] <- c("name", sequence.A.name, sequence.B.name)
  metadata[2,1:3] <- c("initial.rows", original.nrow.sequence.A, original.nrow.sequence.B)
  metadata[3,1:3] <- c("final.rows", nrow(sequence.A), nrow(sequence.B))
  metadata[4,1:3] <- c("initial.columns", original.ncol.sequence.A, original.ncol.sequence.B)
  metadata[5,1:3] <- c("final.columns", ncol(sequence.A), ncol(sequence.B))
  metadata[6,1:3] <- c("excluded.columns", removed.column.names.sequence.A, removed.column.names.sequence.B)
  metadata[7,1:3] <- c("initial.empty.cases", original.na.sequence.A, original.na.sequence.B)
  metadata[8,1:3] <- c("if.empty.cases", if.empty.cases, if.empty.cases)
  metadata[9,1:3] <- c("final.empty.cases", final.na.sequence.A, final.na.sequence.B)
  metadata[10,1:3] <- c("transformation", transformation, transformation)

  #list
  result <- list()
  result[[1]] <- common.column.names
  result[[2]] <- metadata
  result[[3]] <- sequence.A
  result[[4]] <- sequence.B
  result[[5]] <- NA
  result[[6]] <- NA
  result[[7]] <- NA
  result[[8]] <- NA
  result[[9]] <- NA

  names(result) <- c("taxa", "metadata", "sequence.A", "sequence.B", "distance.matrix", "sum.distances.sequence.A", "sum.distances.sequence.B", "psi", "p.value")

  return(result)

}

