#' Time Breaks for Time Series Aggregation
#'
#' @param x (required, list of zoo objects or zoo object) Time series that will be aggregated using 'breaks'. Default: NULL
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
    x = NULL,
    breaks = NULL
){

  tsl <- zoo_to_tsl(
    x = x
  )

  tsl <- tsl_is_valid(
    tsl = tsl
  )

  # get time features of tsl ----
  time_df <- tsl_time(
    tsl = tsl,
    keywords = TRUE
  )

  time_class <- unique(time_df$class)

  if(length(time_class) > 1){
    stop(
      "The time class of all zoo objects in 'tsl' must be the same, but they are: '",
      paste(time_class, collapse = "', '"),
      "'."
    )
  }

  time_keywords <- utils_time_keywords(
    tsl = tsl
  )

  breaks_type <- utils_time_breaks_type(
    breaks = breaks,
    keywords = time_keywords
  )

  #time units
  time_units <- utils_time_units(
    all_columns = TRUE,
    class = time_class
  )

  time_units <- time_units[
    time_units$units %in% time_keywords,
  ]

  #breaks class

  #breaks length is 1, convert to vector
  if(length(breaks) == 1){

    #breaks is a keyword
    if(breaks %in% time_keywords){

      #subset time units
      time_units <- time_units[
        time_units$units == breaks,
      ]

      #if non-standard keyword
      #round dates and convert to vector
      if(unique(time_units$keyword) == FALSE){

        if(time_class == "numeric"){

          breaks <- seq(
            from = floor(min(time_df$begin)),
            to = ceiling(max(time_df$end)),
            by = time_units$factor
          )

          breaks <- pretty(
            x = breaks,
            n = length(breaks)
          )

        }

        unit <- paste0(time_units$factor, " years")

        breaks <- seq.Date(
          from = lubridate::floor_date(
            x = min(time_df$begin),
            unit = unit
          ),
          to = lubridate::ceiling_date(
            x = max(time_df$end),
            unit = unit
          ),
          by = unit
        )

        if(time_class == "POSIXct"){

          breaks <- as.POSIXct(x = breaks)

        }

      } else {

        if(time_class == "Date"){

          breaks <- seq.Date(
            from = floor(min(time_df$begin)),
            to = ceiling(max(time_df$end)),
            by = breaks
          )

        }

        if(time_class == "POSIXct"){

          breaks <- seq.POSIXt(
            from = floor(min(time_df$begin)),
            to = ceiling(max(time_df$end)),
            by = breaks
          )

        }

      } #END of if(time_units$keyword == FALSE){

    } else {

      #breaks must be numeric

      if(!is.numeric(breaks)){

        stop(
          "Argument 'breaks' must be:\n - a vector of class '",
          time_df$class[1],
          ".\n - a valid keyword: '",
          paste0(time_keywords, collapse = "', '"),
          "'.\n - a number of ",
          time_df$units[1],
          " higher than ",
          min(time_units$threshold),
          "'.",
          call. = FALSE
        )

      }

      breaks <- seq(
        from = floor(min(time_df$begin)),
        to = ceiling(max(time_df$end)),
        by = breaks
      )

      breaks <- pretty(
        x = breaks,
        n = length(breaks)
      )

    } #END of if(breaks %in% time_units$units){

  } #END of if(length(breaks) == 1){

  breaks

}



