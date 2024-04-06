#' Wraps Zoo Object in Time Series List
#'
#' @description
#' Internal function to wrap a zoo object into a time series list in these contexts where the objective is not to compare two time series.
#'
#' @param x (required, zoo object) zoo time series. Default: NULL
#'
#' @return time series list of length one.
#' @export
#' @autoglobal
#' @examples
zoo_to_tsl <- function(
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

  tsl <- tsl_is_valid(
    tsl = tsl
  )

  tsl

}
