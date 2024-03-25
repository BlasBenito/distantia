#' Aggregates Time Series List
#'
#' @param tsl (required, list of zoo objects) List of time series. Default: NULL
#' @param breaks (required, numeric, numeric vector, or keyword) definition of the aggregation groups. There are several options:
#' \itemize{
#'   \item keyword: Only when time in tsl is either a date "YYYY-MM-DD" or a datetime "YYYY-MM-DD hh-mm-ss". Valid options are "year", "quarter", "month", and "week" for date, and, "day", "hour", "minute", and "second" for datetime.
#' }
#' @param stat (required, function) name without quotes and parenthesis of a standard function to smooth a time series. Typical examples are `mean` (default), `max`,`min`, `median`, and `sd`. Default: `mean`.
#'
#' @return time series list
#' @export
#'
#' @examples
tsl_aggregate <- function(
    tsl = NULL,
    breaks = NULL,
    f = mean,
    ...
){

  # EXAMPLES
  # #######################################
  #
  #   #Date
  #   tsl <- tsl_simulate(
  #     time_range = c(
  #       "0100-01-01",
  #       "2024-12-31"
  #     )
  #   )
  #
  #   breaks <- "millennium"
  #   breaks <- "century"
  #   breaks <- "decade"
  #   breaks <- "year"
  #   breaks <- "quarter"
  #   breaks <- "month"
  #   breaks <- "week"
  #   breaks <- c(
  #     "0150-01-01",
  #     "1500-12-02",
  #     "1800-12-02",
  #     "2000-01-02"
  #   )
  #
  #   #POSIXct
  #   tsl <- tsl_simulate(
  #     time_range = c(
  #       "0100-01-01 12:00:25",
  #       "2024-12-31 11:15:45"
  #     )
  #   )
  #
  #   breaks <- "millennium"
  #   breaks <- "century"
  #   breaks <- "decade"
  #   breaks <- "year"
  #   breaks <- "quarter"
  #   breaks <- "month"
  #   breaks <- "week"
  #   breaks <- "hour"
  #   breaks <- c(
  #     "0150-01-01",
  #     "1500-12-02",
  #     "1800-12-02",
  #     "2000-01-02"
  #   )
  #
  #
  #   #numeric
  #   tsl <- tsl_simulate(
  #     time_range = c(-123120, 1200)
  #   )
  #
  #   breaks <- 1000
  #   breaks <- 100
  ######################################

  tsl <- tsl_is_valid(
    tsl = tsl
  )

  if(is.function(f) == FALSE){

    stop(
      "Argument 'f' must be a function name. A few valid options are 'mean', 'median', 'max', 'min', and 'sd', among others.")

  }

  breaks <- utils_time_breaks(
    tsl = tsl,
    breaks = breaks
  )

  #aggregate here
  tsl <- lapply(
    X = tsl,
    FUN = function(x){


      #create breaks
      x_breaks_factor <- x |>
        stats::time() |>
        cut(breaks = breaks)

      #replace NAs in breaks
      x_breaks_factor[is.na(x_breaks_factor)] <- as.factor(
        tail(
          x = na.omit(x_breaks_factor),
          n = 1
        )
      )

      #aggregate x
      x <- stats::aggregate(
        x = x,
        by = as.numeric(x_breaks_factor),
        FUN = f
      )

      #fix index in x
      x_breaks_dates <- x_breaks_factor |>
        unique() |>
        utils_as_time()

      zoo::index(x) <- x_breaks_dates

      return(x)

    }
  )

  tsl <- tsl_names_set(
    tsl = tsl
  )

  tsl

}
