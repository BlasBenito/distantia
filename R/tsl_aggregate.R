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

  tsl <- tsl_is_valid(
    tsl = tsl
  )

  if(is.function(f) == FALSE){

    stop(
      "Argument 'f' must be a function name. A few valid options are 'mean', 'median', 'max', 'min', and 'sd', among others.")

  }

  #gather tsl time features
  tsl_time <- tsl_time_summary(
    tsl = tsl
  )

  #units data frame
  tsl_time_units <- utils_time_units_df(
    all_columns = TRUE
  )

  #subset by units
  tsl_time_units <- tsl_time_units[tsl_time_units$units %in% tsl_time$units, ]

  #subset by class
  tsl_time_class_column <- paste0(
    "class_",
    tsl_time$class
  )

  if(tsl_time_class_column %in% colnames(tsl_time_units)){
    tsl_time_units <- tsl_time_units[tsl_time_units[[tsl_time_class_column]] == TRUE, ]
  } else {
    stop("Supported time classes for aggregation are 'Date', 'POSIXct', and 'numeric'.")
  }

  # breaks ----

  #examples of breaks
  # breaks <- "year"
  # breaks <- "quarter"
  # breaks <- "month"
  # breaks <- "week"
  # breaks <-

  #breaks is a keyword or a number
  if(length(breaks) == 1){

    #breaks is a keyword
    if(is.character(breaks)){

      if(breaks %in% tsl_time_units$units){

        breaks_factor <- tsl_time_units[tsl_time_units$units == breaks, "factor"]

        #breaks is an accepted aggregation keyword
        if(is.na(breaks_factor)){

          breaks_ready <- breaks

        } else {

          #recompute factor
          tsl_time_units$factor <- rev(
            c(
              1,
              10^seq(
                from = 1,
                to = (nrow(tsl_time_units) - 1),
                by = 1
              )
            )
          )

          breaks_factor <- tsl_time_units[tsl_time_units$units == breaks, "factor"]

          #raw breaks
          breaks_raw <- seq(
            from = min(tsl_time$range),
            to = max(tsl_time$range),
            by = breaks_factor
          )

          #pretty breaks
          breaks_ready <- pretty(
            x = breaks_raw,
            n = length(breaks_raw)
          )

        }

      } else {

        stop(
          "Valid options for 'breaks' keywords are: '",
          paste0(
            tsl_time_units$units[tsl_time_units$units != tsl_time$resolution],
            collapse = "',
            '"
            ),
          "'."
        )

      }


    #breaks is a number
    } else {


    }

    #breaks is in tsl_time_units



  }

  tsl <- tsl_names_set(
    tsl = tsl
  )

  tsl

}
