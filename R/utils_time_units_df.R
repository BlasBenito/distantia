#' Data Frame with Supported Time Units
#'
#' @description
#' Returns a data frame with the names of the supported time units, the classes that can handle each time unit, and a the R expression used to identify what time units can be used when aggregating a time series.
#'
#' @param all_columns (optional, logical) If TRUE, all columns are returned. Default: FALSE
#' @return data frame
#' @export
#' @autoglobal
#' @examples
#'
#' df <- utils_time_units()
#' head(df)
#'
utils_time_units_df <- function(
    all_columns = FALSE
    ){

  #TODO: check expressions for negative numerics

  df <- data.frame(
    factor = c(
      1000,
      100,
      10,
      NA,
      NA,
      NA,
      NA,
      NA,
      NA,
      NA,
      NA,
      as.numeric("1e6"),
      as.numeric("1e5"),
      as.numeric("1e4"),
      as.numeric("1e3"),
      as.numeric("1e2"),
      as.numeric("1e1"),
      as.numeric("1"),
      as.numeric("1e-1"),
      as.numeric("1e-2"),
      as.numeric("1e-3"),
      as.numeric("1e-4"),
      as.numeric("1e-5"),
      as.numeric("1e-6")
    ),
    units = c(
      "millennium",
      "century",
      "decade",
      "year",
      "quarter",
      "month",
      "week",
      "day",
      "hour",
      "minute",
      "second",
      "1e6",
      "1e5",
      "1e4",
      "1e3",
      "1e2",
      "1e1",
      "1",
      "1e-1",
      "1e-2",
      "1e-3",
      "1e-4",
      "1e-5",
      "1e-6"
    ),
    class_Date = c(
      TRUE,
      TRUE,
      TRUE,
      TRUE,
      TRUE,
      TRUE,
      TRUE,
      TRUE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE
    ),
    class_POSIXct = c(
      TRUE,
      TRUE,
      TRUE,
      TRUE,
      TRUE,
      TRUE,
      TRUE,
      TRUE,
      TRUE,
      TRUE,
      TRUE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE
    ),
    class_numeric = c(
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      TRUE,
      TRUE,
      TRUE,
      TRUE,
      TRUE,
      TRUE,
      TRUE,
      TRUE,
      TRUE,
      TRUE,
      TRUE,
      TRUE,
      TRUE
    ),
    expression = c(
      "(as.numeric(diff(lubridate::year(range(stats::time(x)))))/1000) >= 1",
      "(as.numeric(diff(lubridate::year(range(stats::time(x)))))/100) >= 1",
      "(as.numeric(diff(lubridate::year(range(stats::time(x)))))/10) >= 1",
      "as.numeric(diff(lubridate::year(range(stats::time(x))))) >= 1",
      "(as.numeric(diff(lubridate::month(range(stats::time(x)))))/3) >= 1",
      "as.numeric(diff(lubridate::month(range(stats::time(x))))) >= 1",
      "(as.numeric(diff(lubridate::day(range(stats::time(x)))))/7) >= 1",
      "as.numeric(diff(lubridate::day(range(stats::time(x)))))>= 1",
      "as.numeric(diff(lubridate::hour(range(stats::time(x))))) >= 1",
      "as.numeric(diff(lubridate::minute(range(stats::time(x))))) >= 1",
      "as.numeric(diff(lubridate::second(range(stats::time(x))))) >= 1",
      "(diff(range(stats::time(x)))/1000000) >= 1",
      "(diff(range(stats::time(x)))/100000) >= 1",
      "(diff(range(stats::time(x)))/10000) >= 1",
      "(diff(range(stats::time(x)))/1000) >= 1",
      "(diff(range(stats::time(x)))/100) >= 1",
      "(diff(range(stats::time(x)))/10) >= 1",
      "(diff(range(stats::time(x)))/1) >= 1",
      "(diff(range(stats::time(x)))/0.1) >= 1",
      "(diff(range(stats::time(x)))/0.01) >= 1",
      "(diff(range(stats::time(x)))/0.001) >= 1",
      "(diff(range(stats::time(x)))/0.0001) >= 1",
      "(diff(range(stats::time(x)))/0.00001) >= 1",
      "(diff(range(stats::time(x)))/0.000001) >= 1"
    )
  )

  if(all_columns == FALSE){
    df$expression <- NULL
    df$factor <- NULL
  }

  df
}
