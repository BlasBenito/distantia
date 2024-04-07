#' Time Summary of a Time Series List
#'
#' @description
#' [tsl_time()] returns a data frame with one row per time series in the argument 'tsl' with key time features.
#'
#' [tsl_time_summayr()] is an internal function that returns a list with a general overview of the time features of all time series in the argument 'tsl'.
#'
#' @param tsl (required, list of zoo objects) Time series list. Default: NULL
#'
#' @return Data frame for [tsl_time()], and list for [tsl_time_summary()].
#' @export
#' @autoglobal
#' @examples
tsl_time <- function(
    tsl = NULL
){

  tsl <- tsl_is_valid(
    tsl = tsl
  )

  time_list <- lapply(
    X = tsl,
    FUN = zoo_time
  )

  out <- do.call(
    what = "rbind",
    args = time_list
  )

  out

}


#' @rdname tsl_time
tsl_time_summary <- function(
    tsl = NULL
){

  df <- tsl_time(tsl = tsl)

  keywords <- unique(unlist(df$keywords))

  tsl_units <- utils_time_units(
    all_columns = TRUE
  )

  list(
    class = unique(df$class),
    units = unique(df$units),
    begin = min(df$begin),
    end = max(df$end),
    keywords = keywords,
    units_df = tsl_units[
      tsl_units$units %in% keywords,
    ]
  )

}
