utils_time_breaks <- function(
    tsl = NULL,
    breaks = NULL
){

  # data("covid")
  #
  # tsl <- tsl_initialize(
  #   x = covid,
  #   id_column = "county",
  #   time_column = "date"
  # )

  tsl <- tsl_simulate()
  tsl <- tsl_simulate(
    time_range = c(-123120, 1200)
  )
  tsl <- tsl_simulate(
    time_range = c("2022-03-17 12:30:45", "2024-02-05 11:15:45")
  )

  as.POSIXct("2024-03-17 12:30:45")

  tsl <- tsl_is_valid(
    tsl = tsl
  )

  #gather tsl time features
  tsl_time <- tsl_time_summary(
    tsl = tsl
  )

  #units data frame
  tsl_time_units <- utils_time_units(
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


}
