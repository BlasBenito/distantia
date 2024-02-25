#' Column Names of a Time Series List
#'
#' @param tsl (required, time series list) Default: NULL
#' @param common (optional, logical). If TRUE, only common column names to all time-series in `tsl` are returned as a character vector. If FALSE, a list with the column names of each time series is returned. Default: FALSE
#'
#' @return List if `common = FALSE`, character vector if `common = TRUE`.
#' @export
#' @autoglobal
#' @examples
tsl_colnames <- function(
    tsl = NULL,
    common = FALSE
){

  colnames <- lapply(
    X = tsl,
    FUN = colnames
  )

  if(common == TRUE){

    colnames.table <- colnames |>
      unlist() |>
      table()

    colnames <- colnames.table[colnames.table == length(tsl)] |>
      names()

  }

  colnames

}


#' Get Names of a Time Series List
#'
#' @description
#'
#' A list of zoo objects created with [tsl_initialize()] has two sets of names that should ideally be the same: the list names, accessed with `names(x)`, and the names of the individual zoo objects (stored in their attribute "name"), accessed with `tsl_get_names(x)`.
#'
#' @param tsl (required, zoo time series or time series list) Individual time series or time series list created with [tsl_initialize]. Default: NULL
#'
#' @return Character vector of names.
#' @export
#'
#' @examples
tsl_names <- function(
    tsl = NULL
){

  if(tsl_is_valid(tsl = tsl) == TRUE){

    x.names <- lapply(
      X = tsl,
      FUN = function(x){
        attributes(x)$name
      }
    ) |>
      unlist()

  } else if (inherits(x = tsl, what = "zoo") == TRUE){

    x.names <- attributes(tsl)$name

  } else {

    stop("Argument 'x' must be either a time series list created with tsl_initialize() or a zoo time series.")

  }

  names(x.names) <- NULL

  x.names

}


#' Set Names of a Time Series List
#'
#' @description
#' Sets the names of a time series list created with [tsl_initialize()] and the internal names of the zoo objects inside, stored in their attribute "name".
#'
#'
#' @param tsl (required, list of zoo objects) List of time series. Default: NULL
#' @param names (optional, character vector) names to set. Must be of the same length of `x`. If NULL, and the list `x` has names, then the names of the zoo objects inside of the list are taken from the names of the list elements.
#' @param clean (optional, logical) If TRUE, the names of `tsl` and the ones in `names` (if provided) are cleaned via [clean_names()].
#' @param abbreviate (optional, integer)
#'
#' @return
#' @export
#'
#' @examples
tsl_set_names <- function(
    tsl = NULL,
    names = NULL
){

  if(inherits(x = tsl, what = "list")){

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


  } else if (zoo::is.zoo(tsl)){

    if(is.null(names) || length(names) != 1){
      stop("Argument 'names' must be a character string.")
    }

    attributes(tsl)$name <- names

  } else {

    stop("Argument 'x' must be either a time series list created with tsl_initialize() or a zoo time series.")

  }

  tsl

}


#' Clean Names
#'
#' @description
#' Generic function to clean time series names and column names.
#'
#'
#' @param names (required, character vector) names to clean. Default: NULL
#' @param first_to_upper (optional, logical) If TRUE, the first letter is set to upper case. Default: FALSE
#' @param length (optional, integer) If provided, names are abbreviated to this length via [abbreviate()].
#'
#' @return Character vector
#' @export
#' @autoglobal
#' @examples
#'
#' names(mis)
#'
#' clean_names(
#'   names = names(mis),
#'   length = 3
#' )
#'
clean_names <- function(
    names = NULL,
    first_to_upper = FALSE,
    length = NULL
){


  #make valid and unique
  names <- make.names(
    names = names,
    unique = TRUE
  )

  #replace dots
  names <- gsub(
    pattern = "\\.{1,}",
    replacement = "_",
    x = names
  )

  #remove uppercase
  names <- tolower(names)

  #first to upper
  if(first_to_upper){

    names <- paste0(
      toupper(substr(names, 1, 1)),
      substr(names, 2, nchar(names))
    )

  }

  #abbreviate
  if(is.numeric(length)){

    names <- abbreviate(
      names.arg = names,
      minlength = as.integer(length[1]),
      method = "left.kept",
      named = FALSE
    )

  }

  names

}
