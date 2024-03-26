#' Data Frame with Supported Time Units
#'
#' @description
#' Returns a data frame with the names of the supported time units, the classes that can handle each time unit, and a the R expression used to identify what time units can be used when aggregating a time series.
#'
#' @param all_columns (optional, logical) If TRUE, all columns are returned. Default: FALSE
#' @param class (optional, class name). Used to filter rows and columns. Accepted values are "numeric", "Date", and "POSIXct". Default: NULL
#' @return data frame
#' @export
#' @autoglobal
#' @examples
#'
#' df <- utils_time_units()
#' head(df)
#'
utils_time_units <- function(
    all_columns = FALSE,
    class = NULL
    ){

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
      as.numeric("1e8"),
      as.numeric("1e7"),
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
      as.numeric("1e-6"),
      as.numeric("1e-7"),
      as.numeric("1e-8")
    ),
    keyword = c(
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
      FALSE,
      FALSE
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
      "1e8",
      "1e7",
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
      "1e-6",
      "1e-7",
      "1e-8"
    ),
    Date = c(
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
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE
    ),
    POSIXct = c(
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
      FALSE,
      FALSE,
      FALSE,
      FALSE,
      FALSE
    ),
    numeric = c(
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
      TRUE,
      TRUE,
      TRUE,
      TRUE,
      TRUE
    ),
    expression = c(
      "as.numeric(diff(range(stats::time(x)))) > 365000",
      "as.numeric(diff(range(stats::time(x)))) > 36500",
      "as.numeric(diff(range(stats::time(x)))) > 3650",
      "as.numeric(diff(range(stats::time(x)))) > 365",
      "as.numeric(diff(range(stats::time(x))))/90 > 1",
      "as.numeric(diff(range(stats::time(x))))/30 > 1",
      "as.numeric(diff(range(stats::time(x))))/7 > 1",
      "as.numeric(diff(range(stats::time(x)))) > 1",
      "as.numeric(diff(lubridate::hour(range(stats::time(x))))) > 1",
      "as.numeric(diff(lubridate::minute(range(stats::time(x))))) > 1",
      "as.numeric(diff(lubridate::second(range(stats::time(x))))) > 1",
      "(diff(range(stats::time(x)))/1e8) > 1",
      "(diff(range(stats::time(x)))/1e7) > 1",
      "(diff(range(stats::time(x)))/1e6) > 1",
      "(diff(range(stats::time(x)))/1e5) > 1",
      "(diff(range(stats::time(x)))/1e4) > 1",
      "(diff(range(stats::time(x)))/1e3) > 1",
      "(diff(range(stats::time(x)))/1e2) > 1",
      "(diff(range(stats::time(x)))/1e1) > 1",
      "diff(range(stats::time(x))) > 1",
      "diff(range(stats::time(x))) > 1e-1",
      "diff(range(stats::time(x))) > 1e-2",
      "diff(range(stats::time(x))) > 1e-3",
      "diff(range(stats::time(x))) > 1e-4",
      "diff(range(stats::time(x))) > 1e-5",
      "diff(range(stats::time(x))) > 1e-6",
      "diff(range(stats::time(x))) > 1e-7",
      "diff(range(stats::time(x))) > 1e-8"
    )
  )

  if(!is.null(class)){

    if("POSIXct" %in% class){
      class <- "POSIXct"
    }

    if(class %in% c(
      "Date",
      "POSIXct",
      "numeric"
    )){

      df <- df[
        df[[class]] == TRUE,
        c("factor", "keyword", "units", class, "expression")]

    }

  }

  if(all_columns == FALSE){
    df$factor <- NULL
    df$expression <- NULL
    df$keyword <- NULL
  }

  df
}
