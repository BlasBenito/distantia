#' Aggregates Zoo Time Series
#'
#' @param x (required, zoo object) Time series to aggregate. Default: NULL
#' @param new_time (required, numeric, numeric vector, Date vector, POSIXct vector, or keyword) Definition of the aggregation pattern. The available options are:
#' \itemize{
#'   \item numeric vector: only for the "numeric" time class, defines the breakpoints for time series aggregation.
#'   \item "Date" or "POSIXct" vector: as above, but for the time classes "Date" and "POSIXct." In any case, the input vector is coerced to the time class of the `tsl` argument.
#'   \item numeric: defines fixed time intervals in the units of `tsl` for time series aggregation. Used as is when the time class is "numeric", and coerced to integer and interpreted as days for the time classes "Date" and "POSIXct".
#'   \item keyword (see [utils_time_units()]): the common options for the time classes "Date" and "POSIXct" are: "millennia", "centuries", "decades", "years", "quarters", "months", and "weeks". Exclusive keywords for the "POSIXct" time class are: "days", "hours", "minutes", and "seconds". The time class "numeric" accepts keywords coded as scientific numbers, from "1e8" to "1e-8".
#' }
#' @param method (required, function name) Name of a standard or custom function to aggregate numeric vectors. Typical examples are `mean`, `max`,`min`, `median`, and `quantile`. Default: `mean`.
#' @param ... (optional, additional arguments) additional arguments to `method`.
#'
#' @return zoo object
#' @export
#' @autoglobal
#' @examples
#' #full range of calendar dates
#' x <- zoo_simulate(
#'   rows = 1000,
#'   time_range = c(
#'     "0000-01-01",
#'     as.character(Sys.Date())
#'     )
#' )
#'
#' #plot time series
#' if(interactive()){
#'   zoo_plot(x)
#' }
#'
#'
#' #find valid aggregation keywords
#' x_time <- zoo_time(x)
#' x_time$keywords
#'
#' #mean value by millennia (extreme case!!!)
#' x_millennia <- zoo_aggregate(
#'   x = x,
#'   new_time = "millennia",
#'   method = mean
#' )
#'
#' if(interactive()){
#'   zoo_plot(x_millennia)
#' }
#'
#' #max value by centuries
#' x_centuries <- zoo_aggregate(
#'   x = x,
#'   new_time = "centuries",
#'   method = max
#' )
#'
#' if(interactive()){
#'   zoo_plot(x_centuries)
#' }
#'
#' #quantile 0.75 value by centuries
#' x_centuries <- zoo_aggregate(
#'   x = x,
#'   new_time = "centuries",
#'   method = stats::quantile,
#'   probs = 0.75 #argument of stats::quantile()
#' )
#'
#' if(interactive()){
#'   zoo_plot(x_centuries)
#' }
zoo_aggregate <- function(
    x = NULL,
    new_time = NULL,
    method = mean,
    ...
){

  if(zoo::is.zoo(x) == FALSE){
    stop("Argument 'x' must be a zoo object.")
  }

  #handle keywords
  x_time <- zoo_time(x = x)
  if(any(new_time %in% unlist(x_time$keywords))){
    new_time <- utils_new_time(
      tsl = utils_zoo_to_tsl(x = x),
      new_time = new_time
    )
  } else {
    if(length(new_time) < 2){
      stop("Argument 'new_time' must be a vector of length 2 or higher.")
    }
  }

  if(is.function(method) == FALSE){
    stop("Argument 'method' must be a function name. A few valid options are 'mean', 'median', 'max', 'min', and 'sd', among others.")
  }

  x_time <- stats::time(x)

  x_names <- colnames(x)

  x_time_class <- zoo_time(
    x = x
  )$class

  x_new_time <- cut(
    x = x_time,
    breaks = new_time,
    include.lowest = TRUE,
    right = TRUE
  ) |>
    as.numeric()

  #aggregate
  y <- stats::aggregate(
    x = x,
    by = x_new_time,
    FUN = method,
    ... = ...
  )

  #reset index

  #transform y_time as required
  if(x_time_class == "numeric"){

    y_time <- stats::aggregate(
      x = zoo::as.zoo(x_time),
      by = x_new_time,
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
      by = list(x_new_time),
      FUN = median
    )$x

  }

  zoo::index(y) <- y_time

  colnames(y) <- colnames(x)

  #reset name
  attr(
    x = y,
    which = "name"
  ) <- attributes(x)$name

  y

}
