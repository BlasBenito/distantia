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

  x_time <- stats::time(x)

  x_time_class <- zoo_time(
    x = x
  )$class

  x_breaks <- cut(
    x = x_time,
    breaks = breaks,
    include.lowest = TRUE,
    right = TRUE
  ) |>
    as.numeric()

  #aggregate
  y <- stats::aggregate(
    x = x,
    by = x_breaks,
    FUN = f,
    ... = ...
  )

  #reset index

  #transform y_time as required
  if(x_time_class == "numeric"){

    y_time <- stats::aggregate(
      x = zoo::as.zoo(x_time),
      by = x_breaks,
      FUN = median
    ) |>
      as.numeric()

    x_time_digits <- utils_digits(
      x = diff(range(x_time))
    )

    y_time <- round(
      x = y_time,
      digits = x_time_digits
    )

  }

  if(x_time_class %in% c("Date", "POSIXct")){

    y_time <- stats::aggregate(
      x = x_time,
      by = list(x_breaks),
      FUN = median
    )$x

  }

  zoo::index(y) <- y_time

  #reset name
  attr(
    x = y,
    which = "name"
  ) <- attributes(x)$name

  y

}
