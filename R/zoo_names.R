#' Set Name of a Zoo Time Series
#'
#' @description
#' Zoo time series do not have an attribute 'name'. However, within `distantia`,  to keep data consistency in several plotting and analysis operations, an attribute 'name' is used for these objects. This function is a convenient wrapper of `attr(x = x, which = "name") <- "xxx"`.
#'
#'
#' @param x (required, zoo object) Zoo time series to analyze. Default: NULL.
#' @param name (required, character string) name or new name of the zoo object. If NULL, `x` is returned as is. Default: NULL
#'
#' @return zoo time series
#' @export
#' @autoglobal
#' @examples
#' #simulate zoo time series
#' x <- zoo_simulate()
#'
#' #get current name
#' zoo_name_get(x = x)
#'
#' #change name
#' x <- zoo_name_set(
#'   x = x,
#'   name = "My.New.name"
#' )
#'
#' zoo_name_get(x = x)
#'
#' #clean name
#' x <- zoo_name_clean(
#'   x = x,
#'   lowercase = TRUE
#' )
#'
#' zoo_name_get(x = x)
#' @family data_preparation
zoo_name_set <- function(
    x = NULL,
    name = NULL
){

  if(!zoo::is.zoo(object = x)){
    stop("distantia::zoo_name_set(): argument 'x' must be a zoo time series.", call. = FALSE)
  }

  if(!is.character(name)){
    return(x)
  }

  x_name <- attributes(x)$name

  if(!is.null(x_name)){
    if(x_name != name){
      message("distantia::zoo_name_set(): renaming zoo time series from '", x_name, "' to '", name, "'.")
    }
  }

  attr(
    x = x,
    which = "name"
  ) <- name

  x

}


#' Get Name of a Zoo Time Series
#'
#' @description
#' Just a convenient wrapper of `attributes(x)$name`.
#'
#'
#' @param x (required, zoo object) Zoo time series to analyze. Default: NULL.
#'
#' @return character string
#' @export
#' @autoglobal
#' @examples
#' #simulate zoo time series
#' x <- zoo_simulate()
#'
#' #get current name
#' zoo_name_get(x = x)
#'
#' #change name
#' x <- zoo_name_set(
#'   x = x,
#'   name = "My.New.name"
#' )
#'
#' zoo_name_get(x = x)
#'
#' #clean name
#' x <- zoo_name_clean(
#'   x = x,
#'   lowercase = TRUE
#' )
#'
#' zoo_name_get(x = x)
#' @family data_preparation
zoo_name_get <- function(
    x = NULL
){

  if(zoo::is.zoo(object = x) == FALSE){
    stop("Argument 'x' must be a zoo time series")
  }

  x_name <- attributes(x)$name

  if(is.null(x_name)){
    warning("Zoo object 'x' does not have the attribute 'name'.")
  }

  x_name

}

#' Clean Name of a Zoo Time Series
#'
#'@description
#' Combines [utils_clean_names()] and [zoo_name_set()] to help clean, abbreviate, capitalize, and add a suffix or a prefix to the name of a zoo object.
#'
#' @param x (required, zoo object) Zoo time series to analyze. Default: NULL.
#' @param lowercase (optional, logical) If TRUE, all names are coerced to lowercase. Default: FALSE
#' @param separator (optional, character string) Separator when replacing spaces and dots. Also used to separate `suffix` and `prefix` from the main word. Default: "_".
#' @param capitalize_first (optional, logical) Indicates whether to capitalize the first letter of each name Default: FALSE.
#' @param capitalize_all (optional, logical) Indicates whether to capitalize all letters of each name Default: FALSE.
#' @param length (optional, integer) Minimum length of abbreviated names. Names are abbreviated via [abbreviate()]. Default: NULL.
#' @param suffix (optional, character string) Suffix for the clean names. Default: NULL.
#' @param prefix (optional, character string)  Prefix for the clean names. Default: NULL.
#'
#' @return zoo time series
#'
#' @autoglobal
#' @family data_preparation
#' @export
#' @examples
#' #simulate zoo time series
#' x <- zoo_simulate()
#'
#' #get current name
#' zoo_name_get(x = x)
#'
#' #change name
#' x <- zoo_name_set(
#'   x = x,
#'   name = "My.New.name"
#' )
#'
#' zoo_name_get(x = x)
#'
#' #clean name
#' x <- zoo_name_clean(
#'   x = x,
#'   lowercase = TRUE
#' )
#'
#' zoo_name_get(x = x)
zoo_name_clean <- function(
    x = NULL,
    lowercase = FALSE,
    separator = "_",
    capitalize_first = FALSE,
    capitalize_all = FALSE,
    length = NULL,
    suffix = NULL,
    prefix = NULL
){

  if(zoo::is.zoo(object = x) == FALSE){
    stop("Argument 'x' must be a zoo time series")
  }

  x_name <- zoo_name_get(
    x = x
  ) |>
    suppressWarnings()

  if(is.null(x_name)){
    stop("Argument 'x' does not have the attribute 'name'. Please, set a name with 'distantia::zoo_name_set()' first.")
  }

  x_name_clean <- utils_clean_names(
    x = x_name,
    lowercase = lowercase,
    separator = separator,
    capitalize_first = capitalize_first,
    capitalize_all = capitalize_all,
    length = length,
    suffix = suffix,
    prefix = prefix
  )

  names(x_name_clean) <- NULL

  x <- zoo_name_set(
    x = x,
    name = x_name_clean
  )

  x


}
