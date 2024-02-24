#' Get Names of a Time Series List
#'
#' @description
#'
#' A list of zoo objects created with [ts_initialize()] has two sets of names that should ideally be the same: the list names, accessed with `names(x)`, and the names of the individual zoo objects (stored in their attribute "name"), accessed with `ts_get_names(x)`.
#'
#' @param x (required, zoo time series or time series list) Individual time series or time series list created with [ts_initialize]. Default: NULL
#'
#' @return Character vector of names.
#' @export
#'
#' @examples
ts_get_names <- function(
    x = NULL
){

  if(ts_is_valid(x = x) == TRUE){

    x.names <- lapply(
      X = x,
      FUN = function(x){
        attributes(x)$name
      }
    ) |>
      unlist()

  } else if (inherits(x = x, what = "zoo") == TRUE){

    x.names <- attributes(x)$name

  } else {

    stop("Argument 'x' must be either a time series list created with ts_initialize() or a zoo time series.")

  }

  names(x.names) <- NULL

  x.names

}


#' Set Names of a Time Series List
#'
#' @description
#' Sets the names of a time series list created with [ts_initialize()] and the internal names of the zoo objects inside, stored in their attribute "name".
#'
#'
#' @param x (required, list of zoo objects) List of time series. Default: NULL
#' @param names (optional, character vector) names to set. Must be of the same length of `x`. If NULL, and the list `x` has names, then the names of the zoo objects inside of the list are taken from the names of the list elements.
#'
#' @return
#' @export
#'
#' @examples
ts_set_names <- function(
    x = NULL,
    names = NULL
){

  if(inherits(x = x, what = "list")){

    if(is.null(names)){
      names <- names(x)
    }

    if(length(names) != length(x)){
      stop("Arguments 'x' and 'names' must have the same length.")
    }

    x <- Map(
      f = function(y, name) {
        attr(x = y, which = "name") <- name
        y
      },
      x,
      names
    )

    names(x) <- names


  } else if (inherits(x = x, what = "zoo") == TRUE){

    if(is.null(names) || length(names) != 1){
      stop("Argument 'names' must be a character string.")
    }

    attributes(x)$name <- names

  } else {

    stop("Argument 'x' must be either a time series list created with ts_initialize() or a zoo time series.")

  }

  x

}
