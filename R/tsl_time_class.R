#' Time Class of Time Series List
#'
#' @param tsl (required, list of zoo objects) List of time series. Default: NULL
#'
#' @return A list if each time series has a different range, and a character string with the class name otherwise.
#' @export
#' @examples
#' @autoglobal
tsl_time_class <- function(
    tsl = NULL
){

  tsl <- tsl_is_valid(
    tsl = tsl
  )

  time <- lapply(
    X = tsl,
    FUN = function(x){
      x_class <- class(stats::time(x))
      if("POSIXct" %in% x_class){
        x_class <- "POSIXct"
      }
      return(x_class)
    }
  )

  time_unique <- time |>
    unique()

  if(length(time_unique) == 1){
    time <- time_unique[[1]]
  } else {
    time <- time_unique
    warning(
      "The time class of all elements in 'tsl' must be the same. Having different time classes in a 'tsl' object might cause unintended issues in other functions of this package.",
      call. = FALSE
      )
  }

  time

}
