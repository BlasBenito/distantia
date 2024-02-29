#' Column Names of Zoo Objects in Time Series List
#'
#' @param tsl (required, time series list) Individual time series or time series list created with [tsl_initialize]. Default: NULL
#' @param names (optional, character string) Three different sets of column names can be requested:
#' \itemize{
#'   \item "all" (default): list with the column names in each zoo object in `tsl`.
#'   \item "shared": character vector with the shared column names in `tsl`.
#'   \item "exclusive": list with names of exclusive columns in each zoo object in `tsl`.
#' }
#' @param test_valid (optional, logical) If FALSE, the validity test performed by [tsl_is_valid()] is ignored. Useful to improve performance when the user knows that `tsl` is valid. Default: TRUE
#'
#' @return character vector of common column names if `common = TRUE`, or list with character vector of column names otherwise.
#' @export
#'
#' @examples
tsl_colnames <- function(
    tsl = NULL,
    names = c("all", "shared", "exclusive"),
    test_valid = TRUE
){

  tsl <- tsl_is_valid(
    tsl = tsl,
    test_valid = test_valid
  )

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
    return(invisible())
  }

  exclusive.names

}


#' Renames Columns of Zoo Objects in a Time Series List
#'
#' @param tsl (required, time series list) Individual time series or time series list created with [tsl_initialize]. Default: NULL
#' @param new_names (required, list) Named list. List names should match old column names in `tsl`, and each named item should contain a character string with the new name. For example, `colnames = list(old_name = "new_name")` changes the name of the column "old_name" to "new_name".
#' @param test_valid (optional, logical) If FALSE, the validity test performed by [tsl_is_valid()] is ignored. Useful to improve performance when the user knows that `tsl` is valid. Default: TRUE
#'
#' @return
#' @export
#'
#' @examples
tsl_set_colnames <- function(
    tsl = NULL,
    new_names = NULL,
    test_valid = TRUE
){

  tsl <- tsl_is_valid(
    tsl = tsl,
    test_valid = test_valid
  )

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
    FUN = function(i){
      colnames(i)[colnames(i) %in% names(new_names)] <- new_names
      i
    }
  )

  tsl <- tsl_set_names(
    tsl = tsl,
    test_valid = FALSE
  )

  tsl

}

#' Cleans Column Names of a Time Series List
#'
#' @param tsl (required, time series list) Individual time series or time series list created with [tsl_initialize]. Default: NULL
#' @param test_valid (optional, logical) If FALSE, the validity test performed by [tsl_is_valid()] is ignored. Useful to improve performance when the user knows that `tsl` is valid. Default: TRUE
#'
#' @return time series list
#' @export
#'
#' @examples
tsl_clean_colnames <- function(
    tsl = NULL,
    as_title = FALSE,
    length = NULL,
    test_valid = TRUE
){

  tsl <- tsl_is_valid(
    tsl = tsl,
    test_valid = test_valid
  )

  tsl.colnames <- tsl.old.names <- tsl_colnames(
    tsl = tsl,
    names = "all",
    test_valid = FALSE
  ) |>
    unlist() |>
    unique()

  tsl.colnames <- make.names(
    names = tsl.colnames,
    unique = TRUE
  )

  tsl.colnames <- gsub(
    pattern = "\\s+",
    replacement = "_",
    x = tsl.colnames
  )

  tsl.colnames <- gsub(
    pattern = "\\.{1,}",
    replacement = "_",
    x = tsl.colnames
  )

  if(is.numeric(length)){

    tsl.colnames <- abbreviate(
      names.arg = tsl.colnames,
      minlength = as.integer(length),
      method = "both.sides",
      named = FALSE
    )

  }

  if(as_title == TRUE){

    tsl.colnames <- paste0(
      toupper(
        substr(
          x = tsl.colnames,
          start = 1,
          stop = 1
        )
      ),
      substr(
        x = tsl.colnames,
        start = 2,
        stop = nchar(tsl.colnames)
      )
    )

  }

  names(tsl.colnames) <- tsl.old.names

  tsl <- tsl_set_colnames(
    tsl = tsl,
    new_names = as.list(tsl.colnames),
    test_valid = FALSE
  )

  tsl

}
