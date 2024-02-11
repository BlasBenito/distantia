#' Handles NA in List of Data Frames
#'
#' @param x (required, list of data frames) A named list with data frames. Default: NULL.
#' @param pseudo_zero (optional, numeric) Value used to replace zeros in the data. Default: NULL.
#' @param na_action (optional, character string) Action to handle missing values. Accepted values are:
#' \itemize{
#'   \item NULL: returns the input without changes.
#'   \item "omit": applies [na.omit()] to each sequence.
#'   \item "zero": replaces NA values with zero or `pseudo_zero`, if provided.
#'   \item "impute": NA cases are imputed via [zoo::na.spline()]
#' }. Default: NULL
#'
#' @return Named list of data frames
#' @export
#' @autoglobal
prepare_na <- function(
    x = NULL,
    pseudo_zero = NULL,
    na_action = NULL
){

  if(is.null(na_action) && is.null(pseudo_zero)){
    return(x)
  }

  #check NA action argument
  na_action <- match.arg(
    arg = na_action,
    choices = c(
      "omit",
      "zero",
      "impute"#not implemented yet
    )
  )


  if(is.numeric(pseudo_zero)){
    x[x == 0] <- pseudo_zero
  }

  if(na_action == "omit"){
    x <- na.omit(x)
  }

  if(na_action == "to_zero"){

    if(is.null(pseudo_zero)){
      zero <- 0
    } else {
      zero <- pseudo_zero
    }

    x[is.na(x)] <- zero

  }

  if(na_action == "impute"){
    x <- zoo::na.spline(
      object = x
    )
  }

  x

}
