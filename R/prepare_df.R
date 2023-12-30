#' Data Frame to List of Data Frames
#'
#' @param x (required, data frame) Input data frame. Default: NULL.
#' @param id_column (optional, column name) Column name used to split `x` to a list of data frames. If omitted, the split is done by column instead. Default: NULL
#' @param time_column (optional, column name) Name of the column representing time, if any. Default: NULL.
#'
#' @return List of data frames
#' @export
#' @autoglobal
prepare_df <- function(
    x = NULL,
    id_column = NULL,
    time_column = NULL
){

  if(inherits(x = x, what = "data.frame") == FALSE){
    return(x)
  }

  if(nrow(x) < 3){
    stop("Number of rows in 'x' is not enough for a dissimilarity analysis.")
  }

  if(is.null(id_column)){

    if(is.null(time_column)){

      #get numeric columns only
      x <- x[, sapply(x, is.numeric)]

      #list of one-column data frames
      x <- lapply(
        X = x,
        FUN = function(x)
          x <- data.frame(
            x = x
          )
      )

    } else {

      if(!(time_column %in% colnames(x))){
        stop("Argument 'time_column' must be a column name of 'x'.")
      }

      time_vector <- x[[time_column]]
      x[[time_column]] <- NULL

      #two column data frames
      x <- lapply(
        X = x,
        FUN = function(x) {
          x <- data.frame(
            x = x
          )
          x[[time_column]] <- time_vector
          return(x)
        }
      )

    }

  } else {

    if(!(id_column %in% colnames(x))){
      stop("Argument 'id_column' must be a column name of 'x'.")
    }

    #group to data frame
    x <- split(
      x = x[, colnames(x) != id_column],
      f = x[[id_column]]
    )

  }

  x

}
