#' Time Units of a Zoo Time Series
#'
#' @param x (required, zoo object) time series with an index of the classes "Date". "POSIXct". or "numeric".
#'
#' @return Character vector of unit names.
#' @export
#' @autoglobal
#' @examples
zoo_time_units <- function(x){

  time_class <- class(stats::time(x))

  if("POSIXct" %in% time_class){
    time_class <- "POSIXct"
  }

  time_units <- utils_time_units(
    all_columns = TRUE,
    class = time_class
  )

  time_units$select <- lapply(
    X = time_units$expression,
    FUN = function(y){
      eval(parse(text = y))
    }
  ) |>
    unlist()

  time_units_head <- utils::head(
    x = time_units[time_units$select == TRUE, "units"],
    n = 1
  )

  time_units_tail <- utils::tail(
    x = time_units[time_units$select == TRUE, "units"],
    n = 1
  )

  time_units$units[
    seq(
      from = which(time_units$units == time_units_head),
      to = which(time_units$units == time_units_tail),
      by = 1
    )
  ]

}
