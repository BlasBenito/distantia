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
#' @param na_action (required, character) Action to handle NA data in `x`. Current options are:
#' \itemize{
#'   \item "impute" (default): NA cases are interpolated against time via splines with [zoo::na.spline()].
#'   \item "omit": rows with NA cases are removed.
#'   \item "fill": NA cases are replaced with the value in `na_fill`.
#' }
#' @param na_fill (optional, numeric) Only relevant when `na_action = "fill"`, defines the value used to replace NAs with. Ideally, a small number different from zero (pseudo-zero). Default: 0.0001
#'
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
#' x <- ts_prepare(
#'   x = sequencesMIS,
#'   id_column = "MIS"
#' )
#' @autoglobal
#' @export
ts_initialize <- function(
    x = NULL,
    id_column = NULL,
    time_column = NULL,
    paired_samples = FALSE,
    na_action = "impute",
    na_fill = 0.0001,
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


  #handle time column
  ####################
  # + if time column
  #   + if not numeric: ERROR
  #   + else if arrange by time column
  # + if no time column
  #   + if paired samples: ERROR
  #   + add row_id
  #   + set time_column to row_id
  # + if paired samples, keep paired samples only
  # + add time column to attribute "time" and remove from df
  x <- prepare_time(
    x = x,
    time_column = time_column,
    paired_samples = paired_samples
  )

  #list of zoo objects
  x <- prepare_zoo_list(
    x = x,
    time_column = time_column,
    paired_samples = paired_samples
  )

  #handle NA
  x <- ts_handle_NA(
    x = x,
    na_action = na_action,
    na_fill = na_fill
  )

  x

}

#' @rdname ts_initialize
#' @export
ts_init <- ts_initialize
