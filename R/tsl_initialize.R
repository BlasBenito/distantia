#' Prepare Time Series List
#'
#' @description
#'
#' Most functions in this package take a **time series list** (or **tsl** for short) as main input. A `tsl` is a list of zoo time-series objects (see [zoo::zoo()]). There is not a formal class for `tsl` objects, but there are requirements these objects must follow to ensure the stability of the package functionalities (see [tsl_is_valid()]). These requirements are:
#' \itemize{
#'   \item There are no NA, Inf, -Inf, or NaN cases in the zoo objects (see [tsl_count_NA()] and [tsl_handle_NA()]).
#'   \item All zoo objects must have at least one common column name to allow time series comparison (see [tsl_colnames()]).
#'   \item All zoo objects have a character attribute "name" identifying the object. This attribute is not part of the zoo class, but the package ensures that this attribute is not lost during data manipulations.
#'   \item Each element of the time series list is named after the zoo object it contains (see [tsl_names()], [tsl_names_set()] and [tsl_names_clean()]).
#'   \item The time series list contains two zoo objects or more.
#' }
#'
#' The function [tsl_initialize()] (also [tsl_init()]) is designed to help the user turn their data into a valid time series list.
#'
#' TODO: list valid input objects.
#'
#' @param x (required, list or data frame) A named list with ordered sequences, or a long data frame with a grouping column. Default: NULL.
#' @param id_column (optional, column name) Column name used for splitting a 'x' data frame into a list.
#' @param time_column (optional if `lock_step = FALSE`, and required otherwise, column name) Name of the column representing time, if any. Default: NULL.
#' @param lock_step (optional, logical) If TRUE, all input sequences are subset to their common times according to the values in `time_column`.
#' @param verbose (optional, logical) If FALSE, all messages are suppressed. Default: TRUE
#' @return A named list of matrices.
#' @examples
#' data(mis)
#' x <- tsl_initialize(
#'   x = mis,
#'   id_column = "MIS"
#' )
#' @autoglobal
#' @export
tsl_initialize <- function(
    x = NULL,
    id_column = NULL,
    time_column = NULL,
    lock_step = FALSE,
    verbose = TRUE
){

  if(is.null(x)){
    stop("Argument 'x' must not be NULL")
  }

  x <- utils_prepare_matrix(
    x = x
  )

  x <- utils_prepare_df(
    x = x,
    id_column = id_column,
    time_column = time_column
  )

  x <- utils_prepare_vector_list(
    x = x
  )

  x <- utils_prepare_matrix_list(
    x = x
  )

  x <- utils_prepare_time(
    x = x,
    time_column = time_column,
    lock_step = lock_step
  )

  tsl <- utils_prepare_zoo_list(
    x = x,
    time_column = time_column,
    lock_step = lock_step
  )

  tsl <- tsl_is_valid(
    tsl = tsl
  )

  na.count <- tsl_count_NA(
    tsl = tsl,
    verbose = TRUE
  )

  tsl

}

#' @rdname tsl_initialize
#' @export
tsl_init <- tsl_initialize
