#' Coerces Vector to a Given Time Class
#'
#' @param x (required, vector of class Date or POSIXct) time vector to convert. Default: NULL
#' @param to (required, class name) either Date, POSIXct, or numeric. Default: Date
#'
#' @return time vector
#' @export
#' @autoglobal
#' @examples
#' x <- utils_coerce_time_class(
#'   x = c("2024-01-01", "2024-02-01"),
#'   to = "Date"
#' )
#'
#' x
#' class(x)
#'
#' x <- utils_coerce_time_class(
#'   x = c("2024-01-01", "2024-02-01"),
#'   to = "POSIXct"
#' )
#'
#' x
#' class(x)
#'
#' x <- utils_coerce_time_class(
#'   x = c("2024-01-01", "2024-02-01"),
#'   to = "numeric"
#' )
#'
#' x
#' class(x)
#' @keywords internal
#' @concept time_handling
utils_coerce_time_class <- function(
    x = NULL,
    to = "Date"
){

  classes <- c("POSIXct", "Date", "numeric", "integer")

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

  if(any(class(x) %in% classes) == FALSE){
    warning(
      "Class of argument 'x' must be one of '",
      paste(classes, collapse = "', '"),
    "'."
    )
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

  if(to == "integer"){

    x <- as.integer(x)
  }

  x

}
