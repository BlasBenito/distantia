#' Handles Transformation in List of Data Frames
#'
#' @param x (required, data frame) Default: NULL.
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
    id_column = NULL,
    time_column = NULL,
    transformation = NULL
){

  if(is.null(transformation) == TRUE){
    return(x)
  }

  if(inherits(x = transformation, what = "function") == FALSE){
    stop("Argument 'transformation' must be a function.")
  }

  x <- tryCatch({

    transformation(x = x)

  },
  error = function(e) {
    warning("Transformation failed, returning 'x' without any changes")
    return(x)
  })

  x

}
