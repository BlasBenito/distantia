#' Get Names of a Time Series List
#'
#' @description
#'
#' A list of zoo objects created with [tsl_initialize()] has two sets of names that should ideally be the same: the list names, accessed with `names(tsl)`, and the names of the individual zoo objects (stored in their attribute "name"), accessed with `tsl_zoo_names(x)`.
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @return character vector
#' @export
#'
#' @examples
#' TODO: complete example
tsl_zoo_names <- function(
    tsl = NULL
){

  tsl.names <- lapply(
    X = tsl,
    FUN = function(x){
      attributes(x)$name
    }
  ) |>
    unlist()

  names(tsl.names) <- NULL

  tsl.names

}

#' Names of Time Series List
#'
#' @description
#' Just a wrapper to [base::names].
#'
#'
#' @param tsl (required, list) Time series list. Default: NULL
#'
#' @return character vector
#' @export
#' @autoglobal
#' @examples
#' TODO: complete example
tsl_names <- function(
    tsl = NULL
    ){

  names(tsl)

}


#' Set Names of a Time Series List
#'
#' @description
#' Sets the names of a time series list and the internal names of the zoo objects inside, stored in their attribute "name".
#'
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param names (optional, character vector) names to set. Must be of the same length of `x`. If NULL, and the list `x` has names, then the names of the zoo objects inside of the list are taken from the names of the list elements.
#'
#' @return time series list
#' @export
#'
#' @examples
#' #tsl with NA cases
#' tsl <- tsl_simulate(
#'   na_fraction = 0.25
#' )
#'
#' #removing list names
#' names(tsl) <- NULL
#'
#' #check validity
#' tsl <- tsl_validate(
#'   tsl = tsl
#' )
#'
#' #fix names issue
#' tsl <- tsl_names_set(
#'   tsl = tsl
#' )
#'
#' #check validity again
#' tsl <- tsl_validate(
#'   tsl = tsl
#' )
#'
#' #value of attribute "valid"
#' attributes(x = tsl)$valid
#'
#' #fix NA issues
#' tsl <- tsl_handle_NA(
#'   tsl = tsl
#' )
#'
#' #check validity again
#' #no errors, warnings, or messages
#' tsl <- tsl_validate(
#'   tsl = tsl
#' )
#'
#' #value of attribute "valid"
#' attributes(x = tsl)$valid
tsl_names_set <- function(
    tsl = NULL,
    names = NULL
){

  #get tsl and zoo names
  tsl_zoo_names <- names(tsl)

  zoo_names <- lapply(
    X = tsl,
    FUN = function(x){
      attributes(x)$name
    }
  ) |>
    unlist()

  #argument names is NULL
  #using names available in tsl object
  #or creating new names from LETTERS
  if(is.null(names)){

    #using names from list
    if(all(!is.null(tsl_zoo_names))){

      names <- tsl_zoo_names

      #using names from zoo objects
    } else if(all(!is.null(zoo_names))) {

      names <- zoo_names

      #creating new names
    } else {

      n <- length(tsl)

      #more names than LETTERS
      if(n > length(LETTERS)){

        names <- c(
          LETTERS,
          as.vector(
            outer(
              X = LETTERS,
              Y = LETTERS,
              FUN = paste0
            )
          )
        )[seq_len(n)]

        #fewer names than LETTERS
      } else {

        names <- LETTERS[seq_len(n)]

      }

      message("No names available in 'tsl' and argument 'names' is NULL. New names are: ", paste0(names, collapse = ", "), ".")

    }

  }

  if(length(names) != length(tsl)){

    stop(
      "The length of the 'names' argument must be ",
      length(tsl),
      "."
    )

  }

  #setting names
  names <- as.character(names)

  #name list
  names(tsl) <- names

  #name zoo objects
  tsl <- Map(
    f = function(y, name) {
      attr(
        x = y,
        which = "name"
      ) <- name
      y
    },
    tsl,
    names
  )

  tsl

}

#' Clean Names of a Time Series List
#'
#'
#' @param tsl (required, list) Time series list. Default: NULL
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
#' TODO add example
#' @autoglobal
#' @export
tsl_names_clean <- function(
    tsl = NULL,
    separator = "_",
    capitalize_first = FALSE,
    capitalize_all = FALSE,
    length = NULL,
    suffix = NULL,
    prefix = NULL
){

  tsl.names <- tsl_zoo_names(
    tsl = tsl
  )

  tsl.names <- utils_clean_names(
    x = tsl_zoo_names,
    separator = separator,
    capitalize_first = capitalize_first,
    capitalize_all = capitalize_all,
    length = length,
    suffix = suffix,
    prefix = prefix
  )

  names(tsl.names) <- NULL

  tsl <- tsl_names_set(
    tsl = tsl,
    names = tsl.names
  )

  tsl


}
