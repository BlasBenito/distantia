#' Prepare List of Data Frames for Dissimilarity Analysis
#'
#'
#' @param x (required, list of data frames) A named list with data frames. Default: NULL.
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
#'   x = sequencesMIS,
#'   id_column = "MIS"
#' )
#' @autoglobal
#' @export
prepare_df_list <- function(
    x = NULL,
    time_column = NULL,
    transformation = NULL,
    paired_samples = FALSE,
    pseudo_zero = NULL,
    na_action = "omit"
){

  # + keep numeric columns
  ###################################################################
  x <- lapply(
    X = x,
    FUN = function(x){
      x <- x[, sapply(x, is.numeric)]
    }
  )

  # + apply na action
  ###################
  x <- handle_na(
    x = x,
    pseudo_zero = pseudo_zero,
    na_action = na_action
  )

  #handle time column
  ####################
  # + if time column
  #   + if not numeric: ERROR
  #   + else if arrange by time column
  # + if no time column
  #   + if paired samples: ERROR
  #   + add row_id
  #   + set time_column to row_id
  # + if paired samples, keep paired samples only
  # + add time column to attribute "time" and remove from df
  x <- handle_time_column(
    x = x,
    time_column = time_column,
    paired_samples = paired_samples
  )


  # + handle zeros
  ################
  x <- handle_zeros(
    x = x,
    pseudo_zero = pseudo_zero
  )

  # + transform
  ##############
  x <- handle_transformation (
    x = x,
    transformation = transformation
  )

  # + convert to matrix
  ###################
  x <- lapply(
    X = x,
    FUN = function(x){
      x.time <- attributes(x)$time
      x <- as.matrix(x)
      attr(x = x, which = "time") <- x.time
      return(x)
    }
  )

  # + add attribute validated
  x <- lapply(
    X = x,
    FUN = function(x){
      attr(x, "validated") <- TRUE
      return(x)
    }
  )

  x

}



#' Handles Time Column in List of Data Frames
#'
#' @param x (required, named list of data frames). List with named data frames. Default: NULL.
#' @param time_column (optional if `paired_samples = FALSE`, and required otherwise, column name) Name of numeric column representing time. Default: NULL.
#' @param paired_samples (optional, logical) If TRUE, all input sequences are subset to their common times according to the values in the `time_column`. Default: FALSE.
#'
#' @return List of data frames
#' @export
#' @autoglobal
handle_time_column <- function(
    x = NULL,
    time_column = NULL,
    paired_samples = NULL
){

  #if no time column, add "row_id"
  if(is.null(time_column)){

    #error if both time_column and paired samples are NULL
    if(paired_samples == TRUE){
      stop("Argument 'time_column' cannot be NULL when 'paired_samples' is TRUE'.")
    }

    time_column <- "row_id"

    x <- lapply(
      X = x,
      FUN = function(x){
        x[[time_column]] <- seq_len(nrow(x))
        return(x)
      }
    )

  } else {

    #check that the time column is numeric
    x.time.numeric <- lapply(
      X = x,
      FUN = function(x) is.numeric(x[[time_column]])
    ) |>
      unlist()

    #names of elements with no time
    x.time.numeric <- names(x.time.numeric[!x.time.numeric])

    #ERROR if time missing from any element
    if(length(x.time.numeric) > 0){

      stop("The time column '", time_column, "' is not numeric in these elements of 'x': ", paste(x.time.numeric, collapse = ", "))

    }


    #check that time column is in all elements
    x.no.time <- lapply(
      X = x,
      FUN = function(x){
        time_column %in% colnames(x)
      }
    ) |>
      unlist()

    #names of elements with no time
    x.no.time <- names(x.no.time[!x.no.time])

    #ERROR if time missing from any element
    if(length(x.no.time) > 0){

      stop("These elements of 'x' do not have the time column '", time_column, "': ", paste(x.no.time, collapse = ", "))

    }

    #arrange all elements by time
    x <- lapply(
      X = x,
      FUN = function(x){
        x[order(x[[time_column]]), ]
      }
    )

    #apply paired samples
    if(paired_samples == TRUE){

      times <- lapply(
        X = x,
        FUN = function(x) x[[time_column]]
      ) |>
        unlist() |>
        table() |>
        as.data.frame(stringsAsFactors = FALSE)

      time_common <- times[times$Freq == length(x), "Var1"]

      times_common <- as.numeric(names(times)[times == length(x)])

      x <- lapply(
        X = x,
        FUN = function(x) x[x[[time_column]] %in% times_common, ]
      )

    }

  }

  #set time attribute
  #remove the time column
  x <- lapply(
    X = x,
    FUN = function(x){
      attr(x = x, which = "time") <- x[[time_column]]
      x[[time_column]] <- NULL
      return(x)
    }
  )

  x

}


#' Handles NA in List of Data Frames
#'
#' @param x (required, list of data frames) A named list with data frames. Default: NULL.
#' @param pseudo_zero (optional, numeric) Value used to replace zeros in the data. Default: NULL.
#' @param na_action (optional, character string) Action to handle missing values. default: NULL.
#' \itemize{
#'   \item "omit": applies [na.omit()] to each sequence.
#'   \item "to_zero": replaces NA values with zero or `pseudo_zero`, if provided.
#'   \item "impute": not implemented yet.
#' }
#'
#' @return Named list of data frames
#' @export
#' @autoglobal
handle_na <- function(
    x = NULL,
    pseudo_zero = NULL,
    na_action = "omit"
    ){

  #check NA action argument
  na_action <- match.arg(
    arg = na_action,
    choices = c(
      "omit",
      "to_zero",
      "impute"#not implemented yet
    )
  )

  # + apply na action
  ###############################################################
  if(na_action == "omit"){
    x <- lapply(
      X = x,
      FUN = function(x) na.omit(x)
    )
  }

  if(na_action == "to_zero"){

    if(is.null(pseudo_zero)){
      zero <- 0
    } else {
      zero <- pseudo_zero
    }

    x <- lapply(
      X = x,
      FUN = function(x) x[is.na(x)] <- zero
    )

  }

  if(na_action == "impute"){
    stop("Imputation of NAs is not implemented yet.")
  }

  x

}


#' Handles Zeros in List of Data Frames
#'
#' @param x (required, list of data frames) A named list with data frames. Default: NULL.
#' @param pseudo_zero (optional, numeric) Value used to replace zeros in the data. Default: NULL.
#'
#' @return Named list of data frames
#' @export
#' @autoglobal
handle_zeros <- function(
    x = NULL,
    pseudo_zero = NULL
){

  if(is.null(pseudo_zero)){
    return(x)
  }

  if(!is.numeric(pseudo_zero)){
    stop("Argument 'pseudo_zero' must be numeric.")
  }

  x <- lapply(
    X = x,
    FUN = function(x){
      x[x == 0] <- pseudo_zero
      return(x)
    }
  )


  X

}

#' Handles Transformation in List of Data Frames
#'
#' @param x (required, list of data frames) A named list with data frames. Default: NULL.
#' @param transformation  (optional, function) A function to transform the data within each sequence. A few options are:
#' \itemize{
#'   \item [f_proportion()]: to transform counts into proportions.
#'   \item [f_percentage()]: to transform counts into percentages.
#'   \item [f_hellinger()]: to apply a Hellinger transformation.
#'   \item [f_scale()]: to center and scale the data.
#'   }
#'
#' @return Named list of data frames
#' @export
#' @autoglobal
handle_transformation <- function(
    x = NULL,
    transformation = NULL
){

  if(is.null(transformation) == TRUE){
    return(x)
  }

  if(inherits(x = transformation, what = "function") == FALSE){
    stop("Argument 'transformation' must be a function.")
  }

  x <- lapply(
    X = x,
    FUN = function(x){
      x.time <- attributes(x)$time
      x <- transformation(x = x)
      attr(x = x, which = "time") <- x.time
      return(x)
    }
  )

  x

}
