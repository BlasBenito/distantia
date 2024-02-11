#' Prepare Data for Dissimilarity Analysis
#'
#' @description
#' This function performs the following steps:
#' - Converts a data frame to a list by 'id_column'.
#' - Checks the validity of input x.
#' - Orders x by time if a time column is PROVIDED
#' - Handles missing values according to the specified action.
#' - Handles zeros by replacing them with a pseudo-zero value, if provided.
#' - Transforms the data if a transformation function is provided.
#'
#'
#' @param x (required, list or data frame) A named list with ordered sequences, or a long data frame with a grouping column. Default: NULL.
#' @param id_column (optional, column name) Column name used for splitting a 'x' data frame into a list.
#' @param time_column (optional if `paired_samples = FALSE`, and required otherwise, column name) Name of the column representing time, if any. Default: NULL.
#' @param paired_samples (optional, logical) If TRUE, all input sequences are subset to their common times according to the values in the `time_column`.
#' @param pseudo_zero (optional, numeric) Value used to replace zeros in the data. Default: NULL.
#' @param na_action (optional, character string) Action to handle missing values. Accepted values are:
#' \itemize{
#'   \item NULL: returns the input without changes.
#'   \item "omit": applies [na.omit()] to each sequence.
#'   \item "zero": replaces NA values with zero or `pseudo_zero`, if provided.
#'   \item "impute": NA cases are imputed via [zoo::na.spline()]
#' }. Default: NULL
#' @param transformation  (optional, function) A function to transform the data within each sequence. A few options are:
#' \itemize{
#'   \item [f_proportion()]: to transform counts into proportions.
#'   \item [f_percentage()]: to transform counts into percentages.
#'   \item [f_hellinger()]: to apply a Hellinger transformation.
#'   \item [f_scale()]: to center and scale the data.
#'   }
#' @return A named list of matrices.
#' @examples
#' data(sequencesMIS)
#' x <- prepare_sequences(
#'   x = sequencesMIS,
#'   id_column = "MIS"
#' )
#' @autoglobal
#' @export
prepare_sequences <- function(
    x = NULL,
    id_column = NULL,
    time_column = NULL,
    paired_samples = FALSE,
    pseudo_zero = NULL,
    na_action = "omit",
    transformation = NULL
){

  if(is.null(x)){
    stop("Argument 'x' must not be NULL")
  }

  #INPUT IS A DATA FRAME OR MATRIX

  #matrix to data frame
  x <- prepare_matrix(
    x = x
  )

  #data frame to list of data frames
  x <- prepare_df(
    x = x,
    id_column = id_column,
    time_column = time_column,
    pseudo_zero = pseudo_zero,
    na_action = na_action,
    transformation = transformation
  )

  #INPUT IS A LIST

  #list of vectors to list of dfs
  x <- prepare_vector_list(
    x = x
  )

  #list of matrices to list of dfs
  x <- prepare_matrix_list(
    x = x
  )

  #list of matrices
  x <- prepare_zoo_list(
    x = x,
    time_column = time_column,
    pseudo_zero = pseudo_zero,
    na_action = na_action,
    paired_samples = paired_samples
  )

  x

}
