#' Handles NA in List of Data Frames
#'
#' @param x (required, list of data frames) A named list with data frames. Default: NULL.
#' @param pseudo_zero (optional, numeric) Value used to replace zeros in the data. Default: NULL.
#' @param na_action (optional, character string) Action to handle missing values. default: NULL.
#' \itemize{
#'   \item NULL: returns the input without changes.
#'   \item "omit": applies [na.omit()] to each sequence.
#'   \item "to_zero": replaces NA values with zero or `pseudo_zero`, if provided.
#'   \item "impute": not implemented yet.
#' }
#'
#' @return Named list of data frames
#' @export
#' @autoglobal
prepare_na <- function(
    x = NULL,
    pseudo_zero = NULL,
    na_action = NULL
){

  if(is.null(na_action)){
    return(x)
  }

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
