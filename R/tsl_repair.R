
#' Repair a Time Series List
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
#' @param full (optional, logical) If TRUE, the function also subsets shared numeric columns across zoo objects and interpolates NA cases. Default: TRUE
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
tsl_repair <- function(
    tsl = NULL,
    full = TRUE
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

        tsl_old_names <- tsl_colnames_get(
          tsl = tsl,
          names = "all"
        ) |>
          unlist() |>
          unique()

        tsl <- tsl_colnames_clean(
          tsl = tsl,
          lowercase = TRUE
        )

        tsl_new_names <- tsl_colnames_get(
          tsl = tsl,
          names = "all"
        ) |>
          unlist() |>
          unique()

        if(any(!(tsl_new_names %in% tsl_old_names))){
          message("Cleaning column names of zoo objects in 'tsl'.")
        }

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

  tsl <- tsl_diagnose(
    tsl = tsl,
    full = full
  )

}
