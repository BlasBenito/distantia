#' Title
#'
#' @param tsl (required, list of zoo objects) List of time series. Default: NULL
#' @param tsl_test (optional, logical) If TRUE, a validity test on the argument `tsl` is performed by [tsl_is_valid()]. It might be useful to set it to TRUE if something goes wrong while executing this function. Default: FALSE
#' @param f (required, transformation function) name of a function taking a matrix as input. Currently, the following options are implemented:
#' \itemize{
#'   \item f_proportion: proportion computed by row.
#'   \item f_percentage: percentage computed by row.
#'   \item f_hellinger: Hellinger transformation computed by row
#'   \item f_scale: Centering and scaling computed by column using the overall mean and standard deviation across all zoo objects within `tsl`.
#' }
#' @param ... (optional, arguments of `f`) Optional arguments for the transformation function.
#'
#' @return time series list
#' @export
#' @autoglobal
#' @examples
tsl_transform <- function(
    tsl = NULL,
    tsl_test = FALSE,
    f = NULL,
    ...
){

  tsl <- tsl_is_valid(
    tsl = tsl,
    tsl_test = tsl_test
  )

  if(is.null(f)){

    stop(
      "Argument 'f' cannot be NULL."
    )
  }

  #scaling
  if(
    any(c("center", "scale") %in% names(formals(f)))
  ){

    tsl <- tsl_remove_exclusive_cols(
      tsl = tsl,
      tsl_test = FALSE
    ) |>
      suppressMessages()

    tsl.matrix <- lapply(
      X = tsl,
      FUN = as.matrix
    )

    tsl.matrix <- do.call("rbind", tsl.matrix)

    tsl.mean <- apply(
      X = tsl.matrix,
      MARGIN = 2,
      FUN = mean
    )

    tsl.sd <- apply(
      X = tsl.matrix,
      MARGIN = 2,
      FUN = sd
    )

  } else {

    tsl.mean <- NULL
    tsl.sd <- NULL

  }

  tsl <- lapply(
    X = tsl,
    FUN = f,
    center = tsl.mean,
    scale = tsl.sd,
    ... = ...
  )

  tsl <- tsl_names_set(
    tsl = tsl,
    tsl_test = FALSE
  )

  tsl

}
