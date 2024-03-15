#' Checks Structure Validity of a Time Series List
#'
#' @description
#' Checks that the input argument is a valid time series list. The required features for a valid time series list are:
#' \itemize{
#'   \item Argument `tsl` is list.
#'   \item List `tsl` has unique names.
#'   \item List `tsl` has more than one element.
#'   \item All elements in `tsl` are "zoo" objects.
#'   \item All "zoo" objects have an attribute "name".
#'   \item All "zoo" objects have unique attributes "name".
#'   \item All "zoo" objects have at least one common column name.
#'   \item All "zoo" objects have zero NA cases.
#' }
#'
#'
#' @param tsl (required, time series list) Individual time series or time series list created with [tsl_initialize]. Default: NULL
#'
#' @return time series list or error.
#' @export
#' @autoglobal
#' @examples
tsl_is_valid <- function(
    tsl = NULL
    ){

  #check valid flag
  if("valid" %in% names(attributes(tsl))){
    if(attributes(tsl)$is_valid == TRUE){
      return(tsl)
    }
  }

  #tsl is a list
  if(!is.list(tsl)){

    stop("Argument 'tsl' must be a list.")

  }

  #is a named list
  if(is.null(names(tsl))){

    stop(
      "List 'tsl' must have names. The function distantia::tsl_names_set() may fix this issue."
    )

  }

  #is a named list
  if(any(duplicated(names(tsl)))){

    stop(
      "List 'tsl' must be unique names."
    )

  }

  #list with two elements
  if(length(tsl) < 2){

    stop(
      "List 'tsl' must have more than one zoo object"
    )

  }

  #elements in tsl must be zoo
  if(!all(sapply(X = tsl, FUN = zoo::is.zoo))){

    stop(
      "Objects in list 'tsl' must be of class 'zoo'. The function distantia::tsl_initialize() may fix this issue."
      )

  }

  #zoo objects are named
  zoo.names <- tsl_names(
    tsl = tsl
  )

  if(length(zoo.names) == 0){

    warning(
      "Zoo objects in  list'tsl' must have the attribute 'name'. The function distantia::tsl_names_set() may fix this issue.",
      call. = FALSE
    )

  }

  #unique zoo names
  if(any(duplicated(zoo.names))){

    warning(
      "Zoo objects in list 'tsl' must have unique attributes 'name'. The function distantia::tsl_names_set() may fix this issue.",
      call. = FALSE
    )

  }

  #common names
  shared.names <- tsl_colnames(
    tsl = tsl,
    names = "shared"
    )

  if(length(shared.names) == 0) {

    stop(
      "Zoo objects in list 'tsl' must have at least one shared column name."
      )

  }

  #non NA
  na.count <- tsl_count_NA(
    tsl = tsl,
    verbose = FALSE
    )

  if(na.count > 0){

    warning(
      "Zoo objects in list 'tsl' must not have NA cases. The function distantia::tsl_handle_NA() may fix this issue.",
      call. = FALSE
    )

  }

  #set valid flag
  attr(
    x = tsl,
    which = "valid"
  ) <- TRUE

  tsl
}
