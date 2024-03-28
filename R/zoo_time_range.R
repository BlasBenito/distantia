#' Time Range of a Zoo Time Series
#'
#' @param x (required, zoo object) time series with an index of the classes "Date". "POSIXct". or "numeric".
#'
#' @return Range
#' @export
#' @autoglobal
#' @examples
zoo_time_range <- function(x){

  if(zoo::is.zoo(x) == FALSE){
    stop("Argument 'x' must be a zoo time series.")
  }

  range(stats::time(x))

}
