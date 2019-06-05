#' Prepare sequences for a comparison analysis.
#'
#' @description This function prepares two or more multivariate time-series that are to be compared. It can work on two different scenarios:
#' \itemize{
#' \item \emph{Two dataframes}: The user provides two separated dataframes, each containing a multivariate time series. These time-series can be regular or irregular, aligned or unaligned, but must have at least a few columns with the same names (pay attention to differences in case between column names representing the same entity) and units. This mode uses exclusively the following arguments: \code{sequence.A}, \code{sequence.A.name} (optional), \code{sequence.B}, \code{sequence.B.name} (optional), and \code{merge.model}.
#' \item \emph{One long dataframe}: The user provides a single dataframe, through the \code{sequences} argument, with two or more multivariate time-series identified by a \code{grouping.column}.
#' }
#'
#'
#' @usage prepareSequences(
#' sequence.A = NULL,
#' sequence.A.name = "A",
#' sequence.B = NULL,
#' sequence.B.name = "B",
#' merge.mode = "complete",
#' sequences = NULL,
#' grouping.column = NULL,
#' time.column = NULL,
#' exclude.columns = NULL,
#' if.empty.cases = "zero",
#' transformation = "none",
#' paired.samples = FALSE)
#'
#' @param sequence.A dataframe containing a multivariate time-series.
#' @param sequence.A.name character string with the name of \code{sequence.A}. Will be used as identificator in the \code{id} column of the output dataframe.
#' @param sequence.B dataframe containing a multivariate time-series. Must have overlapping columns with \code{sequence.A} with same column names and units.
#' @param sequence.B.name character string with the name of \code{sequence.B}. Will be used as identificator in the \code{id} column of the output dataframe.
#' @param merge.mode character string, one of: "overlap", "complete" (default option). If "overlap", \code{sequence.A} and \code{sequence.B} are merged by their common columns, and non-common columns are dropped If "complete", columns absent in one dataset but present in the other are added, with values equal to 0. This argument is ignored if \code{sequences} is provided instead of \code{sequence.A} and \code{sequence.B}.
#' @param sequences dataframe with multiple sequences identified by a grouping column.
#' @param grouping.column character string, name of the column in \code{sequences} to be used to identify separates sequences within the file. This argument is ignored if \code{sequence.A} and \code{sequence.B} are provided.
#' @param time.column character string, name of the column with time/depth/rank data. If \code{sequence.A} and \code{sequence.B} are provided, \code{time.column} must have the same name and units in both dataframes.
#' @param exclude.columns character string or character vector with column names in \code{sequences}, or \code{squence.A} and \code{sequence.B}, to be excluded from the transformation.
#' @param if.empty.cases character string with two possible values: "omit", or "zero". If "zero" (default), \code{NA} values are replaced by zeroes. If "omit", rows with \code{NA} data are removed.
#' @param transformation character string. Defines what data transformation is to be applied to the sequences. One of: "none" (default), "percentage", "proportion", "hellinger", and "scale" (the latter centers and scales the data using the \code{\link[base]{scale}} function).
#' @param paired.samples boolean. If \code{TRUE}, the function will test if the datasets have paired samples. This means that each dataset must have the same number of rows/samples, and that, if available, the \code{time.column} must have the same values in every dataset. The default setting is \code{FALSE}.
#' @return A dataframe with the multivariate time series. If \code{squence.A} and \code{sequence.B} are provided, the column identifying the sequences is named "id". If \code{sequences} is provided, the time-series are identified by \code{grouping.column}.
#'
#' @author Blas Benito <blasbenito@gmail.com>
#' @examples
#'
#'#two sequences as inputs
#'data(sequenceA)
#'data(sequenceB)
#'
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
#'
#'#several sequences in a single dataframe
#'data(sequencesMIS)
#'MIS.sequences <- prepareSequences(
#'  sequences = sequencesMIS,
#'  grouping.column = "MIS",
#'  if.empty.cases = "zero",
#'  transformation = "hellinger"
#'  )
#'
#' @export
prepareSequences=function(sequence.A = NULL,
                          sequence.A.name = "A",
                          sequence.B = NULL,
                          sequence.B.name = "B",
                          merge.mode = "complete",
                          sequences = NULL,
                          grouping.column = NULL,
                          time.column = NULL,
                          exclude.columns = NULL,
                          if.empty.cases = "zero",
                          transformation = "none",
                          paired.samples = FALSE){

  #INTERNAL PARAMETERS
  input.mode <- NULL

  #CHECKING transformation
  ##############################################################
  if (!(transformation %in% c("none", "percentage", "proportion", "hellinger", "scale", "PERCENTAGE", "percent", "Percent", "PERCENT", "proportion", "Proportion", "PROPORTION", "hellinger", "Hellinger", "HELLINGER", "scale", "Scale", "SCALE", "center", "Center", "CENTER"))){
    stop("Argument 'transformation' must be one of: 'none', 'percentage', 'proportion', 'hellinger', 'scale'.")
  } else {
    if(transformation %in% c("none", "None", "NONE")){transformation <- "none"}
    if(transformation %in% c("Percentage", "PERCENTAGE", "percent", "Percent", "PERCENT")){transformation <- "percentage"}
    if(transformation %in% c("proportion", "Proportion", "PROPORTION")){transformation <- "proportion"}
    if(transformation %in% c("hellinger", "Hellinger", "HELLINGER")){transformation <- "hellinger"}
    if(transformation %in% c("scale", "Scale", "SCALE", "center", "Center", "CENTER")){transformation <- "scale"}
  }

  #CHECKING merge.mode
  ##############################################################
  if(!(merge.mode %in% c("overlap", "Overlap", "OVERLAP", "complete", "Complete", "COMPLETE", "completed", "Completed", "COMPLETED"))){
    stop("Argument 'merge.mode' must be one of: 'overlap', 'complete'.")
  } else {
    if(merge.mode %in%  c("overlap", "Overlap", "OVERLAP")){merge.mode <- "overlap"}
    if(merge.mode %in%  c("complete", "Complete", "COMPLETE", "completed", "Completed", "COMPLETED")){merge.mode <- "complete"}
  }

  #CHECKING exclude.columns
  ##############################################################
  if(!is.null(exclude.columns) & !is.character(exclude.columns)){
    stop("Argument 'exclude.columns' must be of type character.")
    }


  #DETECTING MODE
  #mode "two.sequences": two sequences are provided through arguments sequence.A and sequence.B
  #mode "many.sequences": more than two sequences are provided through the sequences argument
  ##############################################################
  if(!is.null(sequence.A) & !is.null(sequence.B) & is.null(sequences)){
    if(is.data.frame(sequence.A) & is.data.frame(sequence.B)){
      input.mode <- "two.sequences"
      if(!is.character(sequence.A.name)){warning("Argument 'sequence.A.name' must be character. Setting it to 'A'")}
      if(!is.character(sequence.B.name)){warning("Argument 'sequence.B.name' must be character. Setting it to 'B'")}
    } else {
      stop("sequence.A and sequence.B must be dataframes.")
    }
  }

  #checking sequences
  if(!is.null(sequences)){
    if(is.data.frame(sequences)){
      input.mode <- "many.sequences"
    } else {
      stop("Argument 'sequences' must be a dataframe with multiple sequences identified by different values in a grouping.column.")
    }
  }


  #sequence.A and sequence.B are provided
  #######################################
  if(input.mode == "two.sequences"){

    #CHECKING TIME COLUMN
    if(!(is.null(time.column))){
      if(!(time.column %in% colnames(sequence.A))){
        warning("I couldn't find 'time.column' in 'sequenceA'. The time column will be ignored.")
      }
      if(!(time.column %in% colnames(sequence.B))){
        warning("I couldn't find 'time.column' in 'sequenceB'. The time column will be ignored.")
      }
    }

    #ADDING ID COLUMN TO BOTH SEQUENCES
    sequence.A <- data.frame(id=rep(sequence.A.name, nrow(sequence.A)), sequence.A, stringsAsFactors = FALSE)
    sequence.B <- data.frame(id=rep(sequence.B.name, nrow(sequence.B)), sequence.B, stringsAsFactors = FALSE)
    grouping.column <- "id"

    #MERGING MODE overlap
    if(merge.mode == "overlap"){

      #getting common column names
      common.column.names <- intersect(colnames(sequence.A), colnames(sequence.B))

      #SUBSET BY COMMON COLUMN NAMES
      sequence.A <- sequence.A[, common.column.names]
      sequence.B <- sequence.B[, common.column.names]

    }

    #RBIND both sequences
    sequences <- plyr::rbind.fill(sequence.A, sequence.B)

  }


  #from here, everything goes as is only "sequences" was provided
  #MANY SEQUENCES ARE PROVIDED (only checks on grouping.column are required)
  if(input.mode == "many.sequences"){

    #CHECKING IF grouping.column EXISTS
    if(!(grouping.column %in% colnames(sequences))){
      stop("The argument 'grouping.column' must be a column name of the 'sequences' dataset.")
    }

    #CHECKING IF THERE IS MORE THAN ONE GROUP
    if(length(unique(sequences[, grouping.column])) < 2){
      stop("According to 'grouping.column' there is only one sequence in the 'sequences' dataset. At least two sequences are required!")
    }

  }


  #HANDLING NA
  #############################
  sequences <- handleNA(
    sequence = sequences,
    if.empty.cases = if.empty.cases
    )

  #REMOVING EXCLUDED COLUMNS
  #############################
  if(!is.null(exclude.columns)){
     sequences <- sequences[,!(colnames(sequences) %in% exclude.columns)]
  }

  #REMOVING GROUPS IF THEY HAVE LESS THAN 3 CASES
  #############################
  groups.to.remove <- names(which(table(sequences[, grouping.column]) < 3))
  if(length(groups.to.remove) > 0){
    message(paste("The groups ", paste(groups.to.remove, sep="", collapse=", "), " have less than 3 samples, and will be removed from the data.", sep=""))
    sequences <- sequences[!(sequences[, grouping.column] %in% groups.to.remove), ]
  }


  #APPLYING TRANSFORMATIONS "none", "percentage", "proportion", "hellinger"
  ##############################################################

  #if transformation is not "none"
  if(!(transformation %in% c("none", "None", "NONE", "nope", "Nope", "NOPE", "no", "No", "NO", "hell no!"))){

    #SETTING 0 TO 0.0001 TO AVOID
    ##############################
    sequences[sequences==0] <- 0.0001

    #removing grouping.column (it's non-numeric)
    id.column <- sequences[, grouping.column]
    sequences <- sequences[, !(colnames(sequences) %in% grouping.column)]

    #removing time column
    if(!(is.null(time.column))){
      time.column.data <- sequences[, time.column]
      sequences <- sequences[, !(colnames(sequences) %in% time.column)]
    }


    #COMPUTING PROPORTION
    #############################
    if (transformation == "proportion"){
      sequences <- sweep(sequences, 1, rowSums(sequences), FUN = "/")
    }

    #COMPUTING PERCENTAGE
    ############################
    if (transformation == "percentage"){
      sequences <- sweep(sequences, 1, rowSums(sequences), FUN = "/")*100
    }

    #COMPUTING HELLINGER TRANSFORMATION
    #############################
    if (transformation == "hellinger"){
      sequences <- sqrt(sweep(sequences, 1, rowSums(sequences), FUN = "/"))
    }

    #SCALING
    #############################
    if (transformation == "scale"){
      sequences <- scale(x=sequences, center = TRUE, scale = TRUE)
    }

    #adding the time column
    #removing time column
    if(!(is.null(time.column))){
      sequences <- data.frame(time=time.column.data, sequences, stringsAsFactors = FALSE)
      colnames(sequences)[1] <- time.column
    }

    #adding the grouping.column back
    sequences <- data.frame(id=id.column, sequences, stringsAsFactors = FALSE)

    #change the name if required
    if(grouping.column != "id"){
      colnames(sequences)[1] <- grouping.column
    }

  }



  #checks if paired.samples is TRUE
  if(paired.samples == TRUE){

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

  }

  return(sequences)

}

