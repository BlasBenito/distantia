utils_time_breaks <- function(
    tsl = NULL,
    breaks = NULL
){

  #EXAMPLES
  ########################################

  #Date
  tsl <- tsl_simulate(
    time_range = c(
      "0100-01-01",
      "2024-12-31"
    )
  )

  breaks <- "millennium"
  breaks <- "century"
  breaks <- "decade"
  breaks <- "year"
  breaks <- "quarter"
  breaks <- "month"
  breaks <- "week"
  breaks <- c(
    "0150-01-01",
    "1500-12-02",
    "1800-12-02",
    "2000-01-02"
  )

  #POSIXct
  tsl <- tsl_simulate(
    time_range = c(
      "0100-01-01 12:00:25",
      "2024-12-31 11:15:45"
    )
  )

  breaks <- "millennium"
  breaks <- "century"
  breaks <- "decade"
  breaks <- "year"
  breaks <- "quarter"
  breaks <- "month"
  breaks <- "week"
  breaks <- "hour"
  breaks <- c(
    "0150-01-01",
    "1500-12-02",
    "1800-12-02",
    "2000-01-02"
  )


  #numeric
  tsl <- tsl_simulate(
    time_range = c(-123120, 1200)
  )

  breaks <- 1000
  breaks <- 100
  #######################################

  tsl <- tsl_is_valid(
    tsl = tsl
  )

  tsl_time <- tsl_time_summary(
    tsl = tsl
  )

  time_units <- utils_time_units(
    all_columns = TRUE,
    class = tsl_time$class
  )

  #remove data resolution
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

        unit <- paste0(time_units$factor, " years")

        tsl_time$range <- as.Date(tsl_time$range)

        breaks <- seq.Date(
          from = lubridate::round_date(
            min(tsl_time$range),
            unit = unit
          ),
          to = lubridate::round_date(
            max(tsl_time$range),
            unit = unit
          ),
          by = unit
        )

      } else {

        if("Date" %in% class(tsl_time$range)){

          breaks <- seq.Date(
            from = min(tsl_time$range),
            to = max(tsl_time$range),
            by = breaks
          )

        }

        if("POSIXct" %in% class(tsl_time$range)){
          breaks <- seq.POSIXt(
            from = min(tsl_time$range),
            to = max(tsl_time$range),
            by = breaks
          )

        }

      } #END of if(time_units$keyword == FALSE){

    } #END of if(breaks %in% time_units$units){

  } #END of if(length(breaks) == 1){


#
#       else {
#
#         if(tsl_time$class == "Date"){
#
#           breaks <- seq.Date(
#             from = min(tsl_time$range),
#             to = max(tsl_time$range),
#             by = breaks
#           )
#
#         }
#
#         if(tsl_time$class == "POSIXct"){
#
#           breaks <- seq.POSIXt(
#             from = as.POSIXct(min(tsl_time$range)),
#             to = as.POSIXct(max(tsl_time$range)),
#             by = breaks
#           )
#
#         }
#
#       }
#
#
#
#     } else {
#
#       #breaks from time interval
#       breaks <- seq(
#         from = min(tsl_time$range),
#         to = max(tsl_time$range),
#         by = breaks
#       )
#
#     }
#
#     #pretty breaks
#     breaks <- pretty(
#       x = breaks,
#       n = length(breaks)
#     )
#
#   } #end of if(length(breaks) == 1){
#
#   breaks <- utils_as_time(
#     x = breaks
#   ) |>
#     suppressWarnings()
#
#
#

}



