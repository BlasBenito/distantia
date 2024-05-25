#' Converts Between Classes Date and POSIXct
#'
#' @param x (required, vector of class Date or POSIXct) time vector to convert. Default: NULL
#' @param to (required, class name) either Date, POSIXct, or numeric. Default: Date
#'
#' @return time vector
#' @export
#' @autoglobal
#' @examples
utils_coerce_time_class <- function(
    x = NULL,
    to = "Date"
){

  classes <- c("POSIXct", "Date", "numeric")

  if(!(to %in% classes)){
    stop(
      "Argument 'to' must be one of '",
      paste(classes, collapse = "', '"),
      "'."
      )
  }

  if(is.character(x)){
    x <- x |>
      utils_as_time() |>
      suppressWarnings()
  }

  if(!(class(x) %in% classes)){
    return(x)
  }

  if(to == "POSIXct"){

    if("Date" %in% class(x)){

      x <- as.POSIXct(x)

    }

  }

  if(to == "Date"){

    if("POSIXct" %in% class(x)){

      x <- format(
        x = x,
        format = "%Y-%m-%d"
      )

      x <- as.Date(x)

    }

  }

  if(to == "numeric"){

    x <- as.numeric(x)

  }

  x

}
