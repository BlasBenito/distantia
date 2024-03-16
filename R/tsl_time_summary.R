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

  tsl_units <- tsl_time_units(
    tsl = tsl
  ) |>
    unlist() |>
    unique()

  list(
    class = tsl_time_class(
      tsl = tsl
    ) |>
      unlist() |>
      unique(),
    range = tsl_time_range(
      tsl = tsl
    ) |>
      unlist() |>
      unique() |>
      range(),
    units = tsl_units,
    resolution = tail(time_units, n = 1)
  )

}
