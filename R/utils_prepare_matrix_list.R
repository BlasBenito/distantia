#' List of Matrices to List of Data Frames
#'
#' @param x (required, list of matrices) Default: NULL
#'
#' @return List of Data Frames
#' @export
#' @autoglobal
utils_prepare_matrix_list <- function(
    x = NULL
){

  if(
    utils_check_list_class(
      x = x,
      expected_class = "matrix"
      ) == FALSE
    ){

    return(x)

  }

  x <- lapply(
    X = x,
    FUN = function(x){
      if(is.null(colnames(x))){
        colnames(x) <- paste0("x", seq_len(ncol(x)))
      }
      x <- as.data.frame(x)

      return(x)
    }
  )

  x

}
