#' New Time for Time Series Aggregation
#'
#' @description
#' Internal function of [tsl_aggregate()] to check input argument `new_time` for time series aggregation and return a proper aggregation vector.
#'
#'
#' @param tsl (required, time series list) Time series that will be aggregated using 'new_time'. Default: NULL
#' @param new_time (required, numeric, numeric vector, Date vector, POSIXct vector, or keyword) breakpoints defining aggregation groups. Options are:
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
utils_new_time <- function(
    tsl = NULL,
    new_time = NULL
){

  tsl <- tsl_is_valid(
    tsl = tsl
  )

  # new_time types ----
  new_time <- utils_new_time_type(
    tsl = tsl,
    new_time = new_time
  )

  new_time_type <- attributes(new_time)$new_time_type

  # time summary of tsl ----
  time_summary <- tsl_time_summary(
    tsl = tsl
  )

  # compute new_time ----

  ## standard_keyword ----
  if(new_time_type == "standard_keyword"){

    if(time_summary$class == "Date"){

      new_time_vector <- seq.Date(
        from = time_summary$begin,
        to = time_summary$end,
        by = new_time
      )

    }

    if(time_summary$class == "POSIXct"){

      new_time_vector <- seq.POSIXt(
        from = time_summary$begin,
        to = time_summary$end,
        by = new_time
      )

    }

  } #end of standard keyword


  ## non_standard_keyword ----
  if(new_time_type == "non_standard_keyword"){

    # time units
    time_units <- time_summary$units_df[
      time_summary$units_df$units == new_time,
    ]

    #non-standard are always in "years"
    unit <- paste0(time_units$factor, " years")

    if(time_summary$class == "Date"){

      new_time_vector <- seq.Date(
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

      new_time_vector <- seq.POSIXt(
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
  if(new_time_type == "numeric_interval"){

    if(time_summary$class == "numeric"){

      new_time_vector <- seq(
        from = time_summary$begin - new_time,
        to = time_summary$end + new_time,
        by = new_time
      )

    }

    #non-standard are always in "years"
    new_time <- as.integer(new_time)
    unit <- paste0(new_time, " days")

    if(time_summary$class == "Date"){

      new_time_vector <- seq.Date(
        from = time_summary$begin,
        to = time_summary$end,
        by = unit
      )

    }

    if(time_summary$class == "POSIXct"){

      new_time_vector <- seq.POSIXt(
        from = time_summary$begin,
        to = time_summary$end,
        by = unit
      )

    }

  } #end of numeric_interval


  ## numeric_vector ----
  if(new_time_type == "numeric_vector"){

    begin <- min(new_time) - min(diff(new_time))

    if(min(new_time) > time_summary$begin){
      new_time <- c(
        min(new_time) - min(diff(new_time)),
        new_time
        )
    }

    if(max(new_time) < time_summary$end){
      new_time <- c(
        new_time,
        max(new_time) + min(diff(new_time))
        )
    }

    new_time_vector <- new_time

  }

  ## POSIXct_vector ----
  ## Date_vector ----
  if(new_time_type %in% c(
    "POSIXct_vector",
    "Date_vector"
  )
  ){

    return(new_time)

  }


  # pretty
  new_time_vector_pretty <- pretty(
    x = new_time_vector,
    n = length(new_time_vector)
  )

  #criteria to accept new_time_vector_pretty
  if(
    length(new_time_vector) == length(new_time_vector_pretty) &&
    abs(
      diff(range(new_time_vector)) - diff(range(new_time_vector_pretty))
      ) < 1e-5
  ){

    new_time_vector <- new_time_vector_pretty

  }


  new_time_vector

}


