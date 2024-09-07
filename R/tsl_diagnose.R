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
#'   tsl = tsl
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

  utils_check_tsl(
    tsl = tsl,
    min_length = 1
  )

  #all possible issues
  all_issues <- list(
    tsl_names_null =  "  - elements of 'tsl' must be named: functions distantia::tsl_names_set() or names(tsl) <- c(...) to fix this issue.",
    tsl_names_duplicated = "  - elements of 'tsl' must have unique names: functions distantia::tsl_names_clean() or names(tsl) <- c(...) to fix this issue.",
    tsl_objects_zoo = "  - objects in 'tsl' must be of the class 'zoo'.",
    zoo_no_name = "  - zoo objects in 'tsl' must have the attribute 'name': function distantia::tsl_names_set() or distantia::ts_repair() may help fix this issue.",
    zoo_duplicated_names = "  - zoo objects in 'tsl' must have unique names: functions distantia::tsl_names_clean() or distantia::ts_repair() may help fix this issue.",
    zoo_different_names = "  - zoo objects and list items have different names:  functions distantia::tsl_names_set() or distantia::tsl_repair() may help fix this issue.",
    zoo_missing_names = "  - zoo objects in 'tsl' have no attribute 'name': functions distantia::tsl_names_set() or distantia::tsl_repair() may help fix this issue.",
    zoo_no_shared_columns = "  - zoo objects in 'tsl' must have at least one shared column: function distantia::tsl_colnames_get() may help identify shared and/or exclusive columns.",
    zoo_non_numeric_columns = "  - all columns of zoo objects in 'tsl' must be of class 'numeric': function distantia::tsl_subset() may help fix this issue.",
    zoo_NA_cases = "  - zoo objects in 'tsl' have NA cases: interpolate or remove them with distantia::tsl_handle_NA() or distantia::tsl_repair() to fix this issue.",
    zoo_no_matrix = "  - univariate zoo objects in 'tsl' must be matrices rather than vectors: function distantia::tsl_repair() may help fix this issue."
  )

  # initialize feedback
  issues <- vector()
  is_valid <- TRUE

  #list properties

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

  # get zoo names
  zoo_names <- tsl_names_get(
    tsl = tsl,
    zoo = TRUE
  )

  # no zoo names
  if(length(zoo_names) == 0){

    issues <- c(
      issues,
      all_issues[["zoo_no_name"]]
    )

    is_valid <- FALSE

  }

  #only a few zoo names
  if(length(zoo_names) < length(names(tsl))){

    issues <- c(
      issues,
      all_issues[["zoo_missing_names"]]
    )

    is_valid <- FALSE

  }

  #all zoo objects are named
  if(length(zoo_names) == length(names(tsl))){

    # zoo names are unique
    if(any(duplicated(zoo_names))){

      issues <- c(
        issues,
        all_issues[["zoo_duplicated_names"]]
      )

      is_valid <- FALSE

    }

    #any zoo names different from list names
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

    #some objects have no shared columns
    if(any(is.na(zoo_colnames_shared))){

      wrong_zoos <- names(zoo_colnames_shared[is.na(zoo_colnames_shared)])

      issues <- c(
        issues,
        paste0("  - zoo object/s '", paste0(wrong_zoos, collapse = "', '"), "' in 'tsl' have no shared columns with other zoo objects: functions distantia::tsl_colnames_clean() or distantia::tsl_colnames_set() may help fix this issue.")
      )

      is_valid <- FALSE

    }

    #there are no shared columns
    if(all(is.na(zoo_colnames_shared))){

      issues <- c(
        issues,
        all_issues[["zoo_no_shared_columns"]]
      )

      is_valid <- FALSE

    }

    #all columns in zoo objects are matrices
    zoo.is.matrix <- lapply(
      X = tsl,
      FUN = is.matrix
    ) |>
      unlist()

    if(any(zoo.is.matrix == FALSE)){

      issues <- c(
        issues,
        all_issues[["zoo_no_matrix"]]
      )

      is_valid <- FALSE

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





  if(is_valid == FALSE){

    message(
      "Argument 'tsl' is NOT VALID:.\n\n",
      paste(
        issues,
        collapse = "\n\n"
      )
    )

  }

  tsl

}

