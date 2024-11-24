#' Checks Classes of List Elements Against Expectation
#'
#' @param x (required, list) Default: NULL
#' @param expected_class (required, class name). One of "data.frame", "matrix", or "vector". Default: "data.frame".
#'
#' @return side effects
#' @autoglobal
#' @export
#' @family internal
utils_check_list_class <- function(
    x = NULL,
    expected_class = "data.frame"
){

  if(inherits(x = x, what = "list") == FALSE){
    stop("distantia::utils_check_list_class(): argument 'x' is not a list.", call. = FALSE)
  }

  expected_class <- match.arg(
    arg = expected_class,
    choices = c(
      "data.frame",
      "matrix",
      "vector"
    ),
    several.ok = FALSE
  )


  if(expected_class != "vector"){

    #check element class
    x.class <- lapply(
      X = x,
      FUN = class
    ) |>
      unlist() |>
      as.data.frame()

  } else {

    #check element class
    x.class <- lapply(
      X = x,
      FUN = function(x)
        if(is.vector(x)){
          return("vector")
        } else {
          return(class(x)[1])
        }
    ) |>
      unlist() |>
      as.data.frame()

  }

  colnames(x.class) <- "class"

  if(any(x.class$class %in% expected_class)){

    return(TRUE)

  } else {

    return(FALSE)

  }

}
