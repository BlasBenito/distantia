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

  #store name
  x_name <- attributes(x)$name

  #create breaks
  x_breaks_factor <- x |>
    stats::time() |>
    cut(breaks = breaks)

  #replace NAs in breaks
  x_breaks_factor[is.na(x_breaks_factor)] <- as.factor(
    tail(
      x = na.omit(x_breaks_factor),
      n = 1
    )
  )

  #aggregate
  y <- stats::aggregate(
    x = x,
    by = as.numeric(x_breaks_factor),
    FUN = f#,
    # ... = ...
  )

  #reset index to break center points
  x_breaks_dates <- x_breaks_factor |>
    unique() |>
    utils_as_time()

  zoo::index(y) <- x_breaks_dates

  #reset name
  attr(
    x = y,
    which = "name"
  ) <- x_name

  y

}
