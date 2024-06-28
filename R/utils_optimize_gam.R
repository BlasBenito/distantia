#' Optimization of Univariate GAM Models
#'
#' @description
#'
#' Internal function used in [zoo_resample()]. It finds the `k` parameter of a univariate GAM formula `y ~ s(x, k = ?)` that minimizes the root mean squared error (rmse) between observations and predictions, and returns a model fitted with such `k`.
#'
#' @param x (required, numeric vector) predictor, usually a numeric version of a time vector.
#' @param y (required, numeric vector) response, usually a time series.
#'
#' @return GAM model.
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
#' #optimize k
#' m <- utils_optimize_gam(
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
#'   y = stats::predict(m, type = "response"),
#'   col = "red4"
#'   )
#'
utils_optimize_gam <- function(
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

  k_candidates = seq(
    from = ceiling(nrow(model_df)/10),
    to = nrow(model_df),
    by = 1
    )

  `%iterator%` <- foreach::`%do%`

  rmse <- foreach::foreach(
    k = k_candidates,
    .combine = "c",
    .errorhandling = "pass"
  ) %iterator% {

    gam.formula <- stats::as.formula(
      object = paste0(
        "y ~ s(x, k = ",
        k,
        ")"
      )
    )

    gam.model <- tryCatch({
      mgcv::gam(
        formula = gam.formula,
        data = model_df
      )
    }, error = function(e) {
      NA
    }, warning = function(w) {
      NA
    })

    if(
      inherits(
        x = gam.model,
        what = "gam"
        ) == FALSE
      ){
      return(NA)
    }

    #return rmse
    return(
      sqrt(
        mean(
          (model_df$y - stats::predict(gam.model))^2
          )
        )
    )

  }

  #set errors to NA
  rmse[!is.numeric(rmse)] <- NA

  #select k minimizing rmse
  k_best <- k_candidates[which.min(rmse)]

  #new model
  gam.formula <- stats::as.formula(
    object = paste0(
      "y ~ s(x, k = ",
      k_best,
      ")"
    )
  )

  gam.model <- tryCatch({
    mgcv::gam(
      formula = gam.formula,
      data = model_df
    )
  }, error = function(e) {
    NA
  }, warning = function(w) {
    NA
  })

  gam.model

}
