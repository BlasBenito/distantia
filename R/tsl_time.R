#' Time Summary of a Time Series List
#'
#' @description
#' [tsl_time()] returns a data frame with one row per time series in the argument 'tsl' with key time features.
#'
#' [tsl_time_summary()] is an internal function that returns a list with a general overview of the time features of all time series in the argument 'tsl'.
#'
#' @param tsl (required, list of zoo objects) Time series list. Default: NULL
#' @param keywords (optional, character string or vector) Defines what keywords are returned. If "aggregate", returns valid keywords for [zoo_aggregate()]. If "resample", returns valid keywords for [zoo_resample()]. If both, returns all valid keywords. Default: c("aggregate", "resample").
#' @return Data frame for [tsl_time()], and list for [tsl_time_summary()].
#' @export
#' @autoglobal
#' @examples
#' TODO: complete example
tsl_time <- function(
    tsl = NULL,
    keywords = c(
      "resample",
      "aggregate"
    )
){

  tsl <- tsl_is_valid(
    tsl = tsl
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
