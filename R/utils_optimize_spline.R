#' Optimize Spline Models for Time Series Resampling
#'
#' @description
#'
#' Internal function used in [zoo_resample()]. It finds optimal `df` parameter of a smoothing spline model `y ~ x` fitted with [stats::smooth.spline()]  that minimizes the root mean squared error (rmse) between observations and predictions, and returns a model fitted with such `df`.
#'
#' @param x (required, numeric vector) predictor, a time vector coerced to numeric. Default: NULL
#' @param y (required, numeric vector) response, a column of a zoo object. Default: NULL
#' @param max_complexity (required, logical). If TRUE, RMSE optimization is ignored, and the model of maximum complexity is returned. Default: FALSE
#'
#' @return Object of class "smooth.spline".
#' @export
#' @autoglobal
#' @examples
#'
#' #zoo time series
#' xy <- zoo_simulate(
#'   cols = 1,
#'   rows = 30
#' )
#'
#' #optimize splines model
#' m <- utils_optimize_spline(
#'   x = as.numeric(zoo::index(xy)), #predictor
#'   y = xy[, 1] #response
#' )
#'
#' print(m)
#'
#' #plot observation
#' plot(
#'   x = zoo::index(xy),
#'   y = xy[, 1],
#'   col = "forestgreen",
#'   type = "l",
#'   lwd = 2
#'   )
#'
#' #plot prediction
#' points(
#'   x = zoo::index(xy),
#'   y = stats::predict(
#'     object = m,
#'     x = as.numeric(zoo::index(xy))
#'   )$y,
#'   col = "red"
#' )
#' @importFrom doFuture "%dofuture%"
#' @family tsl_processing_internal
utils_optimize_spline <- function(
    x = NULL,
    y = NULL,
    max_complexity = FALSE
){

  if(!is.numeric(x)){
    stop("distantia::utils_optimize_spline(): argument 'x' must be a numeric vector.", call. = FALSE)
  }

  if(!is.numeric(y)){
    stop("distantia::utils_optimize_spline(): argument 'y' must be a numeric vector.", call. = FALSE)
  }

  if(length(x) != length(y)){
    stop("distantia::utils_optimize_spline(): arguments 'x' and 'y' must be of the same length.", call. = FALSE)
  }

  names(x) <- NULL
  names(y) <- NULL

  model_df <- data.frame(
    x = x,
    y = y
  )

  complexity_space <- seq(
    from = floor(nrow(model_df)/2),
    to = nrow(model_df),
    by = 1
  )

  #max complexity switch
  if(max_complexity == TRUE){

    complexity_value <- max(complexity_space)

  } else {



    rmse <- foreach::foreach(
      complexity_value = complexity_space,
      .combine = "c",
      .errorhandling = "pass",
      .options.future = list(seed = FALSE)
    ) %dofuture% {

      m <- tryCatch({
        stats::smooth.spline(
          x = model_df$x,
          y = model_df$y,
          df = complexity_value,
          all.knots = TRUE
        )
      }, error = function(e) {
        NA
      }, warning = function(w) {
        NA
      })

      if(
        inherits(
          x = m,
          what = "smooth.spline"
        ) == FALSE
      ){
        return(NA)
      }

      #return rmse
      return(
        sqrt(
          mean(
            (model_df$y - stats::predict(
              object = m,
              x = model_df$x)$y
            )^2
          )
        )
      )

    }

    #set errors to NA
    rmse[!is.numeric(rmse)] <- max(rmse, na.rm = TRUE)

    #select df minimizing rmse
    complexity_value <- complexity_space[which.min(rmse)]

  }

  #new model
  m <- tryCatch({
    stats::smooth.spline(
      x = model_df$x,
      y = model_df$y,
      df = complexity_value,
      all.knots = TRUE
    )
  }, error = function(e) {
    NA
  }, warning = function(w) {
    NA
  })

  m

}
