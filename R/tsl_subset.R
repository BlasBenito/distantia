#' Subset Time Series Lists by Time Series Names, Time, and/or Column Names
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param names (optional, character or numeric vector) Character vector of names or numeric vector with list indices. If NULL, all time series are kept. Default: NULL
#' @param colnames (optional, character vector) Column names of the zoo objects in `tsl`. If NULL, all columns are returned. Default: NULL
#' @param time (optional, numeric vector) time vector of length two used to subset rows by time. If NULL, all rows in `tsl` are preserved. Default: NULL
#' @param numeric_cols (optional, logical) If TRUE, only the numeric columns of the zoo objects are returned. Default: TRUE
#' @param shared_cols (optional, logical) If TRUE, only columns shared across all zoo objects are returned. Default: TRUE
#'
#' @return time series list
#' @export
#' @autoglobal
#' @examples
#' #initialize time series list
#' tsl <- tsl_initialize(
#'   x = fagus_dynamics,
#'   name_column = "name",
#'   time_column = "time"
#' )
#'
#' #checking available dimensions
#'
#' #names
#' tsl_names_get(
#'   tsl = tsl
#' )
#'
#' #colnames
#' tsl_colnames_get(
#'   tsl = tsl
#' )
#'
#' #time
#' tsl_time(
#'   tsl = tsl
#' )[, c("name", "begin", "end")]
#'
#' #subset
#' tsl_new <- tsl_subset(
#'   tsl = tsl,
#'   names = c("Sweden", "Germany"),
#'   colnames = c("rainfall", "temperature"),
#'   time = c("2010-01-01", "2015-01-01")
#' )
#'
#' #check new dimensions
#'
#' #names
#' tsl_names_get(
#'   tsl = tsl_new
#' )
#'
#' #colnames
#' tsl_colnames_get(
#'   tsl = tsl_new
#' )
#'
#' #time
#' tsl_time(
#'   tsl = tsl_new
#' )[, c("name", "begin", "end")]
#' @family tsl_management
tsl_subset <- function(
    tsl = NULL,
    names = NULL,
    colnames = NULL,
    time = NULL,
    numeric_cols = TRUE,
    shared_cols = TRUE
){

  utils_check_args_tsl(
    tsl = tsl,
    min_length = 1
  )

  #coerce zoo vectors to matrices
  tsl <- future.apply::future_lapply(
    X = tsl,
    FUN = zoo_vector_to_matrix
  )

  # subset names ----
  if(!is.null(names)){

    ## names is a character ----
    if(is.character(names)){

      names <- match.arg(
        arg = names,
        choices = names(tsl),
        several.ok = TRUE
      ) |>
        unique()

    }

    # names is numeric ----
    if(is.numeric(names)){

      names <- names[
        names > 0 &
          names <= length(tsl)
      ] |>
        as.integer() |>
        unique()

    }

    tsl <- tsl[names]

  }

  #get names to track missing time series
  zoo_names <- tsl_names_get(
    tsl = tsl,
    zoo = TRUE
  )

  # subset colnames ----
  if(!is.null(colnames)){

    #get all variable names
    all_colnames <- tsl_colnames_get(
      tsl = tsl,
      names = "all"
    ) |>
      unlist() |>
      unique()

    colnames <- match.arg(
      arg = colnames,
      choices = all_colnames,
      several.ok = TRUE
    ) |>
      unique()

    tsl <- future.apply::future_lapply(
      X = tsl,
      FUN = function(x){

        x_name <- attributes(x)$name

        x <- x[, colnames, drop = FALSE]

        zoo_name_set(
          x = x,
          name = x_name
        )

      }
    )

  }

  # subset numeric cols
  if(numeric_cols == TRUE){

    #returns NA if no columns are numeric
    tsl <- future.apply::future_lapply(
      X = tsl,
      FUN = function(x){

        x.num.cols <- apply(
          X = x,
          MARGIN = 2,
          FUN = is.numeric
        )

        if(all(x.num.cols) == FALSE){
          return(NA)
        }

        y <- x[
          ,
          x.num.cols,
          drop = FALSE
        ]

        zoo_name_set(
          x = y,
          name = attributes(x)$name
        )

      }
    )

    #names of elements with no numeric columns
    tsl.na <- names(tsl)[is.na(tsl)]

    if(length(tsl.na) > 0){

      tsl <- tsl[!names(tsl) %in% tsl.na]

      warning(
        "distantia::tsl_subset(): the following zoo object/s in 'tsl' have no numeric columns and have been removed: ",
        paste(tsl.na, collapse = ", "),
        ".",
        call. = FALSE
        )

    }

  }

  #subset shared cols
  if(
    shared_cols == TRUE &&
    length(tsl) > 1
    ){

    exclusive_cols <- tsl_colnames_get(
      tsl = tsl,
      names = "exclusive"
    ) |>
      unlist() |>
      unique() |>
      stats::na.omit()

    shared_cols <- tsl_colnames_get(
      tsl = tsl,
      names = "shared"
    ) |>
      unlist() |>
      unique() |>
      stats::na.omit()

    if(length(shared_cols) == 0){

      warning("distantia::tsl_subset(): zoo objects within 'tsl' have no shared columns. Ignoring subsetting of shared columns.", call. = FALSE)

    } else {

      tsl <- future.apply::future_lapply(
        X = tsl,
        FUN = function(x){

          y <- x[
            ,
            colnames(x) %in% shared_cols,
            drop = FALSE
          ]

          zoo_name_set(
            x = y,
            name = attributes(x)$name
          )

        }
      )

    }

  }

  # subset time ----
  if(!is.null(time)){

    if(length(time) < 2){
      stop("distantia::tsl_subset(): argument 'time' must be of length 2.", call. = FALSE)
    }

    if(length(time) > 2){
      time <- range(time)
    }

    tsl_time_df <- tsl_time(
      tsl = tsl
    )

    tsl_time_range <- range(
      c(
        tsl_time_df$begin,
        tsl_time_df$end
      )
    )

    time <- utils_coerce_time_class(
      x = time,
      to = tsl_time_df$class[1]
    ) |>
      range()

    if(
      max(time) < min(tsl_time_range) ||
      min(time) > max(tsl_time_range)
    ){

      warning(
        "distantia::tsl_subset(): Argument time must be a vector of class '",
        tsl_time_df$class[1],
        " ' with values between ",
        min(tsl_time_range),
        " and ",
        max(tsl_time_range),
        ". Ignoring subset by time.",
        call. = FALSE
      )

    } else {

      #subset by time
      tsl <- future.apply::future_lapply(
        X = tsl,
        FUN = function(x){

          y <- stats::window(
            x = x,
            start = min(time),
            end = max(time)
          )

          if(nrow(y) == 0){
            return(NULL)
          }

          zoo_name_set(
            x = y,
            name = attributes(x)$name
          )

        }

      )

      #remove NULL elements
      tsl <- Filter(Negate(is.null), tsl)

      tsl_removed <- setdiff(
        x = zoo_names,
        y = tsl_names_get(
          tsl = tsl,
          zoo = TRUE
        )
      )

      if(length(tsl_removed) > 0){
        warning(
          "distantia::tsl_subset(): There following time series do not overlap with 'time' and have been removed: ",
          paste0(tsl_removed, collapse = ", "),
          ".",
          call. = FALSE
        )

      }

    }

  }

  tsl

}
