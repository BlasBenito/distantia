#' Diagnose Issues in Time Series Lists
#'
#' @description
#' A Time Series List (`tsl` for short) is a named list of zoo time series. This type of object, not defined as a class, is used throughout the `distantia` package to contain time series data ready for processing and analysis.
#'
#' The structure and values of a `tsl` must fulfill several general conditions:
#'
#' Structure:
#' \itemize{
#'   \item List names match the attributes "name" of the zoo time series.
#'   \item Zoo time series must have at least one shared column name.
#'   \item The index (as extracted by [zoo::index()]) of all zoo objects must be of the same class (either "Date", "POSIXct", "numeric", or "integer").
#'   \item The "core data" (as extracted by [zoo::coredata()]) of univariate zoo time series must be of class "matrix".
#' }
#'
#' Values (optional, when `full = TRUE`):
#' \itemize{
#'   \item All time series have at least one shared numeric column.
#'   \item There are no NA, Inf, or NaN values in the time series.
#' }
#'
#' This function analyzes a `tsl` without modifying it to returns messages describing what conditions are not met, and provides hints on how to fix most issues.
#'
#' @param tsl (required, list of zoo time series) Time series list to diagnose. Default: NULL
#' @param full (optional, logical) If TRUE, a full diagnostic is triggered. Otherwise, only the data structure is tested. Default: TRUE
#'
#' @return time series list; messages
#' @export
#' @autoglobal
#' @examples
#' #creating three zoo time series with some NA values
#' x <- zoo_simulate(
#'   name = "x",
#'   cols = 1,
#'   na_fraction = 0.1
#'   )
#'
#' y <- zoo_simulate(
#'   name = "y",
#'   cols = 1,
#'   na_fraction = 0.1
#'   )
#'
#' z <- zoo_simulate(
#'   name = "z",
#'   cols = 1,
#'   na_fraction = 0.1
#'   )
#'
#' #adding a few structural issues
#'
#' #converting x to vector
#' x <- zoo::zoo(
#'   x = runif(nrow(x)),
#'   order.by = zoo::index(x)
#' )
#'
#' #changing the colname of z
#' colnames(z) <- c("b")
#'
#' #storing zoo objects in a list
#' #notice mismatched names with zoo objects
#' tsl <- list(
#'   a = x,
#'   b = y,
#'   c = z
#' )
#'
#' #running full diagnose
#' tsl <- tsl_diagnose(
#'   tsl = tsl,
#'   full = TRUE
#'   )
#' @family data_preparation
tsl_diagnose <- function(
    tsl = NULL,
    full = TRUE
){

  if(!is.logical(full)){
    stop("Argument 'full' must be TRUE to run a full diagnostic, and FALSE otherwise.")
  }

  if(is.null(tsl)){
    stop("Argument 'tsl' must not be NULL.")
  }

  if(!is.list(tsl)){
    stop("Argument 'tsl' must be a list.")
  }


  #all possible issues
  all_issues <- list(
    tsl_objects_zoo = " - elements of 'tsl' must be time series of the class 'zoo': coerce at once with tsl <- lapply(tsl, zoo::zoo) or individually with zoo::zoo().",
    tsl_names_null =  "  - elements of 'tsl' must be named: set names with distantia::tsl_names_set() or names(tsl) <- c(...).",
    tsl_names_duplicated = "  - elements of 'tsl' must have unique names: apply distantia::tsl_names_clean() to deduplicate names, or distantia::tsl_names_set() to set new ones.",
    zoo_no_name = "  - zoo time series must have the attribute 'name': apply distantia::tsl_names_set() to name them.",
    zoo_duplicated_names = "  - zoo time series must have unique names: apply distantia::tsl_names_clean() to deduplicate them.",
    zoo_different_names = "  - zoo time series and list items have different names:  apply distantia::tsl_names_set() to reset zoo names to list names.",
    zoo_no_shared_columns = "  - all zoo time series must have at least one shared column: use distantia::tsl_colnames_get() and distantia::ts_colnames_set() to identify and rename columns.",
    zoo_time_class = "  - index of all zoo time series must be of the same class ('Date', 'POSIXct', 'numeric', or 'integer'): use lapply(tsl, function(x) class(zoo::index(x))) to identify and remove or modify the objects with a mismatching class.",
    zoo_non_numeric_columns = "  - columns shared across all zoo objects must be of the class 'numeric': function distantia::tsl_subset() may help fix this issue.",
    zoo_NA_cases = "  - zoo time series have NA, Inf, -Inf, or NaN cases: interpolate or remove them with distantia::tsl_handle_NA().",
    zoo_no_matrix = "  - core data of univariate zoo time series must be of class 'matrix': use lapply(tsl, distantia::zoo_vector_to_matrix) to fix this issue."
  )

  # initialize feedback
  issues_structure <- vector()
  issues_values <- vector()

  #list

  # tsl has no names
  if(
    any(is.null(names(tsl)))
    ){

    issues_structure <- c(
      issues_structure,
      all_issues[["tsl_names_null"]]
    )

  } else {

    # duplicated names
    if(
      any(duplicated(names(tsl)))
    ){

      issues_structure <- c(
        issues_structure,
        all_issues[["tsl_names_duplicated"]]
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

    issues_structure <- c(
      issues_structure,
      all_issues[["tsl_objects_zoo"]]
    )

  }

  #all columns in zoo objects are matrices
  zoo.is.not.matrix <- sapply(
    X = tsl,
    FUN = function(x) !is.matrix(zoo::coredata(x))
  ) |>
    any()

  if(zoo.is.not.matrix){

    issues_structure <- c(
      issues_structure,
      all_issues[["zoo_no_matrix"]]
    )

  }

  # get zoo names
  zoo_names <- sapply(
    X = tsl,
    FUN = function(x) attributes(x)$name
  )

  # missing zoo names
  if(
     length(zoo_names) < length(tsl)
    ){

    issues_structure <- c(
      issues_structure,
      all_issues[["zoo_no_name"]]
    )

  }

  # zoo names are unique
  if(
    any(duplicated(zoo_names))
    ){

    issues_structure <- c(
      issues_structure,
      all_issues[["zoo_duplicated_names"]]
    )

  }

  #any zoo names different from list names
  if(
    any(!(zoo_names %in% names(tsl)))
    ){

    issues_structure <- c(
      issues_structure,
      all_issues[["zoo_different_names"]]
    )

  }

  #zoo colnames

  # zoo objects have shared colnames
  zoo_colnames_shared <- tsl_colnames_get(
    tsl = tsl,
    names = "shared"
  )

  #there are no shared columns
  if(
    any(is.na(zoo_colnames_shared))
    ){

    issues_structure <- c(
      issues_structure,
      all_issues[["zoo_no_shared_columns"]]
    )

  }

  #zoo time class
  zoo.time.classes <- tsl_time(
    tsl = tsl
  )$class

  if(
    length(zoo.time.classes) != 1
    ){

    issues_structure <- c(
      issues_structure,
      all_issues[["zoo_time_class"]]
    )

  }

  #run full test
  if(full == TRUE){

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

    if(
      zoo.columns.numeric == FALSE
      ){

      issues_values <- c(
        issues_values,
        all_issues[["zoo_non_numeric_columns"]]
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

      issues_values <- c(
        issues_values,
        all_issues[["zoo_NA_cases"]]
      )

    }

  } #end of full == TRUE

  if(length(issues_structure) > 0){

    message(
      "Structural issues:\n",
      "------------------\n\n",
      paste(
        issues_structure,
        collapse = "\n\n"
      )
    )

  }

  if(length(issues_values) > 0){

    message(
      "\n\nValue-related issues:\n",
      "-------------------------\n\n",
      paste(
        issues_values,
        collapse = "\n\n"
      )
    )

  }

  tsl

}

