#' Time Summary of a Time Series List
#'
#' @param tsl (required, list of zoo objects) Time series list. Default: NULL
#'
#' @return List with class, range, units, and resolution of the time in `tsl`.
#' @export
#' @autoglobal
#' @examples
tsl_time_summary <- function(
    tsl = NULL
){

  tsl <- tsl_is_valid(
    tsl = tsl
  )

  time_class <- tsl_time_class(
    tsl = tsl
  )

  if(is.list(time_class)){
    time_class <- do.call(
      what = "c",
      args = time_class
    )
  }


  time_units <- tsl_time_units(
    tsl = tsl
  )

  if(is.list(time_units)){
    time_units <- do.call(
      what = "c",
      args = time_units
    ) |>
      unique()
  }

  time_range <- tsl_time_range(
    tsl = tsl
  )

  if(is.list(time_range)){
    time_range <- do.call(
      what = "c",
      args = time_range
    )
  }

  list(
    class = time_class,
    range = range(time_range),
    units = time_units,
    resolution = tail(time_units, n = 1)
  )

}
