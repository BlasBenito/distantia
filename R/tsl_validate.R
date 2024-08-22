#' Validate Time Series List
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
#' @param full (optional, logical) If TRUE, the function runs checks looking at all the individual values of the time series list. This makes the test slower, but more comprehensive. Default: FALSE
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
#' #run validation test
#' tsl <- tsl_validate(
#'   tsl = tsl,
#'   full = TRUE #to examine individual data values
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
#'   tsl = tsl,
#'   full = TRUE
#' )
tsl_validate <- function(
    tsl = NULL,
    full = FALSE
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
    if(is.null(names(tsl))){

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

      } else {

        # zoo names are unique
        if(any(duplicated(zoo_names))){

          issues <- c(
            issues,
            all_issues[["zoo_duplicated_names"]]
          )

          is_valid <- FALSE

        }

        if(any(zoo_names != names(tsl))){

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


#' Validate Time Series List
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
#' This function takes a time series list, and tries to make it comply with the rules listed above. Finally, it runs [tsl_validate()] and informs the user if there are any issues left.
#'
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param full (optional, logical) If TRUE, the function also subsets shared numeric columns across zoo objects and interpolates NA cases. Default: FALSE
#'
#' @return time series list
#' @export
#' @autoglobal
#' @examples
#' #TODO missing example here
tsl_make_valid <- function(
    tsl = NULL,
    full = FALSE
){

  # TODO: review this function's logic

  # tsl is not a list
  if(!is.list(tsl)){

    stop("Argument 'tsl' must be a list of zoo objects.")

  #tsl is a list
  } else {

    # tsl has no names
    if(is.null(names(tsl))){

      message("Naming items in object 'tsl'")

      tsl <- tsl_names_set(
        tsl = tsl
      )

    # tsl has names
    } else {

      # duplicated names
      if(any(duplicated(names(tsl)))){

        message("Deduplicating names of object 'tsl'.")

        tsl <- tsl_names_clean(
          tsl = tsl
        )

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

      message("Converting all objects within 'tsl' to the class 'zoo'.")

      tsl <- lapply(
        X = tsl,
        FUN = zoo::zoo
      )

      # elemenets in tsl are zoo objects
    } else {

      # zoo objects have names
      zoo_names <- tsl_names_get(
        tsl = tsl,
        zoo = TRUE
      )

      if(length(zoo_names) == 0){

        message("Naming zoo objects within 'tsl'.")

        tsl <- tsl_names_set(
          tsl = tsl
        )

      } else {

        # zoo names are unique
        if(any(duplicated(zoo_names))){

          message("Deduplicating names of zoo objects within 'tsl'.")

          tsl <- tsl_names_set(
            tsl = tsl
          )

        }

        if(any(zoo_names != names(tsl))){

          message("Renaming zoo objects to names in 'tsl'.")

          tsl <- tsl_names_set(
            tsl = tsl
          )

        }

      }

      #run full test
      if(full == TRUE){

        # cleaning names of zoo objects
        message("Cleaning column names of zoo objects.")

        tsl <- tsl_colnames_clean(
          tsl = tsl,
          lowercase = TRUE
        )

        # zoo objects have shared colnames
        zoo_colnames_shared <- tsl_colnames_get(
          tsl = tsl,
          names = "shared"
        )

        #check ignored for zoo vectors.
        if(!is.null(zoo_colnames_shared)){

          if(length(zoo_colnames_shared) == 0){

            stop("Zoo objects in 'tsl' must have at least one shared column name.")

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

          message("Selecting numeric columns from zoo objects")

          tsl <- tsl_subset(
            tsl = tsl,
            numeric_cols = TRUE
          )

        }

        # NA values
        na.count <- tsl_count_NA(
          tsl = tsl,
          quiet = TRUE
        ) |>
          unlist() |>
          sum()

        if(na.count > 0){

          message("Imputing NA values in zoo objects.")

          tsl <- tsl_handle_NA(
            tsl = tsl,
            na_action = "impute"
          )

        }

      } #end of full == TRUE

    } #end of: elements in tsl are zoo objects

  } #end of: tsl is a list

  tsl <- tsl_validate(
    tsl = tsl,
    full = full
  )

}
