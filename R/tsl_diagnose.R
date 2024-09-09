#' Diagnose Issues in Time Series Lists
#'
#' @description
#' A Time Series List (`tsl` for short) is a list of zoo time series. This type of object, not defined as a class, is used throughout the `distantia` package to handle time series processing and analysis. The structure and values of `tsl` must fulfill several conditions:
#'
#' Structure:
#' \itemize{
#'   \item Argument `tsl` is a named list of zoo time series
#'   \item The list names match the attributes "name" of the zoo time series
#'   \item All zoo time series must have at least one shared column name.
#'   \item Data in univariate zoo time series (as extracted by `zoo::coredata(x)`) must be of the class "matrix". Univariate zoo time series are often represented as vectors, but this breaks several subsetting and transformation operations implemented in this package.
#' }
#'
#' Values (optional):
#' \itemize{
#'   \item All time series have at least one shared numeric column.
#'   \item There are no NA, Inf, or NaN values in the time series.
#' }
#'
#' This function analyzes a `tsl` to returns messages describing what conditions are not met, and provides hints on how to fix most issues.
#'
#' @param tsl (required, list of zoo time series) Time series list to diagnose. Default: NULL
#' @param full (optional, logical) If TRUE, the function also checks all individual values. Default: TRUE
#'
#' @return time series list, and messages describing detected issues
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

  utils_check_args_tsl(
    tsl = tsl,
    min_length = 1
  )

  #all possible issues
  all_issues <- list(
    tsl_names_null =  "  - elements of 'tsl' must be named: functions distantia::tsl_names_set() or names(tsl) <- c(...) to fix this issue.",
    tsl_names_duplicated = "  - elements of 'tsl' must have unique names: functions distantia::tsl_names_clean() or names(tsl) <- c(...) to fix this issue.",
    zoo_no_name = "  - all zoo objects in 'tsl' must have the attribute 'name': function distantia::tsl_names_set() or distantia::ts_repair() may help fix this issue.",
    zoo_duplicated_names = "  - zoo objects in 'tsl' must have unique names: functions distantia::tsl_names_clean() or distantia::ts_repair() may help fix this issue.",
    zoo_different_names = "  - zoo objects and list items have different names:  functions distantia::tsl_names_set() or distantia::tsl_repair() may help fix this issue.",
    zoo_no_shared_columns = "  - zoo objects in 'tsl' must have at least one shared column: function distantia::tsl_colnames_get() may help identify shared and/or exclusive columns.",
    zoo_non_numeric_columns = "  - all shared columns of zoo objects in 'tsl' must be of class 'numeric': function distantia::tsl_subset() may help fix this issue.",
    zoo_NA_cases = "  - zoo objects in 'tsl' have NA, Inf, -Inf, or NaN cases: interpolate or remove them with distantia::tsl_handle_NA() or distantia::tsl_repair() to fix this issue.",
    zoo_no_matrix = "  - univariate zoo objects in 'tsl' must be matrices rather than vectors: function distantia::tsl_repair() may help fix this issue."
  )

  # initialize feedback
  issues_structure <- vector()
  issues_values <- vector()

  #list properties
  tsl_names <- names(tsl)

  # tsl has no names
  if(
    any(is.null(names(tsl)))
    ){

    issues_structure <- c(
      issues_structure,
      all_issues[["tsl_names_null"]]
    )

  }

  # duplicated names
  if(
    any(duplicated(names(tsl)))
    ){

    issues_structure <- c(
      issues_structure,
      all_issues[["tsl_names_duplicated"]]
    )

  }

  #zoo objects

  # get zoo names
  zoo_names <- lapply(
    X = tsl,
    FUN = function(x) attributes(x)$name
  ) |>
    unlist()

  # no zoo names
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
    any(!(zoo_names %in% tsl_names))
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

  #all columns in zoo objects are matrices
  zoo.is.matrix <- lapply(
    X = tsl,
    FUN = is.matrix
  ) |>
    unlist()

  if(
    any(zoo.is.matrix == FALSE)
    ){

    issues_structure <- c(
      issues_structure,
      all_issues[["zoo_no_matrix"]]
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
      "Issues with tsl structure:\n",
      "--------------------------\n\n",
      paste(
        issues_structure,
        collapse = "\n\n"
      )
    )

  }

  if(length(issues_values) > 0){

    message(
      "\n\nIssues with tsl values:\n",
      "-----------------------\n\n",
      paste(
        issues_values,
        collapse = "\n\n"
      )
    )

  }

  tsl

}

