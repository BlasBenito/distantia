#' Removes Geometry Column from SF Data Frames
#'
#' Replicates the functionality of  `sf::st_drop_geometry()` without depending on the `sf` package.
#'
#'@param df (required, data frame) Input data frame. Default: NULL.
#'
#' @return data frame
#' @autoglobal
#' @export
#' @family tsl_processing_internal
utils_drop_geometry <- function(
    df = NULL
){

  #remove geometry column from df
  sf.column <- attributes(df)$sf_column

  if(!is.null(sf.column)){

    df <- as.data.frame(df)
    df[[sf.column]] <- NULL
    attr(df, "sf_column") <- NULL

  }

  df

}
