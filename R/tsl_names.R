#' Names of Time Series List
#'
#' @description
#'
#' A time series list has two sets of names: the names of the list items (as returned by `names(tsl)`), and the names of the contained zoo objects, as stored in their attribute "name". These names should ideally be the same, for the sake of data consistency. This function extracts either set of names.
#'
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param zoo (optional, logical) If TRUE, the attributes "name" of the zoo objects are returned. Default: TRUE
#'
#' @return list
#' @export
#' @autoglobal
#' @examples
#' #initialize a time series list
#' tsl <- tsl_initialize(
#'   x = fagus_dynamics,
#'   id_column = "site",
#'   time_column = "date"
#' )
#'
#'
#' #get names of zoo objects
#' tsl_names_get(
#'   tsl = tsl,
#'   zoo = TRUE
#' )
#'
#' #get list names only
#' tsl_names_get(
#'   tsl = tsl,
#'   zoo = FALSE
#'   )
#'
#' #same as
#' names(tsl)
#' @family tsl_info
#' @keywords names
tsl_names_get <- function(
    tsl = NULL,
    zoo = TRUE
    ){

  if(zoo == TRUE){

    sapply(
      X = tsl,
      FUN = function(x){
        attributes(x)$name
      }
    )

  } else {

    names(tsl)

  }

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
#' #simulate time series list
#' tsl <- tsl_simulate(n = 3)
#'
#' #assess validity
#' tsl <- tsl_diagnose(
#'   tsl = tsl
#' )
#'
#' #list and zoo names (default)
#' tsl_names_get(
#'   tsl = tsl
#' )
#'
#' #list names
#' tsl_names_get(
#'   tsl = tsl,
#'   zoo = FALSE
#' )
#'
#' #renaming list items and zoo objects
#' #------------------------------------
#' tsl <- tsl_names_set(
#'   tsl = tsl,
#'   names = c("X", "Y", "Z")
#' )
#'
#' # check new names
#' tsl_names_get(
#'   tsl = tsl
#' )
#'
#' #fixing naming issues
#' #------------------------------------
#'
#' #creating a invalid time series list
#' names(tsl)[2] <- "B"
#'
#' # check names
#' tsl_names_get(
#'   tsl = tsl
#' )
#'
#' #validate tsl
#' #returns NOT VALID
#' #recommends a solution
#' tsl <- tsl_diagnose(
#'   tsl = tsl
#' )
#'
#' #fix issue with tsl_names_set()
#' #uses names of zoo objects for the list items
#' tsl <- tsl_names_set(
#'   tsl = tsl
#' )
#'
#' #validate again
#' tsl <- tsl_diagnose(
#'   tsl = tsl
#' )
#'
#' #list names
#' tsl_names_get(
#'   tsl = tsl
#' )
#' @family tsl_manipulation
#' @keywords names
tsl_names_set <- function(
    tsl = NULL,
    names = NULL
){

  #get tsl and zoo names
  tsl_names <- tsl_names_get(
    tsl = tsl,
    zoo = FALSE
  ) |>
    utils_clean_names()

  zoo_names <- tsl_names_get(
    tsl = tsl,
    zoo = TRUE
  ) |>
    utils_clean_names()

  #argument names is NULL
  #using names available in tsl object
  #or creating new names from LETTERS
  if(is.null(names)){

    #using names from zoo objects
    if(all(!is.null(zoo_names))){

      names <- zoo_names

      #using names from list
    } else if(
      all(!is.null(tsl_names))
      ){

      names <- tsl_names

      #creating new names
    } else {

      names <- utils_clean_names(x = names)

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
#'@description
#' Combines [utils_clean_names()] and [tsl_names_set()] to help clean, abbreviate, capitalize, and add a suffix or a prefix to time series list names.
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param lowercase (optional, logical) If TRUE, all names are coerced to lowercase. Default: FALSE
#' @param separator (optional, character string) Separator when replacing spaces and dots. Also used to separate `suffix` and `prefix` from the main word. Default: "_".
#' @param capitalize_first (optional, logical) Indicates whether to capitalize the first letter of each name Default: FALSE.
#' @param capitalize_all (optional, logical) Indicates whether to capitalize all letters of each name Default: FALSE.
#' @param length (optional, integer) Minimum length of abbreviated names. Names are abbreviated via [abbreviate()]. Default: NULL.
#' @param suffix (optional, character string) Suffix for the clean names. Default: NULL.
#' @param prefix (optional, character string)  Prefix for the clean names. Default: NULL.
#'
#' @return time series list
#'
#' @autoglobal
#' @export
#' @examples
#' #initialize time series list
#' tsl <- tsl_initialize(
#'   x = fagus_dynamics,
#'   id_column = "site",
#'   time_column = "date"
#' )
#'
#' #original names
#' tsl_names_get(
#'   tsl = tsl
#' )
#'
#' #abbreviate names
#' #---------------------------
#' tsl_clean <- tsl_names_clean(
#'   tsl = tsl,
#'   capitalize_first = TRUE,
#'   length = 4 #abbreviate to 4 characters
#' )
#'
#' #new names
#' tsl_names_get(
#'   tsl = tsl_clean
#' )
#'
#' #suffix and prefix
#' #---------------------------
#' tsl_clean <- tsl_names_clean(
#'   tsl = tsl,
#'   capitalize_all = TRUE,
#'   separator = "_",
#'   suffix = "fagus",
#'   prefix = "country"
#' )
#'
#' #new names
#' tsl_names_get(
#'   tsl = tsl_clean
#' )
#' @family tsl_manipulation
#' @keywords names
tsl_names_clean <- function(
    tsl = NULL,
    lowercase = FALSE,
    separator = "_",
    capitalize_first = FALSE,
    capitalize_all = FALSE,
    length = NULL,
    suffix = NULL,
    prefix = NULL
){

  zoo_names <- tsl_names_get(
    tsl = tsl,
    zoo = TRUE
  )

  tsl_names <- utils_clean_names(
    x = zoo_names,
    lowercase = lowercase,
    separator = separator,
    capitalize_first = capitalize_first,
    capitalize_all = capitalize_all,
    length = length,
    suffix = suffix,
    prefix = prefix
  )

  names(tsl_names) <- NULL

  tsl <- tsl_names_set(
    tsl = tsl,
    names = tsl_names
  )

  tsl


}
