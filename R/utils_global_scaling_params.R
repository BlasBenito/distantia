#' Global Centering and Scaling Parameters of Time Series Lists
#'
#' @description
#' Internal function to compute global scaling parameters (mean and standard deviation) for time series lists. Used within [tsl_transform()] when the scaling function [f_scale_global()] is used as input for the argument `f`.
#'
#' Warning: this function removes exclusive columns from the data. See function [tsl_subset()].
#'
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param f (required, function) function [f_scale_global()]. Default: NULL
#' @param ... (optional, arguments of `f`) Optional arguments for the transformation function. Used only when `f = scale` for arguments `center` and `scale`.
#'
#' @return list
#' @export
#' @autoglobal
#' @family tsl_processing_internal
utils_global_scaling_params <- function(
    tsl = NULL,
    f = NULL,
    ...
){

  #user values for center and scale
  args <- list(...)

  if("center" %in% names(args)){
    #get user input
    center <- args$center
  } else if ("center" %in% names(formals(f))){
    #get function default
    center <- formals(f)$center
  } else {
    center <- "none"
  }

  if("scale" %in% names(args)){
    scale <- args$scale
  } else if ("scale" %in% names(formals(f))){
    scale <- formals(f)$scale
  } else {
    scale <- "none"
  }

  if("old_min" %in% names(args)){
    old_min <- args$old_min
  } else if ("old_min" %in% names(formals(f))){
    old_min <- formals(f)$old_min
  } else {
    old_min <- "none"
  }

  if("old_max" %in% names(args)){
    old_max <- args$old_max
  } else if ("old_max" %in% names(formals(f))){
    old_max <- formals(f)$old_max
  } else {
    old_max <- "none"
  }

  #joining data for mean and sd computation
  tsl.matrix <- do.call(
    what = "rbind",
    args = lapply(
      X = tsl,
      FUN = zoo::coredata
    )
  )

  #output list
  out_list <- list()

  #computing mean
  if(center == TRUE){
    out_list$center <- apply(
      X = tsl.matrix,
      MARGIN = 2,
      FUN = mean,
      na.rm = TRUE
    )
  }

  #computing sd
  if(scale == TRUE){
    out_list$scale <- apply(
      X = tsl.matrix,
      MARGIN = 2,
      FUN = stats::sd,
      na.rm = TRUE
    )
  }

  #computing old_min
  if(is.null(old_min)){
    out_list$old_min <- apply(
      X = tsl.matrix,
      MARGIN = 2,
      FUN = min,
      na.rm = TRUE
    )
  }

  if(is.null(old_max)){
    out_list$old_max <- apply(
      X = tsl.matrix,
      MARGIN = 2,
      FUN = max,
      na.rm = TRUE
    )
  }

  out_list

}
