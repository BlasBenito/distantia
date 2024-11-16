#' Time Features of Time Series Lists
#'
#' @description
#' The functions [tsl_time()] and [tsl_time_summary()] summarize the time features of a time series list.
#' \itemize{
#'   \item [tsl_time()] returns a data frame with one row per time series in the argument 'tsl'
#'   \item [tsl_time_summary()] returns a list with the features captured by [tsl_time()], but aggregated across time series.
#' }
#'
#' Both functions return keywords useful for the functions [tsl_aggregate()] and [tsl_resample()], depending on the value of the argument `keywords`.
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param keywords (optional, character string or vector) Defines what keywords are returned. If "aggregate", returns valid keywords for [zoo_aggregate()]. If "resample", returns valid keywords for [zoo_resample()]. If both, returns all valid keywords. Default: c("aggregate", "resample").
#' @return
#' \itemize{
#'   \item [tsl_time()]: data frame with the following columns:
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
#'   \item [tsl_time_summary()]: list with the following objects:
#'   \itemize{
#'     \item `class` (string): time class, one of "Date", "POSIXct", or "numeric."
#'     \item `units` (string): units of the time series.
#'     \item `begin` (date or numeric): begin time of the time series.
#'     \item `end` (date or numeric): end time of the time series.
#'     \item `resolution_max` (numeric): longer time interval between consecutive samples expressed in `units`.
#'     \item `resolution_min` (numeric): shorter time interval between consecutive samples expressed in `units`.
#'     \item `keywords` (character vector): valid keywords for [tsl_aggregate()] or [tsl_resample()], depending on the value of the argument `keywords`.
#'     \item `units_df` (data frame) data frame for internal use within [tsl_aggregate()] and [tsl_resample()].
#'   }
#' }
#' @export
#' @autoglobal
#' @examples
#' #simulate a time series list
#' tsl <- tsl_simulate(
#'   n = 3,
#'   rows = 150,
#'   time_range = c(
#'     Sys.Date() - 365,
#'     Sys.Date()
#'   ),
#'   irregular = TRUE
#' )
#'
#' #time data frame
#' tsl_time(
#'   tsl = tsl
#' )
#'
#' #time summary
#' tsl_time_summary(
#'   tsl = tsl
#' )
#' @family data_exploration
tsl_time <- function(
    tsl = NULL,
    keywords = c(
      "resample",
      "aggregate"
    )
){

  utils_check_args_tsl(
    tsl = tsl,
    min_length = 1
  )

  time_list <- lapply(
    X = tsl,
    FUN = zoo_time,
    keywords = keywords
  )

  out <- do.call(
    what = "rbind",
    args = time_list
  )

  rownames(out) <- NULL

  out

}


#' @rdname tsl_time
#' @export
#' @autoglobal
tsl_time_summary <- function(
    tsl = NULL,
    keywords = c(
      "resample",
      "aggregate"
    )
){

  df <- tsl_time(
    tsl = tsl,
    keywords = keywords
    )

  keywords <- unique(unlist(df$keywords))

  begin <- min(df$begin)
  if(is.numeric(begin)){
    if(!is.integer(begin)){
      begin <- round(x = begin, digits = 4)
      end <- round(x = begin, digits = 4)
    }
  }

  tsl_units <- utils_time_units(
    all_columns = TRUE
  )

  units_df <- tsl_units[
    tsl_units$units %in% keywords,
    c("factor", "base_units", "units", "threshold", "keyword")
  ]

  resolution_range <- lapply(
    X = tsl,
    FUN = function(x){
      range(diff(zoo::index(x)))
    }
  ) |>
    unlist()

  list(
    class = unique(df$class),
    units = unique(df$units),
    begin = min(df$begin),
    end = max(df$end),
    resolution_max = min(resolution_range),
    resolution_min = max(resolution_range),
    keywords = keywords,
    units_df = units_df
  )

}
