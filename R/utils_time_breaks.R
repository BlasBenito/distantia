#' Time Breaks for Time Series Aggregation
#'
#' @description
#' Internal function of [tsl_aggregate()] to check input breaks for time series aggregation and returns a proper aggregation vector.
#'
#'
#' @param tsl (required, time series list) Time series that will be aggregated using 'breaks'. Default: NULL
#' @param breaks (required, numeric, numeric vector, Date vector, POSIXct vector, or keyword) breakpoints defining aggregation groups. Options are:
#' \itemize{
#'   \item numeric vector: only for the "numeric" time class, defines the breakpoints for time series aggregation.
#'   \item "Date" or "POSIXct" vector: as above, but for the time classes "Date" and "POSIXct." In any case, the input vector is coerced to the time class of the `tsl` argument.
#'   \item numeric: defines fixed with time intervals for time series aggregation. Used as is when the time class is "numeric", and coerced to integer and interpreted as days for the time classes "Date" and "POSIXct".
#'   \item keyword (see [utils_time_units()] and [tsl_time_summary()]): the common options for the time classes "Date" and "POSIXct" are: "millennia", "centuries", "decades", "years", "quarters", "months", and "weeks". Exclusive keywords for the "POSIXct" time class are: "days", "hours", "minutes", and "seconds". The time class "numeric" accepts keywords coded as scientific numbers, from "1e8" to "1e-8".
#' }
#'
#' @return Vector of class numeric, Date, or POSIXct
#' @export
#' @autoglobal
#' @examples
utils_time_breaks <- function(
    tsl = NULL,
    breaks = NULL
){

  tsl <- tsl_is_valid(
    tsl = tsl
  )

  # breaks types ----
  breaks <- utils_time_breaks_type(
    tsl = tsl,
    breaks = breaks
  )

  breaks_type <- attributes(breaks)$breaks_type

  # time summary of tsl ----
  time_summary <- tsl_time_summary(
    tsl = tsl
  )

  # compute breaks ----

  ## standard_keyword ----
  if(breaks_type == "standard_keyword"){

    if(time_summary$class == "Date"){

      breaks_vector <- seq.Date(
        from = time_summary$begin,
        to = time_summary$end,
        by = breaks
      )

    }

    if(time_summary$class == "POSIXct"){

      breaks_vector <- seq.POSIXt(
        from = time_summary$begin,
        to = time_summary$end,
        by = breaks
      )

    }

  } #end of standard keyword


  ## non_standard_keyword ----
  if(breaks_type == "non_standard_keyword"){

    # time units
    time_units <- time_summary$units_df[
      time_summary$units_df$units == breaks,
    ]

    #non-standard are always in "years"
    unit <- paste0(time_units$factor, " years")

    if(time_summary$class == "Date"){

      breaks_vector <- seq.Date(
        from = lubridate::floor_date(
          x = time_summary$begin,
          unit = unit
        ),
        to = lubridate::ceiling_date(
          x = time_summary$end,
          unit = unit
        ),
        by = unit
      )

    }

    if(time_summary$class == "POSIXct"){

      breaks_vector <- seq.POSIXt(
        from = lubridate::floor_date(
          x = time_summary$begin,
          unit = unit
        ),
        to = lubridate::ceiling_date(
          x = time_summary$end,
          unit = unit
        ),
        by = unit
      )

    }

  }


  ## numeric_interval ----
  if(breaks_type == "numeric_interval"){

    if(time_summary$class == "numeric"){

      breaks_vector <- seq(
        from = time_summary$begin - breaks,
        to = time_summary$end + breaks,
        by = breaks
      )

    }

    #non-standard are always in "years"
    breaks <- as.integer(breaks)
    unit <- paste0(breaks, " days")

    if(time_summary$class == "Date"){

      breaks_vector <- seq.Date(
        from = time_summary$begin,
        to = time_summary$end,
        by = unit
      )

    }

    if(time_summary$class == "POSIXct"){

      breaks_vector <- seq.POSIXt(
        from = time_summary$begin,
        to = time_summary$end,
        by = unit
      )

    }

  } #end of numeric_interval


  ## numeric_vector ----
  if(breaks_type == "numeric_vector"){

    begin <- min(breaks) - min(diff(breaks))

    if(min(breaks) > time_summary$begin){
      breaks <- c(
        min(breaks) - min(diff(breaks)),
        breaks
        )
    }

    if(max(breaks) < time_summary$end){
      breaks <- c(
        breaks,
        max(breaks) + min(diff(breaks))
        )
    }

    breaks_vector <- breaks

  }

  ## POSIXct_vector ----
  ## Date_vector ----
  if(breaks_type %in% c(
    "POSIXct_vector",
    "Date_vector"
  )
  ){

    return(breaks)

  }


  # pretty
  breaks_vector_pretty <- pretty(
    x = breaks_vector,
    n = length(breaks_vector)
  )

  #criteria to accept breaks_vector_pretty
  if(
    length(breaks_vector) == length(breaks_vector_pretty) &&
    abs(
      diff(range(breaks_vector)) - diff(range(breaks_vector_pretty))
      ) < 1e-5
  ){

    breaks_vector <- breaks_vector_pretty

  }


  breaks_vector

}


