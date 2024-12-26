#' Aggregate `distantia()` Data Frames Across Parameter Combinations
#'
#' @description
#'
#' The function [distantia()] allows dissimilarity assessments based on several combinations of arguments at once. For example, when the argument `distance` is set to `c("euclidean", "manhattan")`, the output data frame will show two dissimilarity scores for each pair of compared time series, one based on euclidean distances, and another based on manhattan distances.
#'
#' This function computes dissimilarity stats across combinations of parameters.
#'
#' If psi scores smaller than zero occur in the aggregated output, then the the smaller psi value is added to the column `psi` to start dissimilarity scores at zero.
#'
#' If there are no different combinations of arguments in the input data frame, no aggregation happens, but all parameter columns are removed.
#'
#' @param df (required, data frame) Output of [distantia()], [distantia_ls()], [distantia_dtw()], or [distantia_dtw_shift()]. Default: NULL
#' @param f (optional, function) Function to summarize psi scores (for example, `mean`) when there are several combinations of parameters in `df`. Ignored when there is a single combination of arguments in the input. Default: `mean`
#' @param ... (optional, arguments of `f`) Further arguments to pass to the function `f`.
#'
#' @return data frame
#' @export
#' @autoglobal
#' @examples
#' #three time series
#' #climate and ndvi in Fagus sylvatica stands in Spain, Germany, and Sweden
#' tsl <- tsl_initialize(
#'   x = fagus_dynamics,
#'   name_column = "name",
#'   time_column = "time"
#' ) |>
#'   tsl_transform(
#'     f = f_scale_global
#'   )
#'
#' if(interactive()){
#'   tsl_plot(
#'     tsl = tsl,
#'     guide_columns = 3
#'     )
#' }
#'
#' #distantia with multiple parameter combinations
#' #-------------------------------------
#' df <- distantia(
#'   tsl = tsl,
#'   distance = c("euclidean", "manhattan"),
#'   lock_step = TRUE
#' )
#'
#' df[, c(
#'   "x",
#'   "y",
#'   "distance",
#'   "psi"
#' )]
#'
#' #aggregation using means
#' df <- distantia_aggregate(
#'   df = df,
#'   f = mean
#' )
#'
#' df
#' @family distantia_support
#' 
distantia_aggregate <- function(
    df = NULL,
    f = mean,
    ...
){

  df_type <- attributes(df)$type

  if(df_type != "distantia_df"){
    stop("distantia::distantia_aggregate(): argument 'df' must be the output of 'distantia()'.", call. = FALSE)
  }

  if(!is.function(f)){
    stop("distantia::distantia_aggregate(): argument 'f' must be a function such as mean, median, mean, max, and the likes.", call. = FALSE)
  }

  # split ----
  df_list <- utils_distantia_df_split(
    df = df
  )

  #no aggregation needed
  if(length(df_list) == 1){
    df$distance <- NULL
    df$diagonal <- NULL
    df$bandwidth <- NULL
    df$repetitions <- NULL
    df$seed <- NULL
    df$block_size <- NULL
    df$permutation <- NULL
    df$lock_step <- NULL
    return(df)
  }

  # aggregate ----
    df <- stats::aggregate(
      x = df,
      by = psi ~ x + y,
      FUN = f,
      ... = ...
    )

  #start aggregated distances at zero
  if(min(df$psi) < 0){
    df$psi <- df$psi + abs(min(df$psi))
  }

  #add type
  attr(
    x = df,
    which = "type"
  ) <- df_type

  df

}

