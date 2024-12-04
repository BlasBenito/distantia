#' Get Column Names from a Time Series Lists
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param names (optional, character string) Three different sets of column names can be requested:
#' \itemize{
#'   \item "all" (default): list with the column names in each zoo object in `tsl`. Unnamed columns are tagged with the string "unnamed".
#'   \item "shared": character vector with the shared column names in at least two zoo objects in `tsl`.
#'   \item "exclusive": list with names of exclusive columns (if any) in each zoo object in `tsl`.
#' }
#'
#' @return list
#' @export
#' @autoglobal
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
#' @family tsl_management
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
    ),
    several.ok = FALSE
  )

  utils_check_args_tsl(
    tsl = tsl,
    min_length = 1
  )

  #all names
  all.names <- lapply(
    X = tsl,
    FUN = function(x){
      y <- colnames(x)
      if(is.null(y)){
        y <- "unnamed"
      }
      y
    }
  )

  if(names == "all"){
    return(all.names)
  }

  #shared names
  all.names.table <- all.names |>
    unlist() |>
    table()

  #returns shared names in at least 2 zoo objects
  shared.names <- names(
    all.names.table[all.names.table == length(tsl)]
    )

  #get exclusive names
  exclusive.names <- names(
    all.names.table[all.names.table == 1]
  )

  #subset all.names to shared names
  shared.names <- lapply(
    X = all.names,
    FUN = function(x){
      y <- x[x %in% shared.names]
      if(length(y) == 0){
        return(NA)
      }
      y
    }
  )

  if(names == "shared"){
    return(shared.names)
  }

  #convert shared names to vector
  shared.names.vector <- shared.names |>
    unlist() |>
    unique() |>
    stats::na.omit()

  #exclusive names
  exclusive.names <- lapply(
    X = all.names,
    FUN = function(x){
      y <- x[x %in% exclusive.names]
      if(length(y) == 0){
        return(NA)
      }
      y
    }
  )

  exclusive.names

}


#' Set Column Names in Time Series Lists
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param names (required, list or character vector):
#' \itemize{
#'   \item list: with same names as 'tsl', containing a vector of new column names for each time series in 'tsl'.
#'   \item character vector: vector of new column names assigned by position.
#' }
#'
#' @return time series list
#' @export
#'
#' @examples
#' tsl <- tsl_simulate(
#'   cols = 3
#'   )
#'
#' tsl_colnames_get(
#'   tsl = tsl
#'   )
#'
#' #using a vector
#' #extra names are ignored
#' tsl <- tsl_colnames_set(
#'   tsl = tsl,
#'   names = c("x", "y", "z", "zz")
#' )
#'
#' tsl_colnames_get(
#'   tsl = tsl
#' )
#'
#' #using a list
#' #extra names are ignored too
#' tsl <- tsl_colnames_set(
#'   tsl = tsl,
#'   names = list(
#'     A = c("A", "B", "C"),
#'     B = c("X", "Y", "Z", "ZZ")
#'   )
#' )
#'
#' tsl_colnames_get(
#'   tsl = tsl
#' )
#' @family tsl_management
tsl_colnames_set <- function(
    tsl = NULL,
    names = NULL
){

  utils_check_args_tsl(
    tsl = tsl,
    min_length = 1
  )

  #coerce zoo vectors to matrices
  tsl <- lapply(
    X = tsl,
    FUN = zoo_vector_to_matrix
  )

  #computing minimum names length
  min.names.length <- lapply(
    X = tsl,
    FUN = ncol
  ) |>
    unlist() |>
    max()

  #names is a character vector
  #convert to list
  if(
    is.vector(names) &&
    is.character(names)
  ){

    if(length(names) < min.names.length){
      stop("distantia::tsl_colnames_set(): argument 'names' must be a character vector of length ", min.names.length, ".", call. = FALSE)
    }

    #convert to list
    names <- lapply(
      X = tsl,
      FUN = function(x){

        names[seq_len(ncol(x))]

      }
    )

  }

  #names is a list
  if(is.list(names)){

    if(length(names) != length(tsl)){
      stop("distantia::tsl_colnames_set(): arguments 'names' and 'tsl' must be lists of the same length.", call. = FALSE)
    }

    if(any(base::names(names) != base::names(tsl))){
      stop("distantia::tsl_colnames_set(): arguments 'names' and 'tsl' must be lists with the same names.", call. = FALSE)
    }

    #test lengths
    test.length <- Map(
      f = function(x, name) {
        length(name) >= ncol(x)
      },
      tsl,
      names
    ) |>
      unlist() |>
      any()

    if(!any(test.length)){
      stop("distantia::tsl_colnames_set(): length of each element in 'names' must match the number of columns of each element in 'tsl'.", call. = FALSE)
    }


  }

  #rename zoo columns
  tsl <- Map(
    f = function(y, name) {
      colnames(y) <- name[seq_len(length(colnames(y)))]
      y
    },
    tsl,
    names
  )

  tsl

}

#' Clean Column Names in Time Series Lists
#'
#' @description
#' Uses the function [utils_clean_names()] to simplify and normalize messy column names in a time series list.
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
#' @param suffix (optional, character string) String to append to the column names. Default: NULL.
#' @param prefix (optional, character string)  String to prepend to the column names. Default: NULL.
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
#'   names = c(
#'   "New name 1",
#'   "new Name 2",
#'   "NEW NAME 3"
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
#' @family tsl_management
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

  utils_check_args_tsl(
    tsl = tsl,
    min_length = 1
  )

  #clean names
  tsl <- lapply(
    X = tsl,
    FUN = function(x){

      x <- zoo_vector_to_matrix(
        x = x,
        name = NULL
      )

      x_colnames <- colnames(x)

      if(is.null(x_colnames)){
        x_colnames <- rep(
          x = "unnamed",
          times = ncol(x)
          )
      }

      x_colnames <- utils_clean_names(
        x = x_colnames,
        lowercase = lowercase,
        separator = separator,
        capitalize_first = capitalize_first,
        capitalize_all = capitalize_all,
        length = length,
        suffix = suffix,
        prefix = prefix
      )

      base::names(x_colnames) <- NULL

      colnames(x) <- x_colnames

      x

    }
  )

  tsl

}


#' Append Suffix to Column Names of Time Series List
#'
#' @inheritParams tsl_colnames_clean
#' @return time series list
#' @export
#' @autoglobal
#' @examples
#' tsl <- tsl_simulate()
#'
#' tsl_colnames_get(tsl = tsl)
#'
#' tsl <- tsl_colnames_suffix(
#'   tsl = tsl,
#'   suffix = "_my_suffix"
#' )
#'
#' tsl_colnames_get(tsl = tsl)
tsl_colnames_suffix <- function(
    tsl = NULL,
    suffix = NULL
){

  utils_check_args_tsl(
    tsl = tsl,
    min_length = 1
  )

  if(is.null(suffix)){
    return(tsl)
  }

  tsl <- future.apply::future_lapply(
    X = tsl,
    FUN = function(x){

      colnames(x) <- paste0(
        colnames(x),
        suffix
      )

      x

    }
  )

  tsl

}

#' Append Prefix to Column Names of Time Series List
#'
#' @inheritParams tsl_colnames_clean
#' @return time series list
#' @export
#' @autoglobal
#' @examples
#' tsl <- tsl_simulate()
#'
#' tsl_colnames_get(tsl = tsl)
#'
#' tsl <- tsl_colnames_prefix(
#'   tsl = tsl,
#'   prefix = "my_prefix_"
#' )
#'
#' tsl_colnames_get(tsl = tsl)
tsl_colnames_prefix <- function(
    tsl = NULL,
    prefix = NULL
){

  utils_check_args_tsl(
    tsl = tsl,
    min_length = 1
  )

  if(is.null(prefix)){
    return(tsl)
  }

  tsl <- future.apply::future_lapply(
    X = tsl,
    FUN = function(x){

      colnames(x) <- paste0(
        prefix,
        colnames(x)
      )

      x

    }
  )

  tsl

}
