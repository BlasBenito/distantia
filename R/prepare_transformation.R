#' Handles Transformation in List of Data Frames
#'
#' @param x (required, list of data frames) A named list with data frames. Default: NULL.
#' @param transformation  (optional, function) A function to transform the data within each sequence. A few options are:
#' \itemize{
#'   \item [f_proportion()]: to transform counts into proportions.
#'   \item [f_percentage()]: to transform counts into percentages.
#'   \item [f_hellinger()]: to apply a Hellinger transformation.
#'   \item [f_scale()]: to center and scale the data.
#'   }
#'
#' @return Named list of data frames
#' @export
#' @autoglobal
prepare_transformation <- function(
    x = NULL,
    transformation = NULL
){

  if(is.null(transformation) == TRUE){
    return(x)
  }

  if(inherits(x = transformation, what = "function") == FALSE){
    stop("Argument 'transformation' must be a function.")
  }

  x <- tryCatch({
    lapply(
      X = x,
      FUN = function(x){
        x.time <- attributes(x)$time
        x <- transformation(x = x)
        attr(x = x, which = "time") <- x.time
        return(x)
      }
    )
  }, error = function(e) {
    warning("Transformation failed, returning 'x' without any changes")
    return(x)
  })

  x

}
