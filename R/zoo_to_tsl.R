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

  if(zoo::is.zoo(x) == FALSE){
    stop("Argument 'x' must be a zoo time series.")
  }

  if("name" %in% attributes(x)){
    x_name <- attributes(x)$name
  } else {
    x_name <- ""
  }

  x <- zoo_name_set(
    x = x,
    name = x_name
  )

  tsl <- list(x)

  names(tsl) <- x_name

  tsl

}
