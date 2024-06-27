#' Time Features of a Zoo Object
#'
#' @param x (required, zoo object) Zoo time series to analyze. Default: NULL.
#'
#' @return Data frame with the following columns:
#' \itemize{
#'   \item name: value of attributes(x)$name.
#'   \item n: number of observations.
#'   \item class: class of the time units (Date, POSIXct, or numeric).
#'   \item begin: begin time of the time series.
#'   \item end: end time of the time series.
#'   \item length: length in "units" of the time series.
#'   \item resolution: average time distance (in "units") between consecutive observations.
#'   \item keywords: vector of valid keywords for data aggregation (see [zoo_aggregate()]).
#' }
#' @export
#' @autoglobal
#' @examples
#' #class Date
#' ##################################
#' x <- zoo_simulate(
#'   rows = 1000,
#'   time_range = c(
#'     "2010-01-01",
#'     "2020-01-01"
#'     )
#' )
#'
#' x_time <- zoo_time(x)
#' x_time
#'
#' #aggregation keywords
#' x_time$keywords
#'
#' #class POSIXct, lower resolution
#' ##################################
#' y <- zoo_simulate(
#'   rows = 100,
#'   time_range = c(
#'     "2010-01-01 15:30:45 UTC",
#'     "2020-01-01 17:22:30 UTC"
#'   )
#' )
#'
#' y_time <- zoo_time(y)
#' y_time
#'
#' #aggregation keywords
#' #notice changes due to lower resolution
#' y_time$keywords
#'
#'
#' #class numeric
#' ##################################
#' z <- zoo_simulate(
#'   rows = 100,
#'   time_range = c(
#'     -10000,
#'     2024
#'   )
#' )
#'
#' z_time <- zoo_time(z)
#' z_time
#'
#' #aggregation keywords
#' #numeric class uses characters with scientific notation
#' z_time$keywords
zoo_time <- function(
    x = NULL
){

  if(zoo::is.zoo(x) == FALSE){
    stop("Argument 'x' must be a zoo time series.")
  }

  x_name <- attributes(x)$name
  if(is.null(x_name)){
    x_name <- ""
  }

  x_time <- stats::time(x)

  #class
  x_class <- class(x_time)
  if("POSIXct" %in% x_class){
    x_class <- "POSIXct"
  }

  #n
  x_n <- length(x_time)

  #range
  x_range <- range(x_time)

  #length
  x_length <- diff(x_range)
  x_length_units <- attributes(x_length)$units
  if(is.null(x_length_units)){
    x_length_units <- x_class
  }
  x_length <- as.numeric(x_length)

  #resolution
  x_time_diff <- diff(x_time)
  if(!(x_class %in% c("numeric", "integer"))){
    units(x_time_diff) <- x_length_units
  }

  x_resolution <- as.numeric(mean(x_time_diff))

  #output data frame
  df <- data.frame(
    name = x_name,
    n = x_n,
    class = x_class,
    units = x_length_units,
    begin = min(x_range),
    end = max(x_range),
    length = x_length,
    resolution = x_resolution
  )

  #units
  df_units <- utils_time_units(
    all_columns = TRUE,
    class = x_class
  )

  #subset by x_length_units
  df_units <- df_units[
    seq(
      from = min(which(df_units$base_units == x_length_units)),
      to = nrow(df_units),
      by = 1
    ),
  ]

  df_units <- df_units[
    df_units$threshold <= x_length & df_units$threshold >= x_resolution,
  ]

  if(nrow(df_units) > 0){
    df$keywords <- I(list(df_units$units))
  } else {
    if(x_class != "numeric"){
      df$keywords <- x_length_units
    }
  }

  df

}
