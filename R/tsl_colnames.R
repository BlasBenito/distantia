#' Get Column Names from a Time Series Lists
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param names (optional, character string) Three different sets of column names can be requested:
#' \itemize{
#'   \item "all" (default): list with the column names in each zoo object in `tsl`.
#'   \item "shared": character vector with the shared column names in `tsl`.
#'   \item "exclusive": list with names of exclusive columns in each zoo object in `tsl`.
#' }
#'
#' @return character vector or list with character vectors
#' @export
#'
#' @examples
#' #generate example data
#' tsl <- tsl_simulate()
#'
#' #list all column names
#' tsl_colnames_get(
#'   tsl = tsl,
#'   names = "all"
#' )
#'
#' #change one column name
#' names(tsl[[1]])[1] <- "new_column"
#'
#' #all names again
#' tsl_colnames_get(
#'   tsl = tsl,
#'   names = "all"
#' )
#'
#' #shared column names
#' tsl_colnames_get(
#'   tsl = tsl,
#'   names = "shared"
#' )
#'
#' #exclusive column names
#' tsl_colnames_get(
#'   tsl = tsl,
#'   names = "exclusive"
#' )
#' @family data_exploration
tsl_colnames_get <- function(
    tsl = NULL,
    names = c(
      "all",
      "shared",
      "exclusive"
      )
){


  names <- match.arg(
    arg = names,
    choices = c(
      c(
        "all",
        "shared",
        "exclusive"
        )
    )
  )

  #all names
  all.names <- lapply(
    X = tsl,
    FUN = function(x){
      colnames(x)
    }
  )

  if(names == "all"){
    return(all.names)
  }

  #shared names
  shared.names <- all.names |>
    unlist() |>
    table()

  shared.names <- shared.names[shared.names == length(tsl)]

  shared.names <- names(shared.names)

  if(names == "shared"){
    return(shared.names)
  }

  #exclusive names
  exclusive.names <- lapply(
    X = tsl,
    FUN = function(x){
      x.exclusive <- setdiff(
        x = colnames(x),
        y = shared.names
      )
      if(length(x.exclusive) == 0){
        return(NA)
      } else {
        return(x.exclusive)
      }
    }
  )

  exclusive.names <- exclusive.names[!is.na(exclusive.names)]

  if(length(exclusive.names) == 0){
    return(exclusive.names)
  }

  exclusive.names

}


#' Set Column Names in Time Series Lists
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param new_names (required, list) Named list. List names should match old column names in `tsl`, and each named item should contain a character string with the new name. For example, `colnames = list(old_name = "new_name")` changes the name of the column "old_name" to "new_name".
#'
#' @return time series list
#' @export
#'
#' @examples
#' #generate example data
#' tsl <- tsl_simulate(cols = 3)
#'
#' #list all column names
#' tsl_colnames_get(
#'   tsl = tsl,
#'   names = "all"
#' )
#'
#' #rename columns
#' tsl <- tsl_colnames_set(
#'   tsl = tsl,
#'   new_names = list(
#'     a = "new_name_1",
#'     b = "new_name_1",
#'     c = "new_name_3"
#'   )
#' )
#'
#' #check result
#' tsl_colnames_get(
#'   tsl = tsl,
#'   names = "all"
#' )
#' @family data_preparation
tsl_colnames_set <- function(
    tsl = NULL,
    new_names = NULL
){

  if(is.list(new_names) == FALSE){
    stop(
      "Argument 'new_names' must be a list."
    )
  }

  if(is.null(names(new_names)) == TRUE){
    stop(
      "Argument 'new_names' must be a named list."
    )
  }

  new_names <- unlist(new_names)

  tsl <- lapply(
    X = tsl,
    FUN = function(x){
      colnames(x)[colnames(x) %in% names(new_names)] <- new_names[names(new_names) %in% colnames(x)]
      x
    }
  )

  tsl <- tsl_names_set(
    tsl = tsl
  )

  tsl

}

#' Clean Column Names in Time Series Lists
#'
#' @description
#' Uses the function [utils_clean_names()] to simplify and homogeneize messy column names in a time series list.
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
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param lowercase (optional, logical) If TRUE, all names are coerced to lowercase. Default: FALSE
#' @param separator (optional, character string) Separator when replacing spaces and dots. Also used to separate `suffix` and `prefix` from the main word. Default: "_".
#' @param capitalize_first (optional, logical) Indicates whether to capitalize the first letter of each name Default: FALSE.
#' @param capitalize_all (optional, logical) Indicates whether to capitalize all letters of each name Default: FALSE.
#' @param length (optional, integer) Minimum length of abbreviated names. Names are abbreviated via [abbreviate()]. Default: NULL.
#' @param suffix (optional, character string) String to append to the cleaned names. Default: NULL.
#' @param prefix (optional, character string)  String to prepend to the cleaned names. Default: NULL.
#'
#' @return time series list
#'
#' @examples
#' #generate example data
#' tsl <- tsl_simulate(cols = 3)
#'
#' #list all column names
#' tsl_colnames_get(
#'   tsl = tsl
#' )
#'
#' #rename columns
#' tsl <- tsl_colnames_set(
#'   tsl = tsl,
#'   new_names = list(
#'     a = "New name 1",
#'     b = "new Name 2",
#'     c = "NEW NAME 3"
#'   )
#' )
#'
#' #check new names
#' tsl_colnames_get(
#'   tsl = tsl,
#'   names = "all"
#' )
#'
#' #clean names
#' tsl <- tsl_colnames_clean(
#'   tsl = tsl
#' )
#'
#' tsl_colnames_get(
#'   tsl = tsl
#' )
#'
#' #abbreviated
#' tsl <- tsl_colnames_clean(
#'   tsl = tsl,
#'   capitalize_first = TRUE,
#'   length = 6,
#'   suffix = "clean"
#' )
#'
#' tsl_colnames_get(
#'   tsl = tsl
#' )
#' @autoglobal
#' @export
#' @family data_preparation
tsl_colnames_clean <- function(
    tsl = NULL,
    lowercase = FALSE,
    separator = "_",
    capitalize_first = FALSE,
    capitalize_all = FALSE,
    length = NULL,
    suffix = NULL,
    prefix = NULL
){

  tsl.colnames <- tsl.old.names <- tsl_colnames_get(
    tsl = tsl,
    names = "all"
  ) |>
    unlist() |>
    unique()

  tsl.colnames <- utils_clean_names(
    x = tsl.colnames,
    lowercase = lowercase,
    separator = separator,
    capitalize_first = capitalize_first,
    capitalize_all = capitalize_all,
    length = length,
    suffix = suffix,
    prefix = prefix
  )

  tsl <- tsl_colnames_set(
    tsl = tsl,
    new_names = as.list(tsl.colnames)
  )

  tsl

}
