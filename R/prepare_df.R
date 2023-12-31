#' Data Frame to List of Data Frames
#'
#' @param x (required, data frame) Input data frame. Default: NULL.
#' @param id_column (optional, column name) Column name used to split `x` to a list of data frames. If omitted, the split is done by column instead. Default: NULL
#' @param time_column (optional, column name) Name of the column representing time, if any. Default: NULL.
#' @param pseudo_zero (optional, numeric) Value used to replace zeros in the data. Default: NULL.
#' @param na_action (optional, character string) Action to handle missing values. default: NULL.
#' \itemize{
#'   \item NULL: returns the input without changes.
#'   \item "omit": applies [na.omit()] to each sequence.
#'   \item "to_zero": replaces NA values with zero or `pseudo_zero`, if provided.
#'   \item "impute": not implemented yet.
#' }
#' @param transformation  (optional, function) A function to transform the data within each sequence. A few options are:
#' \itemize{
#'   \item [f_proportion()]: to transform counts into proportions.
#'   \item [f_percentage()]: to transform counts into percentages.
#'   \item [f_hellinger()]: to apply a Hellinger transformation.
#'   \item [f_scale()]: to center and scale the data.
#'   }
#' @return List of data frames
#' @export
#' @autoglobal
prepare_df <- function(
    x = NULL,
    id_column = NULL,
    time_column = NULL,
    pseudo_zero = NULL,
    na_action = NULL,
    transformation = NULL
){

  if(inherits(x = x, what = "data.frame") == FALSE){
    return(x)
  }

  if(nrow(x) < 3){
    stop("Number of rows in 'x' is not enough for a dissimilarity analysis.")
  }

  if(is.null(time_column)){
    time_column <- NA
  }

  if(is.null(id_column)){
    id_column <- NA
  }

  if(time_column %in% colnames(x)){
    x.time <- x[[time_column]]
    x[[time_column]] <- NULL
  }

  if(id_column %in% colnames(x)){
    x.id <- x[[id_column]]
    x[[id_column]] <- NULL
  }

  x <- x[, sapply(x, is.numeric)]

  x <- prepare_na(
    x = x,
    pseudo_zero = pseudo_zero,
    na_action = na_action
  )

  x <- prepare_transformation(
    x = x,
    transformation = transformation
  )

  if(exists(x = "x.time")){
    x[[time_column]] <- x.time
  }

  if(exists(x = "x.id")){

    x[[id_column]] <- x.id

    x <- split(
      x = x[, colnames(x) != id_column],
      f = x[[id_column]]
    )

  } else {

    x <- lapply(
      X = x,
      FUN = function(x) {
        x <- data.frame(
          x = x
        )
        if(exists(x = "x.time")){
          x[[time_column]] <- x.time
        }
        return(x)
      }
    )

  }

  x

}
