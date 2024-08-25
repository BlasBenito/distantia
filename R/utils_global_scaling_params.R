#' Global Scaling Parameters of Time Series Lists
#'
#' @description
#' Internal function to compute global scaling parameters (mean and standard deviation) for time series lists. Used within [tsl_transform()] when the scaling functions [f_center()], [f_scale()], or [base::scale()] are used as inputs for the argument `f`.
#'
#' Warning: this function removes exclusive columns from the data. See function [tsl_subset()].
#'
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param f (required, function) function name. Usually, one of [f_center()], [f_scale()], or [base::scale()]. Default: NULL
#' @param ... (optional, arguments of `f`) Optional arguments for the transformation function. Used only when `f = scale` for arguments `center` and `scale`.
#'
#' @return list
#' @export
#' @autoglobal
#' @family transformation
#' @family internal
utils_global_scaling_params <- function(
    tsl = NULL,
    f = NULL,
    ...
){

  #user values for center and scale
  args <- list(...)
  args <- args[names(args) %in% c("center", "scale")]

  #giving priority to user input via ...
  if("center" %in% names(args)){
    center <- args$center
  } else {
    center <- formals(f)$center
  }

  if("scale" %in% names(args)){
    scale <- args$scale
  } else {
    scale <- formals(f)$scale
  }

  #joining data for mean and sd computation
  tsl.matrix <- do.call(
    what = "rbind",
    args = lapply(
      X = tsl,
      FUN = zoo::coredata
    )
  )

  #default output
  center.mean <- FALSE
  scale.sd <- FALSE

  #computing mean
  if(center == TRUE){
    center.mean <- apply(
      X = tsl.matrix,
      MARGIN = 2,
      FUN = mean
    )
  }

  #computing sd
  if(scale == TRUE){
    scale.sd <- apply(
      X = tsl.matrix,
      MARGIN = 2,
      FUN = sd
    )
  }

  list(
    center = center.mean,
    scale = scale.sd
  )

}
