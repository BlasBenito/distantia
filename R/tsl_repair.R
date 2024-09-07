#' Repair Issues in Time Series Lists
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
#' This function takes a time series list, and tries to make it comply with the rules listed above. Finally, it runs [tsl_diagnose()] and informs the user if there are any issues left to fix.
#'
#'
#' @param tsl (required, list) Time series list. Default: NULL
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
tsl_repair <- function(
    tsl = NULL
){

  #TODO: review this functions logic along with tsl_diagnose().

  utils_check_tsl(
    tsl = tsl,
    min_length = 1
  )

  #all possible issues
  all_issues <- list(
    tsl_names_null =  "  - named 'tsl' elements with distantia::tsl_names_set().",
    tsl_names_duplicated = "  - deduplicated names 'tsl' with distantia::tsl_names_clean().",
    tsl_objects_zoo = "  - coerced objects in 'tsl' to the class 'zoo'.",
    zoo_no_name = "  - named zoo objects in 'tsl' with distantia::tsl_names_set().",
    zoo_duplicated_names = "  - deduplicated names of zoo objects in 'tsl' with distantia::tsl_names_clean().",
    zoo_different_names = "  - matched names of 'tsl' and its zoo objects with distantia::tsl_names_set().",
    zoo_missing_names = "  - named zoo objects in 'tsl' with distantia::tsl_names_set().",
    zoo_no_shared_columns = "  - removed zoo objects with no shared columns with other zoo objects with distantia::tsl_subset().",
    zoo_non_numeric_columns = "  - removed non-numeric columns from zoo objects with distantia::tsl_subset().",
    zoo_NA_cases = "  - interpolated NA cases in zoo objects with distantia::tsl_handle_NA().",
    zoo_no_matrix = "  - converted univariate zoo vectors to matrix.."
  )

  # initialize feedback
  issues <- vector()

  #list properties

  # tsl has no names
  if(any(is.null(names(tsl)))){

    issues <- c(
      issues,
      all_issues[["tsl_names_null"]]
    )

    tsl <- tsl_names_set(
      tsl = tsl
    )

    # duplicated names
    if(any(duplicated(names(tsl)))){

      issues <- c(
        issues,
        all_issues[["tsl_names_duplicated"]]
      )

      tsl <- tsl_names_clean(
        tsl = tsl
      )

    }

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

      tsl <- lapply(
        X = tsl,
        FUN = zoo::zoo
      )

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

      tsl <- tsl_names_set(
        tsl = tsl
      )

    }

    #only a few zoo names
    if(length(zoo_names) < length(names(tsl))){

      issues <- c(
        issues,
        all_issues[["zoo_missing_names"]]
      )

      tsl <- tsl_names_set(
        tsl = tsl
      )

    }

    #all zoo objects are named
    if(length(zoo_names) == length(names(tsl))){

      # zoo names are unique
      if(any(duplicated(zoo_names))){

        issues <- c(
          issues,
          all_issues[["zoo_duplicated_names"]]
        )

        tsl <- tsl_names_clean(
          tsl = tsl
        )

      }

      #any zoo names different from list names
      if(any(!(zoo_names %in% names(tsl)))){

        issues <- c(
          issues,
          all_issues[["zoo_different_names"]]
        )

        tsl <- tsl_names_set(
          tsl = tsl
        )

      }

    }

    # zoo objects have shared colnames
    zoo_colnames_shared <- tsl_colnames_get(
      tsl = tsl,
      names = "shared"
    ) |>
      unlist() |>
      unique()

    #some objects have no shared columns
    if(any(is.na(zoo_colnames_shared))){

      issues <- c(
        issues,
        all_issues[["zoo_no_shared_columns"]]
      )

      #TODO: subset does not yet remove objects without shared columns
      tsl <- tsl_subset(
        tsl = tsl,
        numeric_cols = FALSE,
        shared_cols = TRUE
      )

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

      tsl.colnames <- tsl_colnames_get(
        tsl = tsl,
        names = "all"
      ) |>
        unlist() |>
        unique() |>
        stats::na.omit()

      #convert vectors to matrix
      tsl <- lapply(
        X = tsl,
        FUN = function(x){

          #if not matrix
          if(is.vector(zoo::coredata(x))){

            y <- as.matrix(zoo::coredata(x))

            #set colnames if unique
            if(length(tsl.colnames) == 1){
              colnames(y) <- tsl.colnames
            }

            y <- zoo::zoo(
              x = as.matrix(y),
              order.by = zoo::index(x)
            )

            x.name <- zoo_name_get(x = x) |>
              suppressWarnings()

            if(!is.null(x.name)){
              y <- zoo_name_set(
                x = y,
                name = x.name
              )
            }

            return(y)

          }

          return(x)

        }
      )

      #reset names
      tsl <- tsl_names_set(
        tsl = tsl
      )

      #TODO: tsl_colnames_set() could use common column names if number of columns of zoo without column names is the same?

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

      tsl <- tsl_subset(
        tsl = tsl,
        numeric_cols = TRUE,
        shared_cols = FALSE
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

      issues <- c(
        issues,
        all_issues[["zoo_NA_cases"]]
      )

      tsl <- tsl_handle_NA(
        tsl = tsl,
        na_action = "impute"
      )

    }

    #end of full == TRUE

    #there are no shared columns
    if(all(is.na(zoo_colnames_shared))){

      stop("Zoo objects in 'tsl' must have at least one shared column name.")

    }

  }

  if(length(issues) > 0){

    message(
      "Repair operations:.\n\n",
      paste(
        issues,
        collapse = "\n\n"
      )
    )

  }

  message("\nRe-diagnosing argument 'tsl':\n")

  tsl <- tsl_diagnose(
    tsl = tsl,
    full = TRUE
  )

  tsl

}
