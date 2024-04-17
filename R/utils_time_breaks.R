#' Time Breaks for Time Series Aggregation
#'
#' @param tsl (required, time series list) Time series that will be aggregated using 'breaks'. Default: NULL
#' @param breaks (required, numeric, numeric vector, or keyword) definition of the aggregation groups. There are several options:
#' \itemize{
#'   \item keyword: Only when time in tsl is either a date "YYYY-MM-DD" or a datetime "YYYY-MM-DD hh-mm-ss". Valid options are "year", "quarter", "month", and "week" for date, and, "day", "hour", "minute", and "second" for datetime.
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

    if(time_summary$class == "Date"){
      stop("Not implemented yet.")
    }


    if(time_summary$class == "POSIXct"){
      stop("Not implemented yet.")
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


