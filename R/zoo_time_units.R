#' Time Units of a Zoo Time Series
#'
#' @param x (required, zoo object) time series with an index of the classes "Date". "POSIXct". or "numeric".
#'
#' @return Character vector of unit names.
#' @export
#' @autoglobal
#' @examples
zoo_time_units <- function(x){

  #dev examples
  x <- zoo_simulate(
    time_range = c(
      "0100-02-08",
      "2024-12-31"
    )
  )

  x <- zoo_simulate(
    time_range = c(
      "2024-12-20 10:00:25",
      "2024-12-31 11:15:45"
    )
  )

  x <- zoo_simulate(
    time_range = c(-123120, 1200)
  )

  x <- zoo_simulate(
    time_range = c(0.01, 0.09)
  )
  ##########################


  time_class <- zoo_time_class(
    x = x
  )

  time_range <- zoo_time_range(
    x = x
  )

  time_resolution <- zoo_time_resolution(
    x = x
  )

  time_units <- utils_time_units(
    all_columns = TRUE,
    class = time_class
  )

  time_units <- time_units[time_units$base_units == time_resolution$units, ]

  if(nrow(time_units) > 1){

    time_units$select_range <-
      as.numeric(diff(time_range)) > time_units$threshold

    time_units$select_resolution <-
      time_resolution$resolution > time_units$threshold

    time_units_head <- utils::head(
      x = time_units[time_units$select_range == TRUE, "units"],
      n = 1
    )

    time_units_tail <- utils::head(
      x = time_units[time_units$select_resolution == TRUE, "units"],
      n = 1
    )

    time_units <- time_units[
      seq(
        from = which(time_units$units == time_units_head),
        to = which(time_units$units == time_units_tail),
        by = 1
      ),

    ]

  }

  time_units$units

}
