utils_time_breaks <- function(
    tsl = NULL,
    breaks = NULL
){


  # tsl <- tsl_simulate()
  # tsl <- tsl_simulate(
  #   time_range = c(-123120, 1200)
  # )
  # tsl <- tsl_simulate(
  #   time_range = c("2022-03-17 12:30:45", "2024-02-05 11:15:45")
  # )
  #examples of breaks
  # breaks <- "year"
  # breaks <- "quarter"
  # breaks <- "month"
  # breaks <- "week"
  # breaks <- 200
  # breaks <- 1000

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

  breaks <- utils_as_time(
    x = breaks,
    quiet = TRUE
  )

  #breaks is time
  if(class(breaks) == tsl_time$class){

    #breaks length is 1
    if(length(breaks) == 1){

      #breaks from time interval
      breaks <- seq(
        from = min(tsl_time$range),
        to = max(tsl_time$range),
        by = breaks
      )

      #pretty breaks
      breaks <- pretty(
        x = breaks,
        n = length(breaks)
      )

    }


  #breaks should be a keyword
  } else {

    #find breaks in units
    time_factor <- time_units[
      time_units$units %in% breaks,
      "factor"
    ]

  }


  #not in time_units
  if(length(time_factor) == 0){



  } else {


  }


}



