#' Column Names of Zoo Objects in Time Series List
#'
#' @param tsl (required, time series list) Individual time series or time series list created with [tsl_initialize]. Default: NULL
#' @param names (optional, character string) Three different sets of column names can be requested:
#' \itemize{
#'   \item "all" (default): list with the column names in each zoo object in `tsl`.
#'   \item "shared": character vector with the shared column names in `tsl`.
#'   \item "exclusive": list with names of exclusive columns in each zoo object in `tsl`.
#' }
#'
#' @return character vector of common column names if `common = TRUE`, or list with character vector of column names otherwise.
#' @export
#'
#' @examples
tsl_colnames <- function(
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
    message("There are no exclusive column names in 'tsl'.")
    return(exclusive.names)
  }

  exclusive.names

}


#' Renames Columns of Zoo Objects in a Time Series List
#'
#' @param tsl (required, time series list) Individual time series or time series list created with [tsl_initialize]. Default: NULL
#' @param names (required, list) Named list. List names should match old column names in `tsl`, and each named item should contain a character string with the new name. For example, `colnames = list(old_name = "new_name")` changes the name of the column "old_name" to "new_name".
#'
#' @return
#' @export
#'
#' @examples
tsl_colnames_set <- function(
    tsl = NULL,
    names = NULL
){


  if(is.list(names) == FALSE){
    stop(
      "Argument 'names' must be a list."
    )
  }

  if(is.null(names(names)) == TRUE){
    stop(
      "Argument 'names' must be a named list."
    )
  }

  names <- unlist(names)

  tsl <- lapply(
    X = tsl,
    FUN = function(i){
      colnames(i)[colnames(i) %in% names(names)] <- names[names %in% colnames(i)]
      i
    }
  )

  tsl <- tsl_names_set(
    tsl = tsl
  )

  tsl

}

#' Clean Column Names of a Time Series List
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
#' @autoglobal
#' @export
tsl_colnames_clean <- function(
    tsl = NULL,
    separator = "_",
    capitalize_first = FALSE,
    capitalize_all = FALSE,
    length = NULL,
    suffix = NULL,
    prefix = NULL
){

  tsl.colnames <- tsl.old.names <- tsl_colnames(
    tsl = tsl,
    names = "all",
  ) |>
    unlist() |>
    unique()

  tsl.colnames <- utils_clean_names(
    x = tsl.colnames,
    separator = separator,
    capitalize_first = capitalize_first,
    capitalize_all = capitalize_all,
    length = length,
    suffix = suffix,
    prefix = prefix
  )

  tsl <- tsl_colnames_set(
    tsl = tsl,
    names = as.list(tsl.colnames)
  )

  tsl

}
