#' Convert Individual Zoo Objects to Time Series List
#'
#' @description
#' Internal function to wrap a zoo object into a time series list.
#'
#' @param x (required, zoo object) Time series. Default: NULL
#'
#' @return time series list of length one.
#' @export
#' @autoglobal
#' @examples
#' #create zoo object
#' x <- zoo_simulate()
#' class(x)
#'
#' #to time series list
#' tsl <- zoo_to_tsl(
#'   x = x
#' )
#'
#' class(tsl)
#' class(tsl[[1]])
#' names(tsl)
#' attributes(tsl[[1]])$name
#' @family data_preparation
zoo_to_tsl <- function(
    x = NULL
){

  if(!zoo::is.zoo(x)){
    stop("distantia::zoo_to_tsl(): argument 'x' must be a zoo time series.", call. = FALSE)
  }

  x_name <- attributes(x)$name
  if(is.null(x_name)){
    x_name <- ""
  }

  x <- zoo_name_set(
    x = x,
    name = x_name
  )

  out_tsl <- list(x)

  names(out_tsl) <- x_name

  out_tsl

}
