#' Coerce Coredata of Univariate Zoo Time Series to Matrix
#'
#' @description
#' Transforms vector coredata of univariate zoo time series to class matrix. If the input zoo time series has the attribute "name", the output inherits the value of such attribute.
#'
#' Multivariate zoo objects are returned without changes.
#'
#' @param x (required, zoo object) zoo time series. Default: NULL
#' @param name (required, character string) name of the matrix column. Default: NULL
#'
#' @return zoo time series
#' @export
#' @autoglobal
#' @examples
#' #create zoo object from vector
#' x <- zoo::zoo(
#'   x = runif(100)
#' )
#'
#' #coredata is not a matrix
#' is.matrix(zoo::coredata(x))
#'
#' #convert to matrix
#' y <- zoo_vector_to_matrix(
#'   x = x
#' )
#'
#' #coredata is now a matrix
#' is.matrix(zoo::coredata(y))
#' @family data_preparation
zoo_vector_to_matrix <- function(
    x = NULL,
    name = NULL
){

  #check x
  x <- utils_check_args_zoo(x = x)

  #get coredata
  x_data <- zoo::coredata(x)

  #return if matrix
  if(is.matrix(x_data)){
    return(x)
  }

  #get name
  x_name <- zoo_name_get(x = x) |>
    suppressWarnings()

  #convert to matrix
  y_data <- as.matrix(x_data)

  #set colnames
  colnames(y_data) <- name

  #convert to zoo
  y <- zoo::zoo(
    x = y_data,
    order.by = zoo::index(x)
  )

  #set name
  if(!is.null(x_name)){
    y <- zoo_name_set(
      x = y,
      name = y
    )
  }

  y

}
