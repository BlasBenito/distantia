#' Aggregation of Time Series List
#'
#' @description
#'
#' \strong{Objective}
#'
#' Time series aggregation involves grouping observations and summarizing group values with a statistical function. This operation is useful to:
#' \itemize{
#'   \item Decrease (downsampling) the temporal resolution of a time series.
#'   \item Highlight particular states of a time series over time. For example, a daily temperature series can be aggregated by month using `max` to represent the highest temperatures each month.
#'   \item Transform irregular time series into regular.
#' }
#'
#' This function aggregates time series lists \strong{with overlapping times}. Please check such overlap by assessing the columns "begin" and "end " of the data frame resulting from `df <- tsl_time(tsl = tsl)`. Aggregation will be limited by the shortest time series in your time series list. To aggregate non-overlapping time series, please subset the individual components of `tsl` one by one either using [tsl_subset()] or the syntax `tsl = my_tsl[[i]]`.
#'
#' \strong{Methods}
#'
#' Any function returning a single number from a numeric vector can be used to aggregate a time series list. Quoted and unquoted function names can be used. Additional arguments to these functions can be passed via the argument `...`. Typical examples are:
#'
#' \itemize{
#'   \item `mean` or `"mean"`: see [mean()].
#'   \item `median` or `"median"`: see [stats::median()].
#'   \item `quantile` or "quantile": see [stats::quantile()].
#'   \item `min` or `"min"`: see [min()].
#'   \item `max` or `"max"`: see [max()].
#'   \item `sd` or `"sd"`: to compute standard deviation, see [stats::sd()].
#'   \item `var` or `"var"`: to compute the group variance, see [stats::var()].
#'   \item `length` or `"length"`: to compute group length.
#'   \item `sum` or `"sum"`: see [sum()].
#'   \item `f_slope` or `"f_slope"`: to compute the group slope, see [f_slope()].
#' }
#'
#' \strong{Step by Step}
#'
#' The steps to aggregate a time series list are:
#'
#' \enumerate{
#'   \item
#'   \item
#'   \item
#' }
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param new_time (required, numeric, numeric vector, Date vector, POSIXct vector, or keyword) Definition of the aggregation pattern. The available options are:
#' \itemize{
#'   \item numeric vector: only for the "numeric" time class, defines the breakpoints for time series aggregation.
#'   \item "Date" or "POSIXct" vector: as above, but for the time classes "Date" and "POSIXct." In any case, the input vector is coerced to the time class of the `tsl` argument.
#'   \item numeric: defines fixed time intervals in the units of `tsl` for time series aggregation. Used as is when the time class is "numeric", and coerced to integer and interpreted as days for the time classes "Date" and "POSIXct".
#'   \item keyword (see [utils_time_units()]): the common options for the time classes "Date" and "POSIXct" are: "millennia", "centuries", "decades", "years", "quarters", "months", and "weeks". Exclusive keywords for the "POSIXct" time class are: "days", "hours", "minutes", and "seconds". The time class "numeric" accepts keywords coded as scientific numbers, from "1e8" to "1e-8".
#' }
#' @param method (required, function name) Name of a standard or custom function to aggregate numeric vectors. Typical examples are `mean`, `max`,`min`, `median`, and `quantile`. Default: `mean`.
#' @param ... (optional) further arguments for `method`.
#'
#' @return time series list
#' @export
#' @seealso [zoo_aggregate()]
#' @examples
#' #full range of calendar dates
#' tsl <- tsl_simulate(
#'   n = 2,
#'   rows = 1000,
#'   time_range = c(
#'     "0000-01-01",
#'     as.character(Sys.Date())
#'     )
#' )
#'
#' #plot time series
#' if(interactive()){
#'   tsl_plot(tsl)
#' }
#'
#'
#' #find valid aggregation keywords
#' tsl_time <- tsl_time(tsl)
#' tsl_time$keywords
#'
#' #mean value by millennia (extreme case!!!)
#' tsl_millennia <- tsl_aggregate(
#'   tsl = tsl,
#'   new_time = "millennia",
#'   method = mean
#' )
#'
#' if(interactive()){
#'   tsl_plot(tsl_millennia)
#' }
#'
#' #max value by centuries
#' tsl_centuries <- tsl_aggregate(
#'   tsl = tsl,
#'   new_time = "centuries",
#'   method = max
#' )
#'
#' if(interactive()){
#'   tsl_plot(tsl_centuries)
#' }
#'
#' #quantile 0.75 value by centuries
#' tsl_centuries <- tsl_aggregate(
#'   tsl = tsl,
#'   new_time = "centuries",
#'   method = stats::quantile,
#'   probs = 0.75 #argument of stats::quantile()
#' )
#'
#' if(interactive()){
#'   tsl_plot(tsl_centuries)
#' }
tsl_aggregate <- function(
    tsl = NULL,
    new_time = NULL,
    method = mean,
    ...
){

  tsl <- tsl_is_valid(
    tsl = tsl
    )

  old_time <- tsl_time_summary(
    tsl = tsl,
    keywords = "aggregate"
    )

  #new_time is NULL
  if(is.null(new_time)){

    new_time <- tail(
      x = unlist(old_time$keywords),
      n = 1
    )

    message("Aggregating 'x' with keyword '", new_time, "'.")

  }

  new_time <- utils_new_time(
    tsl = tsl,
    new_time = new_time,
    keywords = "aggregate"
  )

  tsl <- lapply(
    X = tsl,
    FUN = function(x, ...){

      x <- zoo_aggregate(
        x = x,
        new_time = new_time,
        method = method,
        ... = ...
      )

    },
    ... = ...
  )

  tsl <- tsl_names_set(
    tsl = tsl
  )

  tsl

}
