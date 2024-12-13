#' Aggregate Cases in Zoo Time Series
#'
#' @param x (required, zoo object) Time series to aggregate. Default: NULL
#' @param new_time (optional, zoo object, keyword, or time vector) New time to aggregate `x` to. The available options are:
#' \itemize{
#'   \item NULL: the highest resolution keyword returned by `zoo_time(x)$keywords` is used to generate a new time vector to aggregate `x`.
#'   \item zoo object: the index of the given zoo object is used as template to aggregate `x`.
#'   \item time vector: a vector with new times to resample `x` to. If time in `x` is of class "numeric", this vector must be numeric as well. Otherwise, vectors of classes "Date" and "POSIXct" can be used indistinctly.
#'   \item keyword: a valid keyword returned by `zoo_time(x)$keywords`, used to generate a time vector with the relevant units.
#'   \item numeric of length 1: interpreted as new time interval, in the highest resolution units returned by `zoo_time(x)$units`.
#' }
#' @param f (optional, quoted or unquoted function name) Name of a standard or custom function to aggregate numeric vectors. Typical examples are `mean`, `max`,`min`, `median`, and `quantile`. Default: `mean`.
#' @param ... (optional, additional arguments) additional arguments to `f`.
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
#'   f = mean
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
#'   f = max
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
#'   f = stats::quantile,
#'   probs = 0.75 #argument of stats::quantile()
#' )
#'
#' if(interactive()){
#'   zoo_plot(x_centuries)
#' }
#' @family zoo_functions
zoo_aggregate <- function(
    x = NULL,
    new_time = NULL,
    f = mean,
    ...
){

  if(zoo::is.zoo(x) == FALSE){
    stop("distantia::zoo_aggregate(): argument 'x' must be a zoo object.", call. = FALSE)
  }

  f <- tryCatch(
    match.fun(f),
    error = function(e){
      stop("distantia::zoo_aggregate(): Argument 'f' must be a function name. Examples of valid options are: 'mean', 'median', 'max', 'min', and 'sd'.", call. = FALSE)
    }
  )

  #new_time from keyword
  if(is.null(new_time)){

    old_time <- zoo_time(
      x = x,
      keywords = "aggregate"
    )

    new_time <- utils::tail(
      x = unlist(old_time$keywords),
      n = 1
      )

    message("distantia::zoo_aggregate(): aggregating 'x' with keyword '", new_time, "'.")

  }

  #process new_time
  new_time <- utils_new_time(
    tsl = zoo_to_tsl(x = x),
    new_time = new_time,
    keywords = "aggregate"
  )

  #new_time to aggregation intervals
  new_time_groups <- cut(
    x = zoo::index(x),
    breaks = new_time,
    include.lowest = TRUE,
    right = TRUE
  ) |>
    as.numeric()

  #aggregate x as y
  y <- stats::aggregate(
    x = x,
    by = new_time_groups,
    FUN = f,
    ... = ...
  )

  colnames(y) <- colnames(x)

  y <- zoo::zoo(
    x = y,
    order.by = new_time
  )

  #reset name
  zoo_name_set(
    x = y,
    name = attributes(x)$name
  )

}
