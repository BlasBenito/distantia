#' Validity Assesment for Time Series List
#'
#' @description
#' Validity assessment of Time Series Lists. The required features for a valid time series list are:
#' \itemize{
#'   \item Argument `tsl` is a list.
#'   \item List `tsl` has unique names.
#'   \item List `tsl` has more than one element.
#'   \item All elements in `tsl` are "zoo" objects.
#'   \item All "zoo" objects have an attribute "name".
#'   \item All "zoo" objects have unique attributes "name".
#'   \item All "zoo" objects have at least one common column name.
#'   \item All "zoo" objects have zero NA cases.
#' }
#'
#' If a time series list is valid, it is returned without any messages or warnings, and the value of the attribute "valid" is set to `TRUE`.
#'
#' @param tsl (required, list) Time series list. Default: NULL
#'
#' @return time series list
#' @export
#' @autoglobal
#' @examples
#' TODO: complete example
tsl_is_valid <- function(
    tsl = NULL
){

  #check valid flag
  if("valid" %in% names(attributes(tsl))){
    if(attributes(tsl)$valid == TRUE){
      return(tsl)
    }
  }

  #set valid flag (may be overwritten)
  attr(
    x = tsl,
    which = "valid"
  ) <- TRUE

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
      "List 'tsl' must have unique names."
    )

  }

  #elements in tsl must be zoo
  if(!all(
    sapply(
      X = tsl,
      FUN = zoo::is.zoo
    )
  )
  ){

    stop(
      "Objects in list 'tsl' must be of class 'zoo'."
    )

  }

  #zoo objects are named
  zoo.names <- tsl_names(
    tsl = tsl
  )

  if(length(zoo.names) == 0){

    warning(
      "Zoo objects in  list 'tsl' must have the attribute 'name'. The function distantia::tsl_names_set() may fix this issue.",
      call. = FALSE
    )

    attr(
      x = tsl,
      which = "valid"
    ) <- FALSE

  }

  #unique zoo names
  if(any(duplicated(zoo.names))){

    warning(
      "There are duplicated names in the time series list. The function distantia::tsl_names_set() may help fix this issue.",
      call. = FALSE
    )

    attr(
      x = tsl,
      which = "valid"
    ) <- FALSE

  }

  #common names
  shared.names <- tsl_colnames(
    tsl = tsl,
    names = "shared"
  )

  if(length(shared.names) == 0) {

    stop(
      "Zoo objects in 'tsl' must have one shared column name."
    )

  }

  #non NA
  na.count <- tsl_count_NA(
    tsl = tsl,
    quiet = TRUE
  ) |>
    unlist() |>
    sum()

  if(na.count > 0){

    warning(
      "Argument 'tsl' has NA cases. Please apply distantia::tsl_handle_NA() to fix this issue.",
      call. = FALSE
    )

    attr(
      x = tsl,
      which = "valid"
    ) <- FALSE

  }

  tsl
}
