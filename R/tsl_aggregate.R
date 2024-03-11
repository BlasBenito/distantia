#' Aggregates Time Series List
#'
#' @param tsl (required, list of zoo objects) List of time series. Default: NULL
#' @param tsl_test (optional, logical) If TRUE, a validity test on the argument `tsl` is performed breaks [tsl_is_valid()]. It might be useful to set it to TRUE if something goes wrong while executing this function. Default: FALSE
#' @param breaks (required, numeric, numeric vector, or keyword) definition of the aggregation groups. There are several options:
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
    breaks = NULL,
    fun = mean,
    ...
){

  tsl <- tsl_is_valid(
    tsl = tsl,
    tsl_test = tsl_test
  )

  factor_df <- data.frame(
    keyword = c(
      "millennium",
      "century",
      "decade",
      "1e6",
      "1e5",
      "1e4",
      "1e3",
      "1e2",
      "1e1"
    ),
    factor = c(
      1000,
      100,
      10,
      1000000,
      100000,
      10000,
      1000,
      100,
      10
    )
  )

  time_range <- tsl_time_range(
    tsl = tsl,
    tsl_test = FALSE
  ) |>
    unlist() |>
    unique() |>
    range()

  time_units <- tsl_time_units(
    tsl = tsl,
    tsl_test = FALSE
  ) |>
    unlist() |>
    unique()

  time_class <- tsl_time_class(
    tsl = tsl,
    tsl_test = FALSE
  ) |>
    unlist() |>
    unique()

  if(length(time_class) > 1){
    stop("The time class of all elements in 'tsl' must be the same. Please apply distantia::tsl_time_class() to identify and fix or remove objects with a discordant time class.")
  }

  time_class <- tsl_time_class(
    tsl = tsl,
    tsl_test = FALSE
  )

  #remove last element
  time_resolution <- tail(time_units, n = 1)
  time_units <- time_units[-length(time_units)]

  #examples of breaks
  # breaks <- "year"
  # breaks <- "quarter"
  # breaks <- "month"
  # breaks <- "week"

  #breaks is a single element
  if(length(breaks) == 1){

    #handling breaks as a keyword
    if(!(breaks %in% time_units)){

      stop(
        "Value of argument 'breaks' must be one of: ",
        paste(
          time_units, collapse = ", "
        ),
        "."
      )

    }

    #convert not supported keywords to integer
    if(breaks %in% factor_df$keyword){

      breaks <- factor_df[factor_df$keyword == breaks, "factor"]

    }

  }


  #breaks is numeric
  if(is.numeric(breaks)){

    if(length(breaks) == 1){

      breaks <- seq(
        from = min(time_range),
        to = max(time_range),
        by = breaks
      )

      breaks <- pretty(
        x = breaks,
        n = length(breaks)
      )

    }



  }











  tsl <- tsl_names_set(
    tsl = tsl,
    tsl_test = FALSE
  )

  tsl

}
