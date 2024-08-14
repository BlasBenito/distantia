#' Converts Single Zoo Object to a Time Series List
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
#' tsl <- utils_zoo_to_tsl(
#'   x = x
#' )
#'
#' class(tsl)
#' class(tsl[[1]])
#' names(tsl)
#' attributes(tsl[[1]])$name
utils_zoo_to_tsl <- function(
    x = NULL
){

  if(zoo::is.zoo(x) == FALSE){
    return(x)
  }

  if(is.null(attributes(x)$name)){
    attr(
      x = x,
      which = "name"
    ) <- "A"
  }

  tsl <- list(
    A = x
  )

  tsl <- tsl_validate(
    tsl = tsl
  )

  tsl

}
