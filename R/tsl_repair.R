#' Repair Issues in Time Series Lists
#'
#' @description
#' A Time Series List (`tsl` for short) is a list of zoo time series. This type of object, not defined as a class, is used throughout the `distantia` package to contain time series data ready for processing and analysis.
#'
#' The structure and values of a `tsl` must fulfill several general conditions:
#'
#' Structure:
#' \itemize{
#'   \item The list names match the attributes "name" of the zoo time series
#'   \item All zoo time series must have at least one shared column name.
#'   \item Data in univariate zoo time series (as extracted by `zoo::coredata(x)`) must be of the class "matrix". Univariate zoo time series are often represented as vectors, but this breaks several subsetting and transformation operations implemented in this package.
#' }
#'
#' Values (optional, when `full = TRUE`):
#' \itemize{
#'   \item All time series have at least one shared numeric column.
#'   \item There are no NA, Inf, or NaN values in the time series.
#' }
#'
#' This function analyzes a `tsl`, and tries to fix all possible issues to make it comply with the conditions listed above without any user input. Use with care, as it might defile your data.
#'
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param full (optional, logical) If TRUE, a full repair (structure and values) is triggered. Otherwise, only the data structure is repaired Default: TRUE
#'
#' @return time series list
#' @export
#' @autoglobal
#' @examples
#' #creating three zoo time series
#'
#' #one with NA values
#' x <- zoo_simulate(
#'   name = "x",
#'   cols = 1,
#'   na_fraction = 0.1
#'   )
#'
#' #with different number of columns
#' #wit repeated name
#' y <- zoo_simulate(
#'   name = "x",
#'   cols = 2
#'   )
#'
#' #with different time class
#' z <- zoo_simulate(
#'   name = "z",
#'   cols = 1,
#'   time_range = c(1, 100)
#'   )
#'
#' #adding a few structural issues
#'
#' #changing the column name of x
#' colnames(x) <- c("b")
#'
#' #converting z to vector
#' z <- zoo::zoo(
#'   x = runif(nrow(z)),
#'   order.by = zoo::index(z)
#' )
#'
#' #storing zoo objects in a list
#' #with mismatched names
#' tsl <- list(
#'   a = x,
#'   b = y,
#'   c = z
#' )
#'
#' #running full diagnose
#' tsl_diagnose(
#'   tsl = tsl,
#'   full = TRUE
#'   )
#'
#' tsl <- tsl_repair(tsl)
#' @family tsl_management
tsl_repair <- function(
    tsl = NULL,
    full = TRUE
){

  utils_check_args_tsl(
    tsl = tsl,
    min_length = 1
  )

  if(!is.logical(full)){
    stop("distantia::tsl_repair(): argument 'full' must be TRUE to run a full repair, and FALSE otherwise.", call. = FALSE)
  }

  if(is.null(tsl)){
    stop("distantia::tsl_repair(): argument 'tsl' must not be NULL.", call. = FALSE)
  }

  if(!is.list(tsl)){
    stop("distantia::tsl_repair(): argument 'tsl' must be a list.", call. = FALSE)
  }

  #all possible issues
  all_issues <- list(
    tsl_objects_zoo = "  - coerced objects in 'tsl' to the class 'zoo'.",
    zoo_no_matrix = "  - converted univariate zoo vectors to matrix.",
    tsl_names_issues =  "  - fixed naming issues.",
    zoo_non_numeric_columns = "  - removed non-numeric columns from time series.",
    zoo_no_colnames = "  - REPAIR FAILED: cannot repair missing column names in zoo time series.",
    zoo_no_shared_columns = "  - REPAIR FAILED: no valid shared column names found across all time series.",
    zoo_duplicated_colnames = "  - deduplicated column names of zoo time series.",
    zoo_shared_columns = "  - removed exclusive columns not shared across time series.",
    zoo_NA_cases = "  - interpolated NA cases in zoo objects with distantia::tsl_handle_NA()."
  )

  # initialize feedback
  issues_structure <- vector()
  issues_values <- vector()

  #structural fixes

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

    tsl <- lapply(
      X = tsl,
      FUN = zoo::zoo
    )

  } else {

    #univariate zoo to matrix

    #all zoo objects are matrices
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

      #convert vectors to matrix
      tsl <- lapply(
        X = tsl,
        FUN = zoo_vector_to_matrix
      )

    }

  }

  #naming issues
  if(
    tsl_names_test(tsl = tsl) == FALSE
    ){

    issues_structure <- c(
      issues_structure,
      all_issues[["tsl_names_issues"]]
    )

    tsl <- tsl_names_set(
      tsl = tsl
    ) |>
      suppressMessages()

  }

  # zoo colnames
  zoo_colnames_all <- tsl_colnames_get(
    tsl = tsl,
    names = "all"
  )

  if(any(unlist(zoo_colnames_all) == "unnamed")){

    #cannot repair this automatically
    issues_structure <- c(
      issues_structure,
      all_issues[["zoo_no_colnames"]]
    )

  }

  #test for duplicated colnames
  zoo_colnames_duplicated <- lapply(
    X = zoo_colnames_all,
    FUN = duplicated
  ) |>
    unlist() |>
    any()

  if(zoo_colnames_duplicated){

    issues_structure <- c(
      issues_structure,
      all_issues[["zoo_duplicated_colnames"]]
    )

    tsl <- tsl_colnames_clean(
      tsl = tsl
    )

  }

  zoo_colnames_shared <- tsl_colnames_get(
    tsl = tsl,
    names = "shared"
  )

  #there are no shared columns
  if(
    all(is.na(zoo_colnames_shared))
    ){

    issues_structure <- c(
      issues_structure,
      all_issues[["zoo_no_shared_columns"]]
    )

  }

  zoo_colnames_exclusive <- tsl_colnames_get(
    tsl = tsl,
    names = "exclusive"
  ) |>
    unlist() |>
    unique()

  if(any(!is.na(zoo_colnames_exclusive))){

    issues_structure <- c(
      issues_structure,
      all_issues[["zoo_shared_columns"]]
    )

    tsl <- tsl_subset(
      tsl = tsl,
      numeric_cols = FALSE,
      shared_cols = TRUE
    ) |>
      suppressWarnings()

  }


  #zoo time class
  zoo.time.classes <- tsl_time(
    tsl = tsl
  )$class |>
    table() |>
    sort(decreasing = TRUE)

  if(length(zoo.time.classes) != 1){

    issues_structure <- c(
      issues_structure,
      all_issues[["zoo_time_class"]]
    )

    majority.class <- names(zoo.time.classes)[1]

    #TODO add new tsl_time_class() function here

  }

  #full repair
  if(full == TRUE){

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

      issues_values <- c(
        issues_values,
        all_issues[["zoo_non_numeric_columns"]]
      )

      tsl <- tsl_subset(
        tsl = tsl,
        numeric_cols = TRUE,
        shared_cols = FALSE
      )

    }

    # NA values
    na.count <- tsl_count_NA(
      tsl = tsl
    ) |>
      unlist() |>
      sum()

    if(na.count > 0){

      issues_values <- c(
        issues_values,
        all_issues[["zoo_NA_cases"]]
      )

      tsl <- tsl_handle_NA(
        tsl = tsl,
        na_action = "impute"
      )

    }

  }

  #end of full == TRUE



  if(length(issues_structure) > 0){

    message(
      "distantia::tsl_repair(): Structural repairs:\n",
      "--------------------------\n\n",
      paste(
        issues_structure,
        collapse = "\n\n"
      )
    )

  }

  if(length(issues_values) > 0){

    message(
      "\n\nValue-related repairs:\n",
      "--------------------------\n\n",
      paste(
        issues_values,
        collapse = "\n\n"
      )
    )

  }

  tsl_diagnose(
    tsl = tsl,
    full = TRUE
  )

  tsl

}
