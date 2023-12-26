#' Prepare Sequences for Dissimilarity Analysis
#'
#' @description
#' This function performs the following steps:
#' - Converts a data frame to a list by 'id_column'.
#' - Checks the validity of input sequences.
#' - Orders sequences by time if a time column is PROVIDED
#' - Handles missing values according to the specified action.
#' - Handles zeros by replacing them with a pseudo-zero value, if provided.
#' - Transforms the data if a transformation function is provided.
#'
#'
#' @param sequences (required, list or data frame) A named list with sequences, or a long data frame with a grouping column. Default: NULL.
#' @param id_column (optional, column name) Column name used for splitting a 'sequences' data frame into a list.
#' @param time_column (optional if `paired_samples = FALSE`, and required otherwise, column name) Name of the column representing time, if any. Default: NULL.
#' @param transformation  (optional, function) A function to transform the data within each sequence. A few options are:
#' \itemize{
#'   \item [f_proportion()]: to transform counts into proportions.
#'   \item [f_percentage()]: to transform counts into percentages.
#'   \item [f_hellinger()]: to apply a Hellinger transformation.
#'   \item [f_scale()]: to center and scale the data.
#'   }
#' @param paired_samples (optional, logical) If TRUE, all input sequences are subset to their common times according to the values in the `time_column`.
#' @param pseudo_zero (optional, numeric) Value used to replace zeros in the data. Default: NULL.
#' @param na_action (optional, character string) Action to handle missing values. default: NULL.
#' \itemize{
#'   \item "omit": applies [na.omit()] to each sequence.
#'   \item "to_zero": replaces NA values with zero or `pseudo_zero`, if provided.
#'   \item "impute": not implemented yet.
#' }
#' @return A named list of data frames, matrices, or vectors.
#' @examples
#' data(sequencesMIS)
#' x <- prepare_sequences(
#'   sequences = sequencesMIS,
#'   id_column = "MIS"
#' )
#' @autoglobal
#' @export
prepare_sequences <- function(
    sequences = NULL,
    id_column = NULL,
    time_column = NULL,
    transformation = NULL,
    paired_samples = FALSE,
    pseudo_zero = NULL,
    na_action = "omit"
){

  na_action <- match.arg(
    arg = na_action,
    choices = c(
      "omit",
      "to_zero",
      "impute"#not implemented yet
    )
  )

  if(is.null(sequences)){
    stop("Argument 'sequences' must not be NULL")
  }

  #DATA FRAME TO LIST BY id_column
  if(inherits(x = sequences, what = "data.frame")){

    if(is.null(id_column)){
      stop("Argument 'id_column' cannot be NULL when 'sequences' is a data frame.")
    }

    if(!(id_column %in% colnames(sequences))){
      stop("Argument 'id_column' must be a column name of 'sequences'.")
    }

    sequences <- split(
      x = sequences[, colnames(sequences) != id_column],
      f = sequences[[id_column]]
    )

  }


  #add fake time column
  if(is.null(time_column)){
    time_column <- "row_id"
    sequences <- lapply(
      X = sequences,
      FUN = function(x){
        n <- ifelse(
          test = is.data.frame(x) | is.matrix(x),
          yes = nrow(x),
          no = length(x)
        )
        x[[time_column]] <- 1:n
        return(x)
      }
    )
  }

  #sequences is not a list
  if(inherits(x = sequences, what = "list") == FALSE){
    stop("Argument 'sequences' must be a list.")
  }

  #sequences is too short
  if(length(sequences) < 2){
    stop("Argument 'sequences' must be a list with a least two elements.")
  }

  if(any(is.null(names(sequences)))){
    stop("All elements in the list 'sequences' must be named.")
  }

  #check classes in sequences
  sequences.classes <- lapply(
    X = sequences,
    FUN = class
  ) |>
    unlist()

  sequences.classes <- sequences.classes[!(sequences.classes %in% c("data.frame", "matrix", "numeric"))]

  if(length(sequences.classes) > 0){
    warning("The elements of the list 'sequences' must be of the class 'data.frame', 'matrix', or 'numeric' (vector).")
  }

  #order by time
  ###################################
  sequences.with.time <- lapply(
    X = sequences,
    FUN = function(x) time_column %in% colnames(x)
  ) |>
    unlist() |>
    sum()

  if(sequences.with.time == length(sequences)){

    #arrange by time
    sequences <- lapply(
      X = sequences,
      FUN = function(x){
        x[order(x[[time_column]]), ]
      }
    )

    #paired samples
    #keep common times only
    ####################################
    if(paired_samples == TRUE){

      times <- lapply(
        X = sequences,
        FUN = function(x) unique(x[[time_column]])
      ) |>
        unlist() |>
        table()

      times_common <- as.numeric(names(times)[times == length(sequences)])

      sequences <- lapply(
        X = sequences,
        FUN = function(x) x[x[[time_column]] %in% times_common, ]
      )

    }

  }

  #handle NA
  #####################################
  if(na_action == "omit"){
    sequences <- lapply(
      X = sequences,
      FUN = function(x) na.omit(x)
    )
  }

  if(na_action == "to_zero"){

    if(is.null(pseudo_zero)){
      zero <- 0
    } else {
      zero <- pseudo_zero
    }

    sequences <- lapply(
      X = sequences,
      FUN = function(x) x[is.na(x)] <- zero
    )

  }

  if(na_action == "impute"){
    stop("Imputation of NAs is not implemented yet.")
  }

  #handle zeros
  ##################################
  if(!is.null(pseudo_zero)){

    sequences <- lapply(
      X = sequences,
      FUN = function(x){
        x.time <- x[[time_column]]
        x[[time_column]] <- NULL
        x[x == 0] <- pseudo_zero
        x[[time_column]] <- x.time
        return(x)
      }
    )

  }

  #transform
  #####################################
  if(inherits(x = transformation, what = "function")){

    #apply transformation
    sequences <- lapply(
      X = sequences,
      FUN = function(x){
        x.time <- x[[time_column]]
        x[[time_column]] <- NULL
        x <- transformation(x = x)
        x[[time_column]] <- x.time
        return(x)
      }
    )

  }

  #remove fake time column
  sequences <- lapply(
    X = sequences,
    FUN = function(x){
      x[, colnames(x) != "row_id"]
    }
  )

  #add attribute to ignore time column
  if(!is.null(time_column)){
    sequences <- lapply(
      X = sequences,
      FUN = function(x){
        attr(x, "ignore_columns") <- time_column
        return(x)
      }
    )
  }

  sequences

}
