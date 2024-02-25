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
#' @param tsl (required, list of zoo time series) Default NULL
#'
#' @return Logical
#' @export
#' @autoglobal
#' @examples
tsl_is_valid <- function(tsl = NULL){

  #tsl is a list
  if(!is.list(tsl)){

    warning(
      "Argument 'tsl' must be a list.",
      call. = FALSE
    )

    return(FALSE)

  }

  #is a named list
  if(is.null(names(tsl))){

    warning(
      "List 'tsl' must have names.",
      call. = FALSE
    )

    return(FALSE)

  }

  #is a named list
  if(any(duplicated(names(tsi)))){

    warning(
      "List 'tsl' must be unique names.",
      call. = FALSE
    )

    return(FALSE)

  }

  #list with two elements
  if(length(tsl) < 2){

    warning(
      "List 'tsl' must have more than one object",
      call. = FALSE
    )

    return(FALSE)

  }

  #elements in tsl must be zoo
  if(!all(sapply(X = tsl, FUN = zoo::is.zoo))){

    warning(
      "Objects in list 'tsl' must be of class 'zoo'.",
      call. = FALSE
      )

    return(FALSE)
  }

  #zoo objects are named
  zoo.names <- sapply(
    X = tsl,
    FUN = function(x){
      attributes(x)$name
    })

  if(length(zoo.names) == 0){

    warning(
      "Zoo objects in  list'tsl' must have the attribute 'name'.",
      call. = FALSE
    )

    return(FALSE)

  }

  #unique zoo names
  if(any(duplicated(zoo.names))){

    warning(
      "Zoo objects in list 'tsl' must have unique attributes 'name'.",
      call. = FALSE
    )

    return(FALSE)

  }

  #common names
  common.names <- tsl_colnames(
    tsl = tsl,
    common = TRUE
    )

  if(length(common.names) == 0) {

    warning(
      "Zoo objects in list 'tsl' must have at least one common column name.",
      call. = FALSE
      )

    return(FALSE)

  }

  #non NA
  na.count <- tsl_count_NA(
    tsl = NULL,
    verbose = FALSE
    )

  if(na.count > 0){

    warning(
      "Zoo objects in list 'tsl' must not have NA cases.",
      call. = FALSE
    )

    return(FALSE)

  }


  TRUE
}
