#' Convert List of Vectors to List of Data Frames
#'
#' @param x (required, list of vectors) Default: NULL
#'
#' @return List of data frames
#' @export
#' @autoglobal
#' @family internal
utils_prepare_vector_list <- function(
    x = NULL
){

  if(
    utils_check_list_class(
      x = x,
      expected_class = "vector"
      ) == FALSE
    ){

    return(x)

  }

  x <- lapply(
    X = x,
    FUN = function(x){
      data.frame(
        x = x
      )
    }
  )

  x


}
