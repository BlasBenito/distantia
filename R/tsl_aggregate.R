#' Aggregates Time Series List
#'
#' @param tsl (required, list of zoo objects) List of time series. Default: NULL
#' @param tsl_test (optional, logical) If TRUE, a validity test on the argument `tsl` is performed by [tsl_is_valid()]. It might be useful to set it to TRUE if something goes wrong while executing this function. Default: FALSE
#' @param by (required, numeric, numeric vector, or keyword) definition of the aggregation groups. There are several options:
#' \itemize{
#'   \item keyword: Only when time in tsl is either a date "YYYY-MM-DD" or a datetime "YYYY-MM-DD hh-mm-ss". Valid options are "year", "quarter", "month", and "week" for date, and, "day", "hour", "minute", and "second" for datetime.
#' }
#' @param stat (required, function) name without quotes and parenthesis of a standard function to smooth a time series. Typical examples are `mean` (default), `max`, `median`, and `sd`. Default: `mean`.
#'
#' @return time series list
#' @export
#'
#' @examples
tsl_aggregate <- function(
    tsl = NULL,
    tsl_test = FALSE,
    by = NULL,
    fun = mean,
    ...
){

  # handling tsl ----
  tsl <- tsl_is_valid(
    tsl = tsl,
    tsl_test = tsl_test
  )

  time.class <- lapply(
    X = tsl,
    FUN = function(x){
      class(stats::time(x))
    }
  ) |>
    unlist() |>
    unique()

  by_date_keywords <- c(
    "year",
    "quarter",
    "month",
    "week",
    "day"
  )

  by_datetime_keywords <- c(
    by_date_keywords,
    "hour",
    "minute",
    "second"
  )

  # handling by ----
  by <- c("2022-01-10", "2024-02-20")
  by <- c("2022-10-27 12:34:56", "2021-10-27 16:35:40")
  by <- 1000
  by <- c()



  #by <- "month"
  by.type <- switch(
    by,
    date = {
      all(lubridate::hour(as.POSIXct(by)) == 0)
    },
    datetime = {
      all(lubridate::hour(as.POSIXct(by)) != 0)
    }
  )

  by.class <- class(by)



  by.is.date <-  as.Date(x = by)

  # handling stat ----
  if(is.function(fun) == FALSE){

    stop(
      "Argument 'fun' must be a function name."
    )

  }

  if(time.class == "Date"){

    if(by.class == "character"){
      by <- by[1]
    }


  }

  if(
    is.character(by) &&
    by[1] %in% keywords
    ){



  }





  tsl <- tsl_names_set(
    tsl = tsl,
    tsl_test = FALSE
  )

  tsl

}
