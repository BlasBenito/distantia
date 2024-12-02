#' Transform Values in Time Series Lists
#'
#' @description
#'
#' Function for time series transformations without changes in data dimensions. Generally, functions introduced via the argument `f` should not change the dimensions of the output time series list. See [tsl_resample()] and [tsl_aggregate()] for transformations requiring changes in time series dimensions.
#'
#'
#' This function also accepts a parallelization setup via [future::plan()] and progress bars via the `progressr` package.
#'
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param f (required, transformation function) name of a function taking a matrix as input. Currently, the following options are implemented, but any other function taking a matrix as input (for example, [scale()]) should work as well:
#' \itemize{
#'   \item f_proportion: proportion computed by row.
#'   \item f_percentage: percentage computed by row.
#'   \item f_hellinger: Hellinger transformation computed by row
#'   \item f_scale_local: Local centering and/or scaling based on the variable mean and standard deviation in each time series within `tsl`.
#'   \item f_scale_global: Global centering and/or scaling based on the variable mean and standard deviation across all time series within `tsl`.
#'   \item f_smooth: Time series smoothing with a user defined rolling window.
#'   \item f_detrend_difference: Differencing detrending of time series via [diff()].
#'   \item f_detrend_linear: Detrending of seasonal time series via linear modeling.
#'   \item f_detrend_gam: Detrending of seasonal time series via Generalized Additive Models.
#' }
#' @param ... (optional, additional arguments of `f`) Optional arguments for the transformation function.
#'
#' @return time series list
#' @export
#' @autoglobal
#' @examples
#parallelization setup (not worth it for this data size)
#' future::plan(
#'   future::multisession,
#'   workers = 2 #set to parallelly::availableCores() - 1
#' )
#'
#' #progress bar
#' # progressr::handlers(global = TRUE)
#'
#' #two time series
#' tsl <- tsl_initialize(
#'   x = fagus_dynamics,
#'   name_column = "name",
#'   time_column = "time"
#' ) |>
#'   tsl_subset(
#'     names = c("Spain", "Sweden"),
#'     colnames = c("rainfall", "temperature")
#'   )
#'
#' if(interactive()){
#'   tsl_plot(
#'     tsl = tsl
#'   )
#' }
#'
#' #centering and scaling
#' #-----------------------------------------
#' #same mean and standard deviation are used to scale each variable across all time series
#' tsl_scale <- tsl_transform(
#'   tsl = tsl,
#'   f = f_scale_local
#' )
#'
#' if(interactive()){
#'   tsl_plot(
#'     tsl = tsl_scale,
#'     guide_columns = 3
#'   )
#' }
#'
#'
#' #rescaling to a new range
#' #-----------------------------------------
#'
#' #rescale between -100 and 100
#' tsl_rescaled <- tsl_transform(
#'   tsl = tsl,
#'   f = f_rescale,
#'   new_min = -100,
#'   new_max = 100
#' )
#'
#' #old range
#' sapply(X = tsl, FUN = range)
#'
#' #new range
#' sapply(X = tsl_rescaled, FUN = range)
#'
#'
#' #moving window smoothing
#' #-----------------------------------------
#' tsl_smooth_mean <- tsl_transform(
#'   tsl = tsl,
#'   f = f_smooth_window,
#'   smoothing_window = 3, #default
#'   smoothing_f = mean #default
#' )
#'
#' if(interactive()){
#'   tsl_plot(
#'     tsl = tsl_smooth_mean,
#'     guide_columns = 3
#'   )
#' }
#'
#' #principal components
#' #-----------------------------------------
#' #replaces original variables with their principal components
#' #requires centering and/or scaling
#' tsl_pca <- tsl |>
#'   tsl_transform(
#'     f = f_scale_global
#'   ) |>
#'   tsl_transform(
#'     f = f_pca
#'   )
#'
#' tsl_colnames_get(tsl = tsl_pca)
#'
#' if(interactive()){
#'   tsl_plot(
#'     tsl = tsl_pca,
#'     guide_columns = 3
#'   )
#' }
#'
#'
#' #numeric transformations
#' #-----------------------------------------
#' #eemian pollen counts
#' tsl <- tsl_initialize(
#'   x = eemian_pollen,
#'   name_column = "name",
#'   time_column = "time"
#' )
#'
#' if(interactive()){
#'   tsl_plot(
#'     tsl = tsl
#'   )
#' }
#'
#' #percentages
#' tsl_percentage <- tsl_transform(
#'   tsl = tsl,
#'   f = f_percentage
#' )
#'
#' if(interactive()){
#'   tsl_plot(
#'     tsl = tsl_percentage
#'   )
#' }
#'
#' #hellinger transformation
#' tsl_hellinger <- tsl_transform(
#'   tsl = tsl,
#'   f = f_hellinger
#' )
#'
#' if(interactive()){
#'   tsl_plot(
#'     tsl = tsl_hellinger
#'   )
#' }
#'
#' #disable parallelization
#' future::plan(
#'   future::sequential
#' )
#' @family tsl_processing
tsl_transform <- function(
    tsl = NULL,
    f = NULL,
    ...
){

  if(is.function(f) == FALSE){

    stop(
      "distantia::tsl_transform(): Argument 'f' must be a function name with no quotes. Valid options are: ",
      paste(
        f_list(),
        collapse = ", "
      ),
      ".",
      call. = FALSE
    )

  }

  #progress bar
  p <- progressr::progressor(along = tsl)

  #apply centering and or scaling
  #if f has the formals "center" and "scale"
  if(".global" %in% names(formals(f))){

    #remove exclusive columns
    tsl <- tsl_subset(
      tsl = tsl,
      numeric_cols = TRUE,
      shared_cols = TRUE
    )

    #compute global scaling parameters
    scaling_params <- utils_global_scaling_params(
      tsl = tsl,
      f = f#,
      #... = ...
    )

    # scaling with scaling params
    tsl <- future.apply::future_lapply(
      X = tsl,
      FUN = function(x){

        p()

        f(
          x = x,
          center = scaling_params$center,
          scale = scaling_params$scale,
          old_min = scaling_params$old_min,
          old_max = scaling_params$old_max#,
          #... = ...
        )

      }
    )


  } else {

    #apply other transformation function
    tsl <- future.apply::future_lapply(
      X = tsl,
      FUN = function(x, ...){

        p()

        f(
          x = x,
          ... = ...
          )

      },
      ... = ...
    )


  }


  #reset names of zoo objects
  tsl <- tsl_names_set(
    tsl = tsl
  )

  na.count <- tsl_count_NA(
    tsl = tsl,
    quiet = FALSE
  )

  tsl

}
