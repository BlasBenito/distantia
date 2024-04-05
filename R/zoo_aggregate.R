#' Aggregates Zoo Time Series
#'
#' @param x (required, zoo object) Time series to aggregate. Default: NULL
#' @param breaks (required, vector) Vector to define time breaks for aggregation. Must be in the same time units as `zoo::index(x)`.
#' @param stat (required, function) name without quotes and parenthesis of a standard function to smooth a time series. Typical examples are `mean` (default), `max`,`min`, `median`, and `sd`. Default: `mean`.
#'
#' @return time series list
#' @export
#' @autoglobal
#' @examples
zoo_aggregate <- function(
    x = NULL,
    breaks = NULL,
    f = mean,
    ...
){

  if(zoo::is.zoo(x) == FALSE){
    stop("Argument 'x' must be a zoo object.")
  }

  if(length(breaks) < 2){
    stop("Argument 'breaks' must be a vector of length 2 or higher.")
  }

  if(is.function(f) == FALSE){
    stop("Argument 'f' must be a function name. A few valid options are 'mean', 'median', 'max', 'min', and 'sd', among others.")
  }

  x_name <- attributes(x)$name

  x_time <- stats::time(x)

  x_class <- zoo_time(
    x = x
  )$class

  x_breaks <- cut(
    x = x_time,
    breaks = breaks
    )

  #replace NAs in breaks
  # x_breaks[is.na(x_breaks)] <- as.factor(
  #   tail(
  #     x = na.omit(x_breaks),
  #     n = 1
  #   )
  # )

  #aggregate
  y <- stats::aggregate(
    x = x,
    by = as.numeric(x_breaks),
    FUN = f,
    ... = ...
  )

  #reset index
  x_breaks <- unique(x_breaks)
  if(x_class == "numeric"){
    y_index <- as.numeric(x_breaks)
  }
  if(x_class == "Date"){
    y_index <- as.Date(x_breaks)
  }
  if(x_class == "POSIXct"){
    y_index <- as.POSIXct(x_breaks)
  }

  zoo::index(y) <- y_index

  #reset name
  attr(
    x = y,
    which = "name"
  ) <- x_name

  y

}
