#' Handle NA Cases in Time Series Lists
#'
#' @description
#' Removes or imputes NA cases in time series lists. Imputation is done via interpolation against time via [zoo::na.approx()], and if there are still leading or trailing NA cases after NA interpolation, then [zoo::na.spline()] is applied as well to fill these gaps. Interpolated values are forced to fall within the observed data range.
#'
#' This function supports a parallelization setup via [future::plan()], and progress bars provided by the package [progressr](https://CRAN.R-project.org/package=progressr).
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param na_action (required, character) NA handling action. Available options are:
#' \itemize{
#'   \item "impute" (default): NA cases are interpolated from neighbors as a function of time (see [zoo::na.approx()] and [zoo::na.spline()]).
#'   \item "omit": rows with NA cases are removed.

#' }
#'
#' @return time series list
#' @export
#'
#' @examples
#'
#' #parallelization setup (not worth it for this data size)
#' future::plan(
#'  future::multisession,
#'  workers = 2 #set to parallelly::availableCores() - 1
#' )
#'
#' #progress bar
#' # progressr::handlers(global = TRUE)
#'
#' #tsl with NA cases
#' tsl <- tsl_simulate(
#'   na_fraction = 0.25
#' )
#'
#' tsl_count_NA(tsl = tsl)
#'
#' if(interactive()){
#'   #issues warning
#'   tsl_plot(tsl = tsl)
#' }
#'
#' #omit NA (default)
#' #--------------------------------------
#'
#' #original row count
#' tsl_nrow(tsl = tsl)
#'
#' #remove rows with NA
#' tsl_no_na <- tsl_handle_NA(
#'   tsl = tsl,
#'   na_action = "omit"
#' )
#'
#' #count rows again
#' #large data loss in this case!
#' tsl_nrow(tsl = tsl_no_na)
#'
#' #count NA again
#' tsl_count_NA(tsl = tsl_no_na)
#'
#' if(interactive()){
#'   tsl_plot(tsl = tsl_no_na)
#' }
#'
#'
#' #impute NA with zoo::na.approx
#' #--------------------------------------
#'
#' #impute NA cases
#' tsl_no_na <- tsl_handle_NA(
#'   tsl = tsl,
#'   na_action = "impute"
#' )
#'
#' #count rows again
#' #large data loss in this case!
#' tsl_nrow(tsl = tsl_no_na)
#'
#' if(interactive()){
#'   tsl_plot(tsl = tsl_no_na)
#' }
#'
#' #disable parallelization
#' future::plan(
#'   future::sequential
#' )
#' @family tsl_management
tsl_handle_NA <- function(
    tsl = NULL,
    na_action = c(
      "impute",
      "omit"
      )
){

  utils_check_args_tsl(
    tsl = tsl,
    min_length = 1
  )

  #replaces Inf with Na
  tsl <- tsl_Inf_to_NA(
    tsl = tsl
  )

  #replaces NaN with NA
  tsl <- tsl_NaN_to_NA(
    tsl = tsl
  )

  na_action <- match.arg(
    arg = na_action[1],
    choices = c(
      "omit",
      "impute"
    ),
    several.ok = FALSE
  )

  #progress bar
  p <- progressr::progressor(along = tsl)

  if(na_action == "omit"){

    tsl <- future.apply::future_lapply(
      X = tsl,
      FUN = function(x){

        p()

        stats::na.omit(x)

      }
    )

  }


  if(na_action == "impute"){

    tsl <- future.apply::future_lapply(
      X = tsl,
      FUN = function(x){

        p()

        #check if x is integer
        x.integer <- is.integer(x)

        #get time
        x.index <- zoo::index(x)

        #find minimum and maximum to clamp interpolation bounds
        x.min <- lapply(
          X = x,
          FUN = min,
          na.rm = TRUE
        )

        x.max <- lapply(
          X = x,
          FUN = max,
          na.rm = TRUE
        )

        #interpolate with the given function
        x.interpolated <- zoo::na.approx(
          object = x,
          na.rm = FALSE
          )

        #remove leading or trailing NAs
        if(sum(is.na(x.interpolated)) > 0){

          x.interpolated <- zoo::na.spline(
            object = x.interpolated
          )

        }

        #setting minimum and maximum bounds
        for(i in seq_len(length(x.min))){
          x.interpolated[x.interpolated[, i] < x.min[[i]], i] <- x.min[[i]]
          x.interpolated[x.interpolated[, i] > x.max[[i]], i] <- x.max[[i]]
        }

        if(x.integer == TRUE){
          mode(x.interpolated) <- "integer"
        }

        x.interpolated <- zoo::zoo(
          x = x.interpolated,
          order.by = x.index
        )

        x.interpolated

      }
    )

  }

  na.count <- tsl_count_NA(
    tsl = tsl
  )

  tsl <- tsl_names_set(
    tsl = tsl
  )

  tsl

}


#' @rdname tsl_handle_NA
#' @export
#' @autoglobal
tsl_Inf_to_NA <- function(
    tsl = NULL
){

  utils_check_args_tsl(
    tsl = tsl,
    min_length = 1
  )

  tsl <- future.apply::future_lapply(
    X = tsl,
    FUN = function(x){

      y <- as.matrix(x)

      y[is.infinite(y)] <- NA

      y <- zoo::zoo(
        x = y,
        order.by = zoo::index(x)
      )

      zoo_name_set(
        x = y,
        name = attributes(x)$name
      )

    }
  )

  tsl

}

#' @rdname tsl_handle_NA
#' @export
#' @autoglobal
tsl_NaN_to_NA <- function(
    tsl = NULL
){

  utils_check_args_tsl(
    tsl = tsl,
    min_length = 1
  )

  tsl <- future.apply::future_lapply(
    X = tsl,
    FUN = function(x){
      x[is.nan(x)] <- NA
      x
    }
  )

  tsl

}
