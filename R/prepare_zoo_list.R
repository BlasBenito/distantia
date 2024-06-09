#' Prepare List of Data Frames for Dissimilarity Analysis
#'
#'
#' @param x (required, list of data frames) A named list with data frames. Default: NULL.
#' @param time_column (optional if `lock_step = FALSE`, and required otherwise, column name) Name of the column representing time, if any. Default: NULL.
#' @param lock_step (optional, logical) If TRUE, all input sequences are subset to their common times according to the values in the `time_column`.
#' @return A named list of data frames, matrices, or vectors.
#' @examples
#' data(sequencesMIS)
#' x <- tsl_prepare(
#'   x = sequencesMIS,
#'   id_column = "MIS"
#' )
#' @autoglobal
#' @export
prepare_zoo_list <- function(
    x = NULL,
    time_column = NULL,
    lock_step = FALSE
){

  if(
    prepare_list_class(
      x = x,
      expected_class = "data.frame"
    ) == FALSE
  ){

    stop("Argument 'x' must be a list of data frames.")

  }

  #at least 2 elements
  if(length(x) == 1){
    stop("Argument 'x' must be a list with a least two elements.")
  }

  #elements must be named
  if(any(is.null(names(x)))){
    stop("All elements in the list 'x' must be named.")
  }

  # + convert to zoo
  ###################
  x <- lapply(
    X = x,
    FUN = function(i){

      #get index
      i.index <- attributes(i)$index

      #get numeric columns only
      i <- i[, sapply(i, is.numeric), drop = FALSE]

      #convert to zoo
      i <- zoo::zoo(
        x = i,
        order.by = i.index
        )

      return(i)

    }
  )

  for(i in seq_len(length(x))){
    attr(x = x[[i]], which = "name") <- names(x)[i]
  }

  x

}
