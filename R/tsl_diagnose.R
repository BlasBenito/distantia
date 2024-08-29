#' Validity Assessment of Time Series Lists
#'
#' @description
#' Validity assessment of time series lists. The required features for a valid time series list are:
#' \itemize{
#'   \item Argument `tsl` is a list.
#'   \item List `tsl` has unique names.
#'   \item All elements in `tsl` are `zoo` objects.
#'   \item All `zoo` objects have the attribute "name".
#'   \item All `zoo` objects have unique values in the attribute "name".
#'   \item Names of the list slots and the `zoo` objects are the same.
#'   \item All `zoo` objects have at least one shared column name.
#'   \item All columns in the `zoo` objects are numeric.
#'   \item All `zoo` objects have zero NA cases.
#' }
#'
#' This function analyzes a time series list and returns it without modification, but issues a warning if any condition is not met, and an explanation on how to solve the issue.
#'
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param full (optional, logical) If TRUE, the function runs checks looking at all the individual values of the time series list. This makes the test slower, but more comprehensive. Default: TRUE
#'
#' @return time series list
#' @export
#' @autoglobal
#' @examples
#' #simulate time series list with NA data
#' tsl <- tsl_simulate(
#'   n = 3,
#'   na_fraction = 0.1
#' )
#'
#' #adding a few additional issues:
#'
#' #set names of one time series to uppercase
#' colnames(tsl[[2]]) <- toupper(colnames(tsl[[2]]))
#'
#' #change name of one column in one time series
#' colnames(tsl[[3]])[2] <- "x"
#'
#' #remove list names
#' names(tsl) <- NULL
#'
#' #diagnose issues in tsl
#' tsl <- tsl_diagnose(
#'   tsl = tsl,
#'   full = TRUE
#' )
#'
#' #repair time series list
#' tsl <- tsl_repair(
#'   tsl = tsl,
#'   full = TRUE
#' )
#'
#' #diagnose again
#' tsl <- tsl_diagnose(
#'   tsl = tsl,
#'   full = TRUE
#' )
#' @family data_preparation
tsl_diagnose <- function(
    tsl = NULL,
    full = TRUE
){

  #all possible issues
  all_issues <- list(
    tsl_not_a_list = "  - argument 'tsl' must be a list of zoo objects: see tsl_initialize().",
    tsl_names_null =  "  - elements of 'tsl' must be named: use tsl_names_set() or names(tsl) <- c(...) to fix this issue.",
    tsl_names_duplicated = "  - elements of 'tsl' must have unique names: use tsl_names_set() or names(tsl) <- c(...) to fix this issue.",
    tsl_objects_zoo = "  - objects in 'tsl' must be of the class 'zoo'.",
    zoo_no_name = "  - zoo objects in 'tsl' must have the attribute 'name': use tsl_names_set() to fix this issue.",
    zoo_duplicated_names = "  - zoo objects in 'tsl' must have unique names: use tsl_names_set() to fix this issue.",
    zoo_different_names = "  - zoo objects and list items have different names:  use tsl_names_set() to fix this issue.",
    zoo_missing_names = "  - zoo objects in 'tsl' have no attribute 'name':  use tsl_names_set() to fix this issue.",
    zoo_no_shared_columns = "  - zoo objects in 'tsl' must have at least one shared column: use tsl_colnames_get() to identify shared and/or exclusive columns.",
    zoo_non_numeric_columns = "  - all columns of zoo objects in 'tsl' must be of class 'numeric': use tsl_subset() to fix this issue.",
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

    # tsl has no names
    if(any(is.null(names(tsl)))){

      issues <- c(
        issues,
        all_issues[["tsl_names_null"]]
      )

      is_valid <- FALSE

    # tsl has names
    } else {

      # duplicated names
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
      zoo_names <- tsl_names_get(
        tsl = tsl,
        zoo = TRUE
      )

      if(length(zoo_names) == 0){

        issues <- c(
          issues,
          all_issues[["zoo_no_name"]]
        )

        is_valid <- FALSE

      }

      if(length(zoo_names) < length(names(tsl))){

        issues <- c(
          issues,
          all_issues[["zoo_missing_names"]]
        )

        is_valid <- FALSE

      }

      if(length(zoo_names) == length(names(tsl))){

        # zoo names are unique
        if(any(duplicated(zoo_names))){

          issues <- c(
            issues,
            all_issues[["zoo_duplicated_names"]]
          )

          is_valid <- FALSE

        }

        if(any(!(zoo_names %in% names(tsl)))){

          issues <- c(
            issues,
            all_issues[["zoo_different_names"]]
          )

          is_valid <- FALSE

        }

      }

      #run full test
      if(full == TRUE){

        # zoo objects have shared colnames
        zoo_colnames_shared <- tsl_colnames_get(
          tsl = tsl,
          names = "shared"
        )

        #check ignored for zoo vectors.
        if(!is.null(zoo_colnames_shared)){

          if(length(zoo_colnames_shared) == 0){

            issues <- c(
              issues,
              all_issues[["zoo_no_shared_columns"]]
            )

            is_valid <- FALSE

          }

        }

        #all columns in zoo objects are numeric
        zoo.columns.numeric <- sapply(
          X = tsl,
          FUN = function(x){

            #vector
            if(is.null(dim(x))){

              out <- is.numeric(x)

            } else {
              #matrix

              out <- apply(
                X = zoo::coredata(x),
                FUN = is.numeric,
                MARGIN = 2
              ) |>
                all()

            }

            out

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

      } #end of full == TRUE

    } #end of: elements in tsl are zoo objects

  } #end of: tsl is a list

  if(is_valid == FALSE){

    message(
      "This time series list is NOT VALID.\n",
      "The issue/s to address are:\n",
      paste(
        issues,
        collapse = "\n"
      )
    )

  }

  tsl

}

