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

  tsl_time <- tsl_time_summary(
    tsl = tsl
  )

  #time units data frame
  time_units <- utils_time_units(
    all_columns = TRUE,
    class = tsl_time$class
  )

  #subset valid units
  time_units <- time_units[
    time_units$units %in% tsl_time$units,
  ]

  #remove data resolution to get valid time units
  time_units <- time_units[
    time_units$units != tsl_time$resolution,
  ]

  #breaks length is 1, convert to vector
  if(length(breaks) == 1){

    #breaks is a keyword
    if(breaks %in% time_units$units){

      #subset time units
      time_units <- time_units[
        time_units$units == breaks,
      ]

      #if invalid keyword, round dates and convert to vector
      if(time_units$keyword == FALSE){

        if(tsl_time$class == "numeric"){

          breaks_tail <- time_units$factor / 10

          breaks <- seq(
            from = min(tsl_time$range) - breaks_tail,
            to = max(tsl_time$range) + breaks_tail,
            by = time_units$factor
          )

        } else {

          unit <- paste0(time_units$factor, " years")

          tsl_time$range <- as.Date(tsl_time$range)

          breaks <- seq.Date(
            from = lubridate::round_date(
              min(tsl_time$range) - 1,
              unit = unit
            ),
            to = lubridate::round_date(
              max(tsl_time$range) + 1,
              unit = unit
            ),
            by = unit
          )


        }


      } else {

        if("Date" %in% class(tsl_time$range)){

          breaks <- seq.Date(
            from = min(tsl_time$range) - 1,
            to = max(tsl_time$range) + 1,
            by = breaks
          )

        }

        if("POSIXct" %in% class(tsl_time$range)){
          breaks <- seq.POSIXt(
            from = min(tsl_time$range) - 1,
            to = max(tsl_time$range) + 1,
            by = breaks
          )

        }

      } #END of if(time_units$keyword == FALSE){

    } else {

      #breaks must be numeric

      if(!is.numeric(breaks)){
        stop("Argument 'breaks' must be of the classes Date, POSIXct, or numeric.")
      }

      breaks_tail <- breaks / 10

      breaks <- seq(
        from = min(tsl_time$range) - breaks_tail,
        to = max(tsl_time$range) + breaks_tail,
        by = breaks
      )

    } #END of if(breaks %in% time_units$units){

  } #END of if(length(breaks) == 1){

  breaks <- utils_as_time(x = breaks)

  breaks

}



