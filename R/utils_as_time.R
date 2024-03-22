# The default formats follow the rules of the ISO 8601 international standard which expresses a day as "2001-02-03".

#' Ensures Correct Class for Time Arguments
#'
#' This function guesses the class of a vector based on its elements. It can handle numeric vectors, character vectors that can be coerced to either "Date" or "POSIXct" classes, and vectors already in "Date" or "POSIXct" classes.
#'
#' @param x (required, vector) Vectors of the classes 'numeric', 'Date', and 'POSIXct' are valid and returned without any transformation. Character vectors are analyzed to determine their more probable type, and are coerced to 'Date' or 'POSIXct' depending on their number of elements. Generally, any character vector representing an ISO 8601 standard, like "YYYY-MM-DD" or "YYYY-MM-DD HH:MM:SS" will be converted to a valid class. Additionally, character vectors representing a year (i.e. `c("2010", "2011")`) or a year and a month (i.e. `c("2010-02", "2011-03")`) will be added month and day ("-01" in either case) and coerced to 'Date'. If a character vector cannot be coerced to date, it is returned as is. Default: NULL
#'
#' @param quiet (optional, logical) If TRUE, all messages are suppressed. Default is TRUE
#'
#' @return Input vector if its class is 'numeric', 'Date', or 'POSIXct', or input vector coerced to one of these classes otherwise.
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
utils_as_time <- function(
    x = NULL,
    quiet = TRUE
){

  #exaples of x to guide development
  # x <- c("2021", "2022")
  # x <- c("2021-02, "2022-01")
  # x <- c("2021/02", "2022/01")
  # x <- c("2022-03-17 12:30:45", "2024-02-05 11:15:45")
  # x <- c("2022-03-17", "2024-02-05 11:15:45")
  # x <- c(-123120, 1200)
  # x <- as.Date(c("2022-03-17", "2024-02-05"))
  # x <- as.POSIXct(c("2022-03-17 12:30:45", "2024-02-05 11:15:45"))
  # x <- c("2022-03-17", "2024-02-05")

  #valid time class
  time_class <- sapply(
    X = x,
    FUN = class
  ) |>
    unique()

  #x is valid time class
  if(time_class %in% c(
    "numeric",
    "Date",
    "POSIXct"
  )){
    if(quiet == FALSE){
      message(
        "Time class is '",
        time_class,
        "'."
      )
    }
    return(x)
  }


  # x is character
  if(time_class == "character"){

    #space to hyphen
    x <- gsub(
      pattern = " ",
      replacement = "-",
      x = x
    )

    #slash to hyphen
    x <- gsub(
      pattern = "/",
      replacement = "-",
      x = x
    )

    #count characters
    x_nchar <- sapply(
      X = x,
      FUN = nchar
    ) |>
      max()

    #four characters, it might be a year? weird, but whatever
    if(x_nchar == 4){

      #can be coerced to numeric?
      x_numeric <- as.numeric(x) |>
        suppressWarnings()

      #it's a year?
      if(is.na(x_numeric)){

        if(quiet == FALSE){
          message(
            "Argument 'x' cannot be coerced to a valid time class."
          )
        }

        return(x)

      }

      if(quiet == FALSE){
        message(
          "Adding month and day '-01-01' to YYYY string."
        )
      }

      x <- paste0(
        x,
        "-01-01"
      )

    }

    #there are hyphens
    if(grepl(pattern = "-", x = x) == TRUE){

      #seven characters and a hypen, YYYY-MM, add -01
      if(x_nchar == 7){

        if(quiet == FALSE){
          message(
            "Adding day '-01' to YYYY-MM string."
          )
        }

        x <- paste0(
          x,
          "-01"
        )

      }

      #10 characters and hyphen
      if(x_nchar <= 10){

        if(quiet == FALSE){
          message(
            "Coercing to Date class with format '%Y-%m-%d'."
          )
        }

        x <- as.Date(
          x = x,
          format = "%Y-%m-%d"
        )

      } else {

        if(quiet == FALSE){
          message("Coercing to POSIXct class with format '%Y-%m-%d %H:%M:%S'.")
        }

        x <- as.POSIXct(
          x = x,
          format = "%Y-%m-%d %H:%M:%S"
        )

      }
    }
  }

  x

}
