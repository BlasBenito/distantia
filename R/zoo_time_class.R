#' Time Class of a Zoo Time Series
#'
#' @param x (required, zoo object) time series with an index of the classes "Date". "POSIXct". or "numeric".
#'
#' @return Class
#' @export
#' @autoglobal
#' @examples
zoo_time_class <- function(x){

  if(zoo::is.zoo(x) == FALSE){
    stop("Argument 'x' must be a zoo time series.")
  }

  x_class <- class(stats::time(x))

  if("POSIXct" %in% x_class){
    x_class <- "POSIXct"
  }

  x_class

}
