#' Time Breaks for Time Series Aggregation
#'
#' @param tsl (required, list of zoo objects) List of time series. Default: NULL
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

  time_df <- tsl_time(
    tsl = tsl,
    keywords = TRUE
  )

  keywords <- time_df$keywords |>
    unlist() |>
    unique()

  time_units <- utils_time_units(
    all_columns = TRUE,
    class = time_df$class[1]
  )

  #subset valid units
  time_units <- time_units[
    time_units$units %in% keywords,
  ]

  #breaks length is 1, convert to vector
  if(length(breaks) == 1){

    #breaks is a keyword
    if(breaks %in% keywords){

      #subset time units
      time_units <- time_units[
        time_units$units == breaks,
      ]

      #if invalid keyword, round dates and convert to vector
      if(time_units$keyword == FALSE){

        if(all(time_df$class == "numeric")){

          breaks <- seq(
            from = min(time_df$begin) + time_units$factor,
            to = max(time_df$end) - time_units$factor,
            by = time_units$factor
          )

          breaks <- pretty(
            x = breaks,
            n = length(breaks)
          )

        } else {

          #TODO: does not work for POSIXct
          unit <- paste0(time_units$factor, " years")

          breaks <- seq.Date(
            from = lubridate::round_date(
              min(time_df$begin),
              unit = unit
            ),
            to = lubridate::round_date(
              max(time_df$end),
              unit = unit
            ),
            by = unit
          )

        }


      } else {

        if(all(time_df$class == "Date")){

          breaks <- seq.Date(
            from = min(time_df$begin),
            to = max(time_df$end),
            by = breaks
          )

        }

        if(all(time_df$class == "POSIXct")){
          breaks <- seq.POSIXt(
            from = min(time_df$begin),
            to = max(time_df$end),
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
          "'.\n - a number of ",
          time_df$units[1],
          " higher than ",
          min(time_units$threshold),
          ".\n - a valid keyword: '",
          paste0(keywords, collapse = "', '"),
          "'."
          )
      }

      breaks <- seq(
        from = min(time_df$begin) + breaks,
        to = max(time_df$end) - breaks,
        by = breaks
      )

      breaks <- pretty(
        x = breaks,
        n = length(breaks)
      )

    } #END of if(breaks %in% time_units$units){

  } #END of if(length(breaks) == 1){

  #subset breaks
  breaks <- breaks[
    breaks > min(time_df$begin) &
      breaks < max(time_df$end)
  ]

  #convert to time
  breaks <- utils_as_time(x = breaks)

  breaks

}



