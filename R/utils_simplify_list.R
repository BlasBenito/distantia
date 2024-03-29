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

  list_names <- names(x)
  slot_names <- names(x[[1]])
  out <- x[[1]]

  for(slot.i in slot_names){

    values <- vector()

    for(list.i in list_names){

      values <- c(values, x[[list.i]][slot.i])

    }

    out[[slot.i]] <- unlist(unique(values))

  }



}
