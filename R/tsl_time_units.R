#' Time Units of Time Series List
#'
#' @description
#' Returns keywords representing the time units available in the 'index' attribute of the zoo time series within a time series list.
#'
#' If the 'index' attribute is of the class "Date", then this function searches for the highest and lowest units of variability in the range of dates, and returns them along with all the units in between. All possible unit keywords are: "millennium", "century", "decade", "year", "quarter", "month", "week", "day", "hour", "minute", "second". For example, if the argument 'tsl' has a range of dates c("2020-02-01" "2023-12-19"), since the difference between years is higher than 1 and the difference between days is higher than one, then the returned units are c("year", "quarter", "month", "week", and "day").
#'
#' If the 'index' attribute is of the class 'numeric', then the then this function searches for the highest and lowest units of variability in the range of dates, and returns them along with all the units in between. All possible unit keywords are: "1e6" (million), "1e5" (one hundred thousand), "1e3" (ten thousand), "1e3" (thousand), "1e2" (hundred), "1e1" (ten). For example, for the range of numeric times c(-100000, 2000), the units returned are c("1e5", "1e4", "1e3", "1e2", "1e1").
#'
#'
#' @param tsl (required, list of zoo objects) List of time series. Default: NULL
#' @param tsl_test (optional, logical) If TRUE, a validity test on the argument `tsl` is performed by [tsl_is_valid()]. It might be useful to set it to TRUE if something goes wrong while executing this function. Default: FALSE
#'
#' @return List of character vector or character vector with the time units.
#' @export
#' @examples
#' @autoglobal
tsl_time_units <- function(
    tsl = NULL,
    tsl_test = FALSE
){

  tsl <- tsl_is_valid(
    tsl = tsl,
    tsl_test = tsl_test
  )

  df_time_summary <- function(df){

    df_time_large <- utils::head(
      x = df[df$value >= 1, "units"],
      n = 1
    )

    df_time_small <- utils::tail(
      x = df[df$value >= 1, "units"],
      n = 1
    )

    df_time_large_index <- which(df$units == df_time_large)
    df_time_small_index <- which(df$units == df_time_small)

    df$units[
      seq(
        from = df_time_large_index,
        to = df_time_small_index,
        by = 1)
    ]

  }


  zoo_time_units <- function(x){

    if(!zoo::is.zoo(x)){
      stop("Argument 'x' must be of class 'zoo'.")
    }

    x.time.range <- x |>
      stats::time() |>
      range()

    x.time.class <- class(x.time.range)

    #handling date types
    if(x.time.class %in% c("Date", "POSIXct", "POSIXt")){

      df_time <- data.frame(
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
          "second"
        ),
        value = c(
          diff(lubridate::year(x.time.range))/1000,
          diff(lubridate::year(x.time.range))/100,
          diff(lubridate::year(x.time.range))/10,
          diff(lubridate::year(x.time.range)),
          diff(lubridate::month(x.time.range))/3,
          diff(lubridate::month(x.time.range)),
          diff(lubridate::day(x.time.range))/7,
          diff(lubridate::day(x.time.range)),
          diff(lubridate::hour(x.time.range)),
          diff(lubridate::minute(x.time.range)),
          diff(lubridate::second(x.time.range))
        )
      )

    } else {

      df_time <- data.frame(
        units = c(
          "1e6",
          "1e5",
          "1e4",
          "1e3",
          "1e2",
          "1e1"
        ),
        value = c(
          diff(x.time.range)/1000000,
          diff(x.time.range)/100000,
          diff(x.time.range)/10000,
          diff(x.time.range)/1000,
          diff(x.time.range)/100,
          diff(x.time.range)/10
        )
      )

    }

    df_time_summary(df = df_time)

  }

  time_units_list <- lapply(
    X = tsl,
    FUN = zoo_time_units
  )

  time_units <- time_units_list |>
    unique()

  if(length(time_units) == 1){
    time_units_list <- time_units[[1]]
  }

  time_units_list

}
