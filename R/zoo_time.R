#' Get Time Features from Zoo Objects
#'
#' @description
#' This function generates a data frame summarizing the time features (class, length, resolution, and others) of zoo time series.
#'
#'
#' @param x (required, zoo object) Zoo time series to analyze. Default: NULL.
#' @param keywords (optional, character string or vector) Defines what keywords are returned. If "aggregate", returns valid keywords for [zoo_aggregate()]. If "resample", returns valid keywords for [zoo_resample()]. If both, returns all valid keywords. Default: c("aggregate", "resample").
#'
#' @return Data frame with the following columns:
#'   \itemize{
#'     \item `name` (string): time series name.
#'     \item `rows` (integer): number of observations.
#'     \item `class` (string): time class, one of "Date", "POSIXct", or "numeric."
#'     \item `units` (string): units of the time series.
#'     \item `length` (numeric): total length of the time series expressed in `units`.
#'     \item `resolution` (numeric): average interval between observations expressed in `units`.
#'     \item `begin` (date or numeric): begin time of the time series.
#'     \item `end` (date or numeric): end time of the time series.
#'     \item `keywords` (character vector): valid keywords for [tsl_aggregate()] or [tsl_resample()], depending on the value of the argument `keywords`.
#'   }
#' @export
#' @autoglobal
#' @examples
#' #simulate a zoo time series
#' x <- zoo_simulate(
#'   rows = 150,
#'   time_range = c(
#'     Sys.Date() - 365,
#'     Sys.Date()
#'   ),
#'   irregular = TRUE
#' )
#'
#' #time data frame
#' zoo_time(
#'   x = x
#' )
#' @family data_exploration
zoo_time <- function(
    x = NULL,
    keywords = c(
      "resample",
      "aggregate"
    )
){

  if(zoo::is.zoo(x) == FALSE){
    stop("Argument 'x' must be a zoo time series.")
  }

  keywords <- match.arg(
    arg = keywords,
    choices = c(
      "resample",
      "aggregate"
    ),
    several.ok = TRUE
  )

  if("name" %in% names(attributes(x))){
    x_name <- attributes(x)$name
  } else {
    x_name <- ""
  }

  x_time <- zoo::index(x)

  #class
  x_class <- class(x_time)
  if("POSIXct" %in% x_class){
    x_class <- "POSIXct"
  }

  #n
  x_rows <- length(x_time)

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
    rows = x_rows,
    class = x_class,
    units = x_length_units,
    length = x_length,
    resolution = x_resolution,
    begin = min(x_range),
    end = max(x_range)
  )

  #units
  df_units <- utils_time_units(
    all_columns = TRUE,
    class = x_class
  )

  #subset by x_length_units
  df_units <- df_units[
    seq(
      from = min(
        which(
          df_units$base_units == x_length_units
          )
        ),
      to = nrow(df_units),
      by = 1
    ),
  ]


  #exception for very short time units
  if(!(x_length_units %in% c("hours", "mins", "secs"))){

    df_units <- df_units[
      df_units$threshold <= (x_length + x_resolution) &
        df_units$threshold >= x_resolution / 10,
    ]

  }

  #identify aggregation and resampling keywords
  df_units$aggregate <- FALSE
  df_units$resample <- FALSE

  #aggregation with an average of two samples
  df_units$aggregate[
    df_units$threshold > x_resolution * 2
    ] <- TRUE

  #resampling one order of magnitude above and below resolution
  df_units$resample[
    df_units$threshold >= x_resolution / 10 &
      df_units$threshold <= x_resolution * 10
    ] <- TRUE

  if(length(keywords) == 1){

    if(keywords == "aggregate"){
      df_units <- df_units[df_units$aggregate == TRUE, ]
    }

    if(keywords == "resample"){
      df_units <- df_units[df_units$resample == TRUE, ]
    }

  }

  if(nrow(df_units) > 0){
    df$keywords <- I(list(df_units$units))
  } else {
    if(x_class != "numeric"){
      df$keywords <- x_length_units
    }
  }

  df

}
