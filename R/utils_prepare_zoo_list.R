#' Convert List of Data Frames to List of Zoo Objects
#'
#'
#' @param x (required, list of data frames) A named list with data frames. Default: NULL.
#' @param time_column (optional if `lock_step = FALSE`, and required otherwise, column name) Name of the column representing time, if any. Default: NULL.
#' @param lock_step (optional, logical) If TRUE, all input sequences are subset to their common times according to the values in the `time_column`.
#' @return A named list of data frames, matrices, or vectors.
#' @examples
#' data(mis)
#' x <- tsl_initialize(
#'   x = mis,
#'   id_column = "mis"
#' )
#' @autoglobal
#' @export
#' @family internal
utils_prepare_zoo_list <- function(
    x = NULL,
    time_column = NULL,
    lock_step = FALSE
){

  #skip if x has zoo objects
  if(zoo::is.zoo(x)){
    return(x)
  }

  if(is.list(x)){
    if(all(unlist(lapply(x, class)) == "zoo")){
      return(x)
    }
  }


  if(
    utils_check_list_class(
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

      #to numeric if integer
      if(is.integer(i.index)){
        i.index <- as.numeric(i.index)
      }

      #get numeric columns only
      i <- i[, sapply(i, is.numeric), drop = FALSE]

      #convert to zoo
      zoo::zoo(
        x = i,
        order.by = i.index
        )

    }
  )

  tsl_names_set(
    tsl = x
  )

}
