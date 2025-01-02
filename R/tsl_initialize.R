#' Transform Raw Time Series Data to Time Series List
#'
#' @description
#'
#' Most functions in this package take a **time series list** (or **tsl** for short) as main input. A `tsl` is a list of zoo time series objects (see [zoo::zoo()]). There is not a formal class for `tsl` objects, but there are requirements these objects must follow to ensure the stability of the package functionalities (see [tsl_diagnose()]). These requirements are:
#' \itemize{
#'   \item There are no NA, Inf, -Inf, or NaN cases in the zoo objects (see [tsl_count_NA()] and [tsl_handle_NA()]).
#'   \item All zoo objects must have at least one common column name to allow time series comparison (see [tsl_colnames_get()]).
#'   \item All zoo objects have a character attribute "name" identifying the object. This attribute is not part of the zoo class, but the package ensures that this attribute is not lost during data manipulations.
#'   \item Each element of the time series list is named after the zoo object it contains (see [tsl_names_get()], [tsl_names_set()] and [tsl_names_clean()]).
#'   \item The time series list contains two zoo objects or more.
#' }
#'
#' The function [tsl_initialize()] (and its alias [tsl_init()]) is designed to convert the following data structures to a time series list:
#'
#' \itemize{
#'   \item Long data frame: with an ID column to separate time series, and a time column that can be of the classes "Date", "POSIXct", "integer", or "numeric". The resulting zoo objects and list elements are named after the values in the ID column.
#'   \item Wide data frame: each column is a time series representing the same variable observed at the same time in different places. Each column is converted to a separate zoo object and renamed.
#'   \item List of vectors: an object like `list(a = runif(10), b = runif(10))` is converted to a time series list with as many zoo objects as vectors are defined in the original list.
#'   \item List of matrices: a list containing matrices, such as `list(a = matrix(runif(30), 10, 3), b = matrix(runif(36), 12, 3))`.
#'   \item List of zoo objects: a list with zoo objects, such as `list(a = zoo_simulate(), b = zoo_simulate())`
#' }
#'
#' @param x (required, list or data frame) Matrix or data frame in long format, list of vectors, list of matrices, or list of zoo objects. Default: NULL.
#' @param name_column (optional, column name) Column naming individual time series. Numeric names are converted to character with the prefix "X". Default: NULL
#' @param time_column (optional if `lock_step = FALSE`, and required otherwise, character string) Name of the column representing time, if any. Default: NULL.
#' @param lock_step (optional, logical) If TRUE, all input sequences are subsetted to their common times according to the values in `time_column`.
#' @return list of matrices
#' @examples
#' #long data frame
#' #---------------------
#' data("fagus_dynamics")
#'
#' #name_column is name
#' #time column is time
#' str(fagus_dynamics)
#'
#' #to tsl
#' #each group in name_column is a different time series
#' tsl <- tsl_initialize(
#'   x = fagus_dynamics,
#'   name_column = "name",
#'   time_column = "time"
#' )
#'
#' #check validity (no messages or errors if valid)
#' tsl_diagnose(tsl)
#'
#' #class of contained objects
#' lapply(X = tsl, FUN = class)
#'
#' #get list and zoo names (between double quotes)
#' tsl_names_get(
#'   tsl = tsl,
#'   zoo = TRUE
#'   )
#'
#' #plot tsl
#' if(interactive()){
#'   tsl_plot(tsl)
#' }
#'
#' #list of zoo objects
#' #--------------------
#' x <- zoo_simulate()
#' y <- zoo_simulate()
#'
#' tsl <- tsl_initialize(
#'   x = list(
#'     x = x,
#'     y = y
#'   )
#' )
#'
#' #plot
#' if(interactive()){
#'   tsl_plot(tsl)
#' }
#'
#'
#' #wide data frame
#' #--------------------
#' #wide data frame
#' #each column is same variable in different places
#' df <- stats::reshape(
#'   data = fagus_dynamics[, c(
#'     "name",
#'     "time",
#'     "evi"
#'   )],
#'   timevar = "name",
#'   idvar = "time",
#'   direction = "wide",
#'   sep = "_"
#' )
#'
#' str(df)
#'
#' #to tsl
#' #key assumptions:
#' #all columns but "time" represent
#' #the same variable in different places
#' #all time series are of the same length
#' tsl <- tsl_initialize(
#'   x = df,
#'   time_column = "time"
#'   )
#'
#' #colnames are forced to be the same...
#' tsl_colnames_get(tsl)
#'
#' #...but can be changed
#' tsl <- tsl_colnames_set(
#'   tsl = tsl,
#'   names = "evi"
#' )
#' tsl_colnames_get(tsl)
#'
#' #plot
#' if(interactive()){
#'   tsl_plot(tsl)
#' }
#'
#'
#' #list of vectors
#' #---------------------
#' #create list of vectors
#' vector_list <- list(
#'   a = cumsum(stats::rnorm(n = 50)),
#'   b = cumsum(stats::rnorm(n = 70)),
#'   c = cumsum(stats::rnorm(n = 20))
#' )
#'
#' #to tsl
#' #key assumptions:
#' #all vectors represent the same variable
#' #in different places
#' #time series can be of different lengths
#' #no time column, integer indices are used as time
#' tsl <- tsl_initialize(
#'   x = vector_list
#' )
#'
#' #plot
#' if(interactive()){
#'   tsl_plot(tsl)
#' }
#'
#' #list of matrices
#' #-------------------------
#' #create list of matrices
#' matrix_list <- list(
#'   a = matrix(runif(30), nrow = 10, ncol = 3),
#'   b = matrix(runif(80), nrow = 20, ncol = 4)
#' )
#'
#' #to tsl
#' #key assumptions:
#' #each matrix represents a multivariate time series
#' #in a different place
#' #all multivariate time series have the same columns
#' #no time column, integer indices are used as time
#' tsl <- tsl_initialize(
#'   x = matrix_list
#' )
#'
#' #check column names
#' tsl_colnames_get(tsl = tsl)
#'
#' #remove exclusive column
#' tsl <- tsl_subset(
#'   tsl = tsl,
#'   shared_cols = TRUE
#'   )
#' tsl_colnames_get(tsl = tsl)
#'
#' #plot
#' if(interactive()){
#'   tsl_plot(tsl)
#' }
#'
#' #list of zoo objects
#' #-------------------------
#' zoo_list <- list(
#'   a = zoo_simulate(),
#'   b = zoo_simulate()
#' )
#'
#' #looks like a time series list! But...
#' tsl_diagnose(tsl = zoo_list)
#'
#' #let's set the names
#' zoo_list <- tsl_names_set(tsl = zoo_list)
#'
#' #check again: it's now a valid time series list
#' tsl_diagnose(tsl = zoo_list)
#'
#' #to do all this in one go:
#' tsl <- tsl_initialize(
#'   x = list(
#'     a = zoo_simulate(),
#'     b = zoo_simulate()
#'   )
#' )
#'
#' #plot
#' if(interactive()){
#'   tsl_plot(tsl)
#' }
#'
#' @autoglobal
#' @export
#' @family tsl_initialize
tsl_initialize <- function(
    x = NULL,
    name_column = NULL,
    time_column = NULL,
    lock_step = FALSE
){

  if(is.null(x)){
    stop("distantia::tsl_initialize(): argument 'x' must not be NULL")
  }

  x <- utils_prepare_matrix(
    x = x
  )

  x <- utils_prepare_df(
    x = x,
    name_column = name_column,
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
    time_column = time_column
  )

  tsl <- tsl_names_set(
    tsl = tsl
    )

  tsl_diagnose(
    tsl = tsl,
    full = TRUE
  )

  tsl

}

#' @rdname tsl_initialize
#' @export
tsl_init <- tsl_initialize
