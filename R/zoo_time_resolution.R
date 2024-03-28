#' Time Resolution of a Zoo Time Series
#'
#' @param x (required, zoo object) time series with an index of the classes "Date". "POSIXct". or "numeric".
#'
#' @return List
#' @export
#' @autoglobal
#' @examples
zoo_time_resolution <- function(x){

  if(zoo::is.zoo(x) == FALSE){
    stop("Argument 'x' must be a zoo time series.")
  }

  resolution <- mean(diff(stats::time(x)))
  unit <- attributes(resolution)$units

  list(
    resolution = as.numeric(resolution),
    units = ifelse(
      test = is.null(unit),
      yes = "numeric",
      no = unit
    )
  )


}
