#' Get Names of a Time Series List
#'
#' @description
#'
#' A list of zoo objects created with [tsl_initialize()] has two sets of names that should ideally be the same: the list names, accessed with `names(tsl)`, and the names of the individual zoo objects (stored in their attribute "name"), accessed with `tsl_names(x)`.
#'
#' @param tsl (required, time series list) Individual time series or time series list created with [tsl_initialize]. Default: NULL
#' @param test_valid (optional, logical) If FALSE, the validity test performed by [tsl_is_valid()] is ignored. Useful to improve performance when the user knows that `tsl` is valid. Default: TRUE
#' @return Character vector of names.
#' @export
#'
#' @examples
tsl_names <- function(
    tsl = NULL,
    test_valid = TRUE
){

  tsl <- tsl_is_valid(
    tsl = tsl,
    test_valid = test_valid
  )

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
#' @param test_valid (optional, logical) If FALSE, the validity test performed by [tsl_is_valid()] is ignored. Useful to improve performance when the user knows that `tsl` is valid. Default: TRUE
#'
#' @return time series list
#' @export
#'
#' @examples
tsl_set_names <- function(
    tsl = NULL,
    names = NULL,
    test_valid = TRUE
){

  tsl <- tsl_is_valid(
    tsl = tsl,
    test_valid = test_valid
  )

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
