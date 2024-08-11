#' Clean Names
#'
#' Clean and format character vectors for use as column names or variable names.
#'
#' The cleanup operations are applied in the following order:
#' \itemize{
#'   \item Remove leading and trailing whitespaces.
#'   \item Generates syntactically valid names with [base::make.names()].
#'   \item Replaces dots and spaces with the `separator`.
#'   \item Coerces names to lowercase.
#'   \item If `capitalize_first = TRUE`, the first letter is capitalized.
#'   \item If `capitalize_all = TRUE`, all letters are capitalized.
#'   \item If argument `length` is provided, [base::abbreviate()] is used to abbreviate the new column names.
#'   \item If `suffix` is provided, it is added at the end of the column name using the separator.
#'   \item If `prefix` is provided, it is added at the beginning of the column name using the separator.
#' }
#'
#' @param x (required, character vector) Names to be cleaned. Default: NULL
#' @param separator (optional, character string) Separator when replacing spaces and dots. Also used to separate `suffix` and `prefix` from the main word. Default: "_".
#' @param capitalize_first (optional, logical) Indicates whether to capitalize the first letter of each name Default: FALSE.
#' @param capitalize_all (optional, logical) Indicates whether to capitalize all letters of each name Default: FALSE.
#' @param length (optional, integer) Minimum length of abbreviated names. Names are abbreviated via [abbreviate()]. Default: NULL.
#' @param suffix (optional, character string) String to append to the cleaned names. Default: NULL.
#' @param prefix (optional, character string)  String to prepend to the cleaned names. Default: NULL.
#'
#' @return Character vector.
#'
#' @examples
#'
#' utils_clean_names(names = c("Column Name 1", "column.name.2"), capitalize_first = TRUE)
#'
#' utils_clean_names(names = c("Column Name 1", "column.name.2"), capitalize_all = TRUE)
#' @autoglobal
#' @export
utils_clean_names <- function(
    x = NULL,
    separator = "_",
    capitalize_first = FALSE,
    capitalize_all = FALSE,
    length = NULL,
    suffix = NULL,
    prefix = NULL
){

  if(!is.character(x)){
    stop("Input 'names' must be a character vector.")
  }

  if(anyNA(x)){
    stop("Input 'names' contains missing values.")
  }

  x.old <- x

  #remove leading/trailing whitespaces
  x <- trimws(
    x = x,
    which = "both"
  )

  #generic R style clean-up
  x <- make.names(
    names = x,
    unique = TRUE
  )

  #dots and spaces to underscore
  x <- gsub(
    pattern = "\\s+|\\.{1,}",
    replacement = separator,
    x = x
  )

  #to lowercase
  x <- tolower(x)

  #first letter to uppercase
  if(capitalize_first == TRUE){

    x <- paste0(
      toupper(
        substr(
          x = x,
          start = 1,
          stop = 1
        )
      ),
      substr(
        x = x,
        start = 2,
        stop = nchar(x)
      )
    )

  }

  #all letters to uppercase
  if(capitalize_all == TRUE){

    x <- toupper(x)

  }

  #abbreviate
  if(is.numeric(length)){

    x <- abbreviate(
      names.arg = x,
      minlength = as.integer(length),
      method = "both.sides",
      named = FALSE
    )

  }

  #prefix and suffix
  if(!is.null(suffix)) {
    x <- paste(
      x,
      suffix,
      sep = separator
    )
  }

  # prefix
  if(!is.null(prefix)) {
    x <- paste(
      prefix,
      x,
      sep = separator
    )
  }

  names(x) <- x.old

  x

}
