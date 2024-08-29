#' Convert Matrix to Data Frame
#'
#' @param x (required, matrix) Default: NULL
#'
#' @return A data frame
#' @export
#' @autoglobal
#' @family internal
utils_prepare_matrix <- function(
    x = NULL
){

  if(inherits(x = x, what = "matrix") == FALSE){
    return(x)
  }

  #coerce to numeric
  x.numeric <- apply(
    X = x,
    MARGIN = 2,
    FUN = as.numeric
  ) |>
    suppressWarnings() |>
    as.data.frame()

  #identify columns with all NA
  x.na.names <- apply(
    X = x.numeric,
    MARGIN = 2,
    FUN = function(x){
      if(sum(is.na(x)) == length(x)){
        return(TRUE)
      } else {
        FALSE
      }
    }
  )

  x.na.names <- names(x.na.names[x.na.names == TRUE])

  #convert x to data frame
  x <- as.data.frame(x)

  #add non numerics to x.numeric
  if(length(x.na.names) > 0){
    for(i in x.na.names){
      x.numeric[[i]] <- x[[i]]
    }
  }

  x.numeric


}
