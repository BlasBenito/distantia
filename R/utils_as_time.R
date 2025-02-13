# The default formats follow the rules of the ISO 8601 international standard which expresses a day as "2001-02-03".

#' Ensures Correct Class for Time Arguments
#'
#' This function guesses the class of a vector based on its elements. It can handle numeric vectors, character vectors that can be coerced to either "Date" or "POSIXct" classes, and vectors already in "Date" or "POSIXct" classes.
#'
#' @param x (required, vector) Vectors of the classes 'numeric', 'Date', and 'POSIXct' are valid and returned without any transformation. Character vectors are analyzed to determine their more probable type, and are coerced to 'Date' or 'POSIXct' depending on their number of elements. Generally, any character vector representing an ISO 8601 standard, like "YYYY-MM-DD" or "YYYY-MM-DD HH:MM:SS" will be converted to a valid class. If a character vector cannot be coerced to date, it is returned as is. Default: NULL
#' @param to_class (optional, class) Options are: NULL, "numeric", "Date", and "POSIXct". If NULL, 'x' is returned as the most appropriate time class. Otherwise, 'x' is coerced to the given class. Default: NULL
#'
#' @return time vector
#'
#' @examples
#' # numeric
#' utils_as_time(
#'   x = c(-123120, 1200)
#'   )
#'
#' # character string to Date
#' utils_as_time(
#'   x = c("2022-03-17", "2024-02-05")
#'   )
#'
#' # incomplete character strings to Date
#' utils_as_time(
#'   x = c("2022", "2024")
#'   )
#'
#' utils_as_time(
#'   x = c("2022-02", "2024-03")
#'   )
#'
#' # character string to POSIXct
#' utils_as_time(
#'   x = c("2022-03-17 12:30:45", "2024-02-05 11:15:45")
#'   )
#'
#' # Date vector (returns the input)
#' utils_as_time(
#'   x = as.Date(c("2022-03-17", "2024-02-05"))
#'   )
#'
#' # POSIXct vector (returns the input)
#' utils_as_time(
#'   x = as.POSIXct(c("2022-03-17 12:30:45", "2024-02-05 11:15:45"))
#'   )
#'
#' @export
#' @autoglobal
#' @family internal_time_handling
utils_as_time <- function(
    x = NULL,
    to_class = NULL
){


  if(is.null(to_class)){
    to_class <- ""
  }

  #x is valid time class
  if(utils_is_time(x) == TRUE){

    if(to_class == "Date"){
      x <- as.Date(x)
    }

    if(to_class == "POSIXct"){
      x <- as.POSIXct(x)
    }

    if(to_class == "numeric"){
      x <- as.numeric(x)
    }

    return(x)
  }

  #coerce factors to character
  if(is.factor(x)){
    x <- as.character(x)
  }

  #valid time class
  time_class <- sapply(
    X = x,
    FUN = base::class
  ) |>
    unique()

  # x is character
  if(time_class == "character"){

    #slash to hyphen
    x <- gsub(
      pattern = "/",
      replacement = "-",
      x = x
    )

    #count hyphens and colons
    x_hyphens <- lengths(
      regmatches(
        x = x,
        m = gregexpr(
          pattern = "-",
          text = x
          )
        )
      ) |>
      unique() |>
      max()


    x_colons <- lengths(
      regmatches(
        x = x,
        m = gregexpr(
          pattern = ":",
          text = x
        )
      )
    ) |>
      unique() |>
      max()

    #Date and POSIXct
    if(x_hyphens == 2){

      #POSIXct
      if(x_colons > 1){

        x <- as.POSIXct(
          x = x,
          tryFormats = c(
            "%Y-%m-%d %H:%M:%S",
            "%Y-%m-%d %H:%M:%OS",
            "%Y-%m-%d %H:%M"
          )
        )

      } else {

        #converting to Date
        x <- as.Date(
          x = x,
          format = "%Y-%m-%d"
        )

      }


    } else {

      warning(
        "Argument 'x' of class 'character' must have the format '%Y-%m-%d' for class 'Date', or '%Y-%m-%d %H:%M:%S' for class 'POSIXct'",
        call. = FALSE
      )

    }

  }

  if(to_class == "Date"){
    x <- as.Date(x)
  }

  if(to_class == "POSIXct"){
    x <- as.POSIXct(x)
  }

  if(to_class == "numeric"){
    x <- as.numeric(x)
  }

  x

}
