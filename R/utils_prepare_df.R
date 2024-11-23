#' Convert Data Frame to a List of Data Frames
#'
#' @param x (required, data frame) Input data frame. Default: NULL.
#' @param name_column (optional, column name) Column name used to split `x` to a list of data frames. If omitted, the split is done by column instead. Default: NULL
#' @param time_column (optional, column name) Name of the column representing time, if any. Default: NULL.
#' @return List of data frames
#' @export
#' @autoglobal
#' @family internal
utils_prepare_df <- function(
    x = NULL,
    name_column = NULL,
    time_column = NULL
){

  if(inherits(x = x, what = "data.frame") == FALSE){
    return(x)
  }

  if(nrow(x) < 3){
    stop("distantia::utils_prepare_df(): number of rows in 'x' is not enough for a dissimilarity analysis.", call. = FALSE)
  }

  #drop geometry column, if any
  x <- utils_drop_geometry(
    df = x
  )

  if(is.null(time_column)){
    time_column <- NA
  } else {
    if(!(time_column %in% names(x))){
      stop("distantia::utils_prepare_df(): Column '", time_column, "' is not a column name of the data frame 'x'.", call. = FALSE)
    }
  }

  if(is.null(name_column)){
    name_column <- NA
  } else {
    if(!(name_column %in% names(x))){
      stop("distantia::utils_prepare_df(): column '", name_column, "' is not a column name of the data frame 'x'.", call. = FALSE)
    }
  }

  if(time_column %in% colnames(x)){
    x.time <- x[[time_column]]
    x[[time_column]] <- NULL
  }

  if(name_column %in% colnames(x)){
    x.id <- x[[name_column]]
    x[[name_column]] <- NULL
  }

  x <- x[, sapply(x, is.numeric), drop = FALSE]

  if(exists(x = "x.id")){

    if(exists(x = "x.time")){
      x[[time_column]] <- x.time
    }

    x[[name_column]] <- x.id

    x <- split(
      x = x[, colnames(x) != name_column],
      f = x[[name_column]]
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
