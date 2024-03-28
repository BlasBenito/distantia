#' Simmplify List With Repeated Elements
#'
#' @param x (required, list)
#'
#' @return simplified list
#' @export
#' @autoglobal
#' @examples
utils_simplify_list <- function(x){

  if(!is.list(x)){
    return(x)
  }

  x_unique <- x |>
    unique()

  if(length(x_unique) == 1){
    x <- x_unique[[1]]
  }

  x

}
