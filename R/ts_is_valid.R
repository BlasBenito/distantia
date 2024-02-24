#' Checks Structure Validity of a Time Series List
#'
#' @description
#' Checks that a time series list is in fact a named list containing zoo time series with matching attributes "name".
#'
#'
#' @param x (required, list of zoo time series) Default NULL
#'
#' @return Logical
#' @export
#' @autoglobal
#' @examples
ts_is_valid <- function(
    x = NULL
    ){

  if(is.null(x)){
    return(FALSE)
  }

  if(inherits(x = x, what = "list") == TRUE){

    x.content.class <- lapply(
      X = x,
      FUN = class
    ) |>
      unlist() |>
      unique()

    if(x.content.class == "zoo"){

      x.content.names <- lapply(
        X = x,
        FUN = function(x){
          attributes(x)$name
        }
      ) |>
        unlist()

      if(
        length(x) == length(x.content.names) &&
        all(names(x) == x.content.names)
      ){

        return(TRUE)

      } else {

        warning(
          "The names of 'x' must match the 'name' attribute of the 'zoo' objects inside. This problem can be fixed with 'x <- ts_set_names(x = x)'.",
          call. = FALSE
        )

      }

    } else {

      warning(
        "Internal objects of 'x' are not of the class 'zoo'.",
        call. = FALSE
        )

    }

  } else {

    warning(
      "Object 'x' is not a list.",
      call. = FALSE
    )

  }

  FALSE

}
