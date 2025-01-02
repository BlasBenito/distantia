#' Convert List of Data Frames to List of Zoo Objects
#'
#'
#' @param x (required, list of data frames) A named list with data frames. Default: NULL.
#' @param time_column (required, column name) Name of the column representing time, if any. Default: NULL.
#' @return A named list of data frames, matrices, or vectors.
#' @examples
#' x <- utils_prepare_zoo_list(
#'   x = list(
#'     spain = fagus_dynamics[fagus_dynamics$name == "Spain", ],
#'     sweden = fagus_dynamics[fagus_dynamics$name == "Sweden", ]
#'   ),
#'   time_column = "time"
#' )
#' @autoglobal
#' @export
#' @family internal
utils_prepare_zoo_list <- function(
    x = NULL,
    time_column = NULL
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

    stop("distantia::utils_prepare_zoo_list(): argument 'x' must be a list of data frames.", call. = FALSE)

  }

  #at least 2 elements
  if(length(x) == 1){
    stop("distantia::utils_prepare_zoo_list(): argument 'x' must be a list with a least two elements.", call. = FALSE)
  }

  #elements must be named
  if(any(is.null(names(x)))){
    stop("distantia::utils_prepare_zoo_list(): all elements in the list 'x' must be named.", call. = FALSE)
  }

  # + convert to zoo
  ###################
  x <- lapply(
    X = x,
    FUN = function(i){

      #get index
      i.index <- attributes(i)$index

      if(is.null(i.index) && time_column %in% colnames(i)){

        i.index <- i[[time_column]]
        i[[time_column]] <- NULL

      }

      #to numeric if integer
      if(is.integer(i.index)){
        i.index <- as.numeric(i.index)
      }

      #get numeric columns only
      i <- i[, sapply(i, is.numeric), drop = FALSE]

      #convert to zoo
      i.zoo <- zoo::zoo(
        x = i,
        order.by = i.index
      )

      i.zoo

    }
  )

  tsl_names_set(
    tsl = x
  )

}
