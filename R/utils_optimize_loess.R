#' Optimization of Loess Models
#'
#' @description
#'
#' Internal function used in [zoo_resample()]. It finds the `span` parameter of a univariate Loess (Locally Estimated Scatterplot Smoothing.) model `y ~ x` that minimizes the root mean squared error (rmse) between observations and predictions, and returns a model fitted with such `span`.
#'
#' @param x (required, numeric vector) predictor, usually a numeric version of a time vector.
#' @param y (required, numeric vector) response, usually a time series.
#'
#' @return Loess model.
#' @export
#' @autoglobal
#' @examples
#'
#' #zoo time series
#' ts <- zoo_simulate(
#'   cols = 1,
#'   rows = 30
#' )
#'
#' #response
#' y <- as.numeric(ts)
#' #y <- ts[, 1] #for multivariate time series
#'
#' #predictor
#' x <- as.numeric(zoo::index(ts))
#'
#' #optimize loess model
#' m <- utils_optimize_loess(
#'   x = x,
#'   y = y
#' )
#'
#' summary(m)
#'
#' #plot observation
#' plot(
#'   x = zoo::index(ts),
#'   y = as.numeric(y),
#'   col = "forestgreen",
#'   type = "l",
#'   lwd = 2
#'   )
#'
#' #plot prediction
#' lines(
#'   x = zoo::index(ts),
#'   y = stats::predict(m),
#'   col = "red4"
#'   )
#'
utils_optimize_loess <- function(
    x = NULL,
    y = NULL
){

  if(!is.numeric(x)){
    stop("Argument 'x' must be a numeric vector.")
  }

  if(!is.numeric(y)){
    stop("Argument 'y' must be a numeric vector.")
  }

  if(length(x) != length(y)){
    stop("Arguments 'x' and 'y' must be of the same length.")
  }

  names(x) <- NULL
  names(y) <- NULL

  model_df <- data.frame(
    x = x,
    y = y
  )

  span_candidates = seq(
    from = 1/nrow(model_df),
    to = 1/(nrow(model_df)/10),
    by = 1/nrow(model_df)
    )

  `%iterator%` <- foreach::`%do%`

  rmse <- foreach::foreach(
    span = span_candidates,
    .combine = "c",
    .errorhandling = "pass"
  ) %iterator% {

    loess.model <- tryCatch({
      stats::loess(
        formula = y ~ x,
        data = model_df,
        span = span
      )
    }, error = function(e) {
      NA
    }, warning = function(w) {
      NA
    })

    if(
      inherits(
        x = loess.model,
        what = "loess"
        ) == FALSE
      ){
      return(NA)
    }

    #return rmse
    return(
      sqrt(
        mean(
          (model_df$y - stats::predict(loess.model))^2
          )
        )
    )

  }

  #set errors to NA
  rmse[!is.numeric(rmse)] <- NA

  #select span minimizing rmse
  span_best <- span_candidates[which.min(rmse)]

  #new model
  loess.model <- tryCatch({
    stats::loess(
      formula = y ~ x,
      data = model_df,
      span = span_best
    )
  }, error = function(e) {
    NA
  }, warning = function(w) {
    NA
  })

  loess.model

}
