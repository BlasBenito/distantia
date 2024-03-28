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

  # class
  time_class <- tsl_time_class(
    tsl = tsl
  )

  if(all(names(tsl) %in% names(time_class))){
    time_class <- do.call(
      what = "c",
      args = time_class
    )
  }

  #range
  time_range <- tsl_time_range(
    tsl = tsl
  )

  if(all(names(tsl) %in% names(time_range))){
    time_range <- do.call(
      what = "c",
      args = time_range
    ) |>
      range()
  }

  #resolution
  time_resolution <- tsl_time_resolution(
    tsl = tsl
  )

  if(all(names(tsl) %in% names(time_resolution))){

    unique_resolution_units <- sapply(
      X = time_resolution,
      FUN = function(x){
        x$units
      }
    ) |>
      unique()

    if(length(unique_resolution_units) == 1){

      time_resolution <- list(
        resolution = sapply(
          X = time_resolution,
          FUN = function(x){
            x$resolution
          }
        ) |>
          mean(),
        units = unique_resolution_units
      )

    }

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



  if(time_class == "numeric"){
    time_units <- as.numeric(time_units)
  }

  list(
    class = time_class,
    range = time_range,
    units = time_units,
    resolution = tail(time_units, n = 1)
  )

}
