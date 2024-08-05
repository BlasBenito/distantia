#' Get Names of a Time Series List
#'
#' @description
#'
#' A list of zoo objects created with [tsl_initialize()] has two sets of names that should ideally be the same: the list names, accessed with `names(tsl)`, and the names of the individual zoo objects (stored in their attribute "name"), accessed with `tsl_names(x)`.
#'
#' @param tsl (required, time series list) Individual time series or time series list created with [tsl_initialize]. Default: NULL
#' @return Character vector of names.
#' @export
#'
#' @examples
#' TODO: complete example
tsl_names <- function(
    tsl = NULL
){

  tsl.names <- lapply(
    X = tsl,
    FUN = function(x){
      attributes(x)$name
    }
  ) |>
    unlist()

  names(tsl.names) <- NULL

  tsl.names

}


#' Set Names of a Time Series List
#'
#' @description
#' Sets the names of a time series list created with [tsl_initialize()] and the internal names of the zoo objects inside, stored in their attribute "name".
#'
#'
#' @param tsl (required, time series list) Individual time series or time series list created with [tsl_initialize]. Default: NULL
#' @param names (optional, character vector) names to set. Must be of the same length of `x`. If NULL, and the list `x` has names, then the names of the zoo objects inside of the list are taken from the names of the list elements.
#'
#' @return time series list
#' @export
#'
#' @examples
#' TODO add example
tsl_names_set <- function(
    tsl = NULL,
    names = NULL
){

  if(is.null(names)){
    names <- names(tsl)
  }

  if(length(names) != length(tsl)){
    stop("Arguments 'x' and 'names' must have the same length.")
  }

  tsl <- Map(
    f = function(y, name) {
      attr(x = y, which = "name") <- name
      y
    },
    tsl,
    names
  )

  names(tsl) <- names

  tsl

}

#' Clean Names of a Time Series List
#'
#'
#' @param tsl (required, time series list) Individual time series or time series list created with [tsl_initialize]. Default: NULL
#' @param separator (optional, character string) Separator when replacing spaces and dots. Also used to separate `suffix` and `prefix` from the main word. Default: "_".
#' @param capitalize_first (optional, logical) Indicates whether to capitalize the first letter of each name Default: FALSE.
#' @param capitalize_all (optional, logical) Indicates whether to capitalize all letters of each name Default: FALSE.
#' @param length (optional, integer) Minimum length of abbreviated names. Names are abbreviated via [abbreviate()]. Default: NULL.
#' @param suffix (optional, character string) String to append to the cleaned names. Default: NULL.
#' @param prefix (optional, character string)  String to prepend to the cleaned names. Default: NULL.
#'
#' @return Time series list with clean names
#'
#' @examples
#' TODO add example
#' @autoglobal
#' @export
tsl_names_clean <- function(
    tsl = NULL,
    separator = "_",
    capitalize_first = FALSE,
    capitalize_all = FALSE,
    length = NULL,
    suffix = NULL,
    prefix = NULL
){

  tsl.names <- tsl_names(
    tsl = tsl
  )

  tsl.names <- utils_clean_names(
    x = tsl_names,
    separator = separator,
    capitalize_first = capitalize_first,
    capitalize_all = capitalize_all,
    length = length,
    suffix = suffix,
    prefix = prefix
  )

  names(tsl.names) <- NULL

  tsl <- tsl_names_set(
    tsl = tsl,
    names = tsl.names
  )

  tsl


}
