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
#' @param verbose (optional, logical) If FALSE, all messages are suppressed. Default: TRUE
#' @return A named list of matrices.
#' @examples
#' data(sequencesMIS)
#' x <- tsl_prepare(
#'   x = sequencesMIS,
#'   id_column = "MIS"
#' )
#' @autoglobal
#' @export
tsl_initialize <- function(
    x = NULL,
    id_column = NULL,
    time_column = NULL,
    paired_samples = FALSE,
    verbose = TRUE
){

  if(is.null(x)){
    stop("Argument 'x' must not be NULL")
  }

  x <- prepare_matrix(
    x = x
  )

  x <- prepare_df(
    x = x,
    id_column = id_column,
    time_column = time_column
  )

  x <- prepare_vector_list(
    x = x
  )

  x <- prepare_matrix_list(
    x = x
  )

  x <- prepare_time(
    x = x,
    time_column = time_column,
    paired_samples = paired_samples
  )

  tsl <- prepare_zoo_list(
    x = x,
    time_column = time_column,
    paired_samples = paired_samples
  )

  tsl <- tsl_is_valid(
    tsl = tsl,
    tsl_test = FALSE
  )

  tsl

}

#' @rdname tsl_initialize
#' @export
tsl_init <- tsl_initialize
