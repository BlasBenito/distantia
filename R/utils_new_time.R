#' New Time for Time Series Aggregation
#'
#' @description
#' Internal function of [tsl_aggregate()] to check input argument `new_time` for time series aggregation and return a proper aggregation vector.
#'
#'
#' @param tsl (required, time series list) Time series that will be aggregated using 'new_time'. Default: NULL
#' @param new_time (required, zoo object, numeric, numeric vector, Date vector, POSIXct vector, or keyword) breakpoints defining aggregation groups. Options are:
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

  # tsl and old_time ----
  tsl <- tsl_is_valid(
    tsl = tsl
  )

  old_time <- tsl_time_summary(
    tsl = tsl
  )

  # new_time is NULL ----
  if(is.null(new_time)){
    return(NULL)
  }

  # new_time is zoo ----
  if(zoo::is.zoo(new_time)){
    new_time <- zoo::index(new_time)
  }

  # new_time is tsl ----
  if(
    is.list(new_time) &&
    zoo::is.zoo(new_time[[1]])
    ){

    new_time <- tsl_is_valid(
      tsl = new_time
    )

    new_time <- tsl_time(
      tsl = new_time
      )

    new_time <- seq(
      from = max(new_time$begin),
      to = min(new_time$end),
      by = mean(new_time$resolution)
    )

  }

  # new_time type ----
  new_time <- utils_new_time_type(
    tsl = tsl,
    new_time = new_time
  )

  new_time_type <- attributes(new_time)$new_time_type


  # generate new_time ----

  ## standard_keyword ----
  if(new_time_type == "standard_keyword"){

    new_time <- seq(
      from = old_time$begin,
      to = old_time$end,
      by = new_time
    )

  } #end of standard keyword


  ## non_standard_keyword ----
  if(new_time_type == "non_standard_keyword"){

    # time units
    time_units <- old_time$units_df[
      old_time$units_df$units == new_time,
    ]

    #non-standard are always in "years"
    unit <- paste0(time_units$factor, " years")

      new_time <- seq(
        from = lubridate::floor_date(
          x = old_time$begin,
          unit = unit
        ),
        to = lubridate::ceiling_date(
          x = old_time$end,
          unit = unit
        ),
        by = unit
      )

  }


  ## numeric_interval ----
  if(new_time_type == "numeric_interval"){

    if(old_time$class == "numeric"){

      new_time <- seq(
        from = old_time$begin - new_time,
        to = old_time$end + new_time,
        by = new_time
      )

    } else {

      #non-standard are always in "days"
      new_time <- as.integer(new_time)
      unit <- paste0(new_time, " days")

      new_time <- seq.Date(
        from = old_time$begin,
        to = old_time$end,
        by = unit
      )

    }

  } #end of numeric_interval


  ## numeric_vector ----
  if(new_time_type == "numeric_vector"){

    begin <- min(new_time) - min(diff(new_time))

    if(min(new_time) > old_time$begin){
      new_time <- c(
        min(new_time) - min(diff(new_time)),
        new_time
        )
    }

    if(max(new_time) < old_time$end){
      new_time <- c(
        new_time,
        max(new_time) + min(diff(new_time))
        )
    }

  }

  #subset to original range
  new_time <- new_time[
    new_time >= old_time$begin &
      new_time <= old_time$end
  ]

  #coerce time class
  new_time <- utils_coerce_time_class(
    x = new_time,
    to = ifelse(
      test = "POSIXct" %in% old_time$class,
      yes = "POSIXct",
      no = old_time$class
    )
  )

  new_time

}


