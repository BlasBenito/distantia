#' Data Frame with Supported Time Units
#'
#' @description
#' Returns a data frame with the names of the supported time units, the classes that can handle each time unit, and a the threshold used to identify what time units can be used when aggregating a time series.
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
#' @family internal
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
    base_units = c(
      "days",
      "days",
      "days",
      "days",
      "days",
      "days",
      "days",
      "days",
      "hours",
      "mins",
      "secs",
      "numeric",
      "numeric",
      "numeric",
      "numeric",
      "numeric",
      "numeric",
      "numeric",
      "numeric",
      "numeric",
      "numeric",
      "numeric",
      "numeric",
      "numeric",
      "numeric",
      "numeric",
      "numeric",
      "numeric"
    ),
    units = c(
      "millennia",
      "centuries",
      "decades",
      "years",
      "quarters",
      "months",
      "weeks",
      "days",
      "hours",
      "minutes",
      "seconds",
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
    integer = c(
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
    #used in zoo_time() only
    threshold = c(
      365000,
      36500,
      3650,
      365,
      90,
      30,
      7,
      1,
      24,
      60,
      60,
      1e8,
      1e7,
      1e6,
      1e5,
      1e4,
      1e3,
      1e2,
      1e1,
      1,
      1e-1,
      1e-2,
      1e-3,
      1e-4,
      1e-5,
      1e-6,
      1e-7,
      1e-8
    )
  )

  if(!is.null(class)){

    if("POSIXct" %in% class){
      class <- "POSIXct"
    }

    if(class %in% c(
      "Date",
      "POSIXct",
      "numeric",
      "integer"
    )){

      df <- df[
        df[[class]] == TRUE,
        c("factor", "keyword", "base_units", "units", class, "threshold")]

    }

  }

  if(all_columns == FALSE){
    df$factor <- NULL
    df$threshold <- NULL
    df$keyword <- NULL
  }

  df
}
