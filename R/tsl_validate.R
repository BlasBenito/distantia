#' Validate Time Series List
#'
#' @description
#' Validity assessment of Time Series Lists. The required features for a valid time series list are:
#' \itemize{
#'   \item Argument `tsl` is a list.
#'   \item List `tsl` has unique names.
#'   \item List `tsl` has more than one element.
#'   \item All elements in `tsl` are `zoo` objects.
#'   \item All `zoo` objects have the attribute "name".
#'   \item All `zoo` objects have unique values in the attribute "name".
#'   \item All `zoo` objects have at least one common column name.
#'   \item All columns in the `zoo` objects are numeric.
#'   \item All `zoo` objects have zero NA cases.
#' }
#'
#' The function `tsl_validate()` assesses these conditions, and sets the value of the attribute "valid" of the time series list to `TRUE` or `FALSE` accordingly.
#'
#' The function `tsl_is_valid()`, called by most functions taking a time series list as input, returns a warning if the value of the "valid" argument is FALSE.
#'
#' @param tsl (required, list) Time series list. Default: NULL
#'
#' @return time series list
#' @export
#' @autoglobal
#' @examples
#' #tsl with NA cases
#' tsl <- tsl_simulate(
#'   na_fraction = 0.25
#' )
#'
#' #removing list names
#' names(tsl) <- NULL
#'
#' #value of attribute "valid"
#' attributes(x = tsl)$valid
#'
#' #this will result in an invalid tsl
#' tsl <- tsl_is_valid(
#'   tsl = tsl
#' )
#'
#' #run validation check
#' tsl <- tsl_validate(
#'   tsl = tsl
#' )
#' #two issues identified!
#'
#' #addressing names issue
#' tsl <- tsl_names_set(
#'   tsl = tsl
#' )
#'
#' #addressing NA issue
#' tsl <- tsl_handle_NA(
#'   tsl = tsl
#' )
#'
#' #validation test again
#' tsl <- tsl_validate(
#'   tsl = tsl
#' )
#'
#' #validation check works now
#' tsl <- tsl_is_valid(
#'   tsl = tsl
#' )
#'
#' #value of attribute "valid" is TRUE
#' attributes(x = tsl)$valid
tsl_validate <- function(
    tsl = NULL
){

  #all possible issues
  all_issues <- list(
    tsl_not_a_list = "  - argument 'tsl' must be a list of zoo objects: see tsl_initialize().",
    tsl_one_element = "  - argument 'tsl' must have at least two zoo objects.",
    tsl_names_null =  "  - elements of 'tsl' must be named: use tsl_names_set() or names(tsl) <- c(...) to fix this issue.",
    tsl_names_duplicated = "  - elements of 'tsl' must have unique names: use tsl_names_set() or names(tsl) <- c(...) to fix this issue.",
    tsl_objects_zoo = "  - objects in 'tsl' must be of the class 'zoo'.",
    zoo_no_name = "  - zoo objects in 'tsl' must have the attribute 'name': use tsl_names_set() to fix this issue.",
    zoo_duplicated_names = "  - zoo objects in 'tsl' must have unique names: use tsl_names_set() to fix this issue.",
    zoo_no_shared_columns = "  - zoo objects in 'tsl' must have at least one shared column: use tsl_colnames() to identify shared and/or exclusive columns.",
    zoo_non_numeric_columns = "  - all columns of zoo objects in 'tsl' must be of class 'numeric': use tsl_select_numeric_cols() to fix this issue.",
    zoo_NA_cases = "  - zoo objects in 'tsl' have NA cases: interpolate or remove them with tsl_handle_NA() to fix this issue."
  )

  # initialize feedback
  issues <- vector()
  is_valid <- TRUE

  #list properties

  # tsl is not a list
  if(!is.list(tsl)){

    issues <- all_issues

    is_valid <- FALSE

    #tsl is a list
  } else {

    # tsl has only one element
    if(length(tsl) <= 1){

      issues <- c(
        issues,
        all_issues[["tsl_one_element"]]
      )

      is_valid <- FALSE

    }

    # tsl has names
    if(is.null(names(tsl))){

      issues <- c(
        issues,
        all_issues[["tsl_names_null"]]
      )

      is_valid <- FALSE

      # tsl has no names
    } else {

      # names are unique
      if(any(duplicated(names(tsl)))){

        issues <- c(
          issues,
          all_issues[["tsl_names_duplicated"]]
        )

        is_valid <- FALSE

      }


    }

    #zoo objects

    # elements in tsl are not zoo objects
    if(
      !all(
        sapply(
          X = tsl,
          FUN = zoo::is.zoo
        )
      )
    ){

      issues <- c(
        issues,
        all_issues[["tsl_objects_zoo"]]
      )

      is_valid <- FALSE

      # elemenets in tsl are zoo objects
    } else {

      # zoo objects have names
      zoo.names <- tsl_zoo_names(tsl = tsl)

      if(length(zoo.names) == 0){

        issues <- c(
          issues,
          all_issues[["zoo_no_name"]]
        )

        is_valid <- FALSE

      } else {

        # zoo names are unique
        if(any(duplicated(zoo.names))){

          issues <- c(
            issues,
            all_issues[["zoo_duplicated_names"]]
          )

          is_valid <- FALSE

        }

      }

      # zoo objects have shared colnames
      zoo.names.shared <- tsl_colnames(
        tsl = tsl,
        names = "shared"
      )

      if(length(zoo.names.shared) == 0){

        issues <- c(
          issues,
          all_issues[["zoo_no_shared_columns"]]
        )

        is_valid <- FALSE

      }

      #all columns in zoo objects are numeric
      zoo.columns.numeric <- sapply(
        X = tsl,
        FUN = function(x){

          apply(
            X = zoo::coredata(x),
            FUN = is.numeric,
            MARGIN = 2
          ) |>
            all()

        }

      ) |>
        all()

      if(zoo.columns.numeric == FALSE){

        issues <- c(
          issues,
          all_issues[["zoo_non_numeric_columns"]]
        )

        is_valid <- FALSE

      }

      # NA values
      na.count <- tsl_count_NA(
        tsl = tsl,
        quiet = TRUE
      ) |>
        unlist() |>
        sum()

      if(na.count > 0){

        issues <- c(
          issues,
          all_issues[["zoo_NA_cases"]]
        )

        is_valid <- FALSE

      }

    } #end of: elements in tsl are zoo objects

  } #end of: tsl is a list

  # set valid attribute
  attr(tsl, "valid") <- is_valid

  if(is_valid == FALSE){

    message(
      "This time series list is NOT VALID.\n",
      "Issue found:\n",
      paste(
        issues,
        collapse = "\n"
      )
    )

  } else {

    message("This time series list is VALID.")

  }

  tsl

}

#' @rdname tsl_validate
#' @export
#' @autoglobal
#' @examples
tsl_is_valid <- function(
    tsl = NULL
){

  if(!("valid" %in% names(attributes(tsl)))){

    warning(
      "Argument 'tsl' must have the attribute 'valid'. Please run distantia::tsl_validate() to diagnose any potential issues.",
      call. = FALSE
    )

  } else {

    if(
      attributes(tsl)$valid == FALSE
    ){
      warning(
        "Attribute 'valid' of argument 'tsl' is FALSE. Please run distantia::tsl_validate() to diagnose potential issues.",
        call. = FALSE
        )
    }

  }

  tsl

}
