

#' Handles Zeros in List of Data Frames
#'
#' @param x (required, list of data frames) A named list with data frames. Default: NULL.
#' @param pseudo_zero (optional, numeric) Value used to replace zeros in the data. Default: NULL.
#'
#' @return Named list of data frames
#' @export
#' @autoglobal
prepare_zeros <- function(
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
