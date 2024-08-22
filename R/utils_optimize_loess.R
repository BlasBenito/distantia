#' Optimization of Loess Models
#'
#' @description
#'
#' Internal function used in [zoo_resample()]. It finds the `span` parameter of a univariate Loess (Locally Estimated Scatterplot Smoothing.) model `y ~ x` fitted with [stats::loess()] that minimizes the root mean squared error (rmse) between observations and predictions, and returns a model fitted with such `span`.
#'
#' @param x (required, numeric vector) predictor, a time vector coerced to numeric. Default: NULL
#' @param y (required, numeric vector) response, a column of a zoo object. Default: NULL
#' @param max_complexity (required, logical). If TRUE, RMSE optimization is ignored, and the model of maximum complexity is returned. Default: FALSE
#'
#' @return Loess model.
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
#' #optimize loess model
#' m <- utils_optimize_loess(
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
#'     newdata = as.numeric(zoo::index(xy))
#'     ),
#'   col = "red4"
#'   )
#' @keywords internal transformation
utils_optimize_loess <- function(
    x = NULL,
    y = NULL,
    max_complexity = FALSE
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

  complexity_space <- seq(
    from = floor(nrow(model_df)/2),
    to = nrow(model_df),
    by = 1
  )

  #max complexity switch
  if(max_complexity == TRUE){

    complexity_value <- min(complexity_space)

  } else {

    `%iterator%` <- foreach::`%do%`

    rmse <- foreach::foreach(
      complexity_value = complexity_space,
      .combine = "c",
      .errorhandling = "pass"
    ) %iterator% {

      m <- tryCatch({
        stats::loess(
          formula = y ~ x,
          data = model_df,
          enp.target = complexity_value,
          degree = 1,
          surface = "direct"
        )
      }, error = function(e) {
        NA
      }, warning = function(w) {
        NA
      })

      if(
        inherits(
          x = m,
          what = "loess"
        ) == FALSE
      ){
        return(NA)
      }

      #return rmse
      return(
        sqrt(
          mean(
            (model_df$y - stats::predict(m))^2
          )
        )
      )

    }

    #set errors to NA
    rmse[!is.numeric(rmse)] <- max(rmse, na.rm = TRUE)

    #select span minimizing rmse
    complexity_value <- complexity_space[which.min(rmse)]

  }

  #new model
  m <- tryCatch({
    stats::loess(
      formula = y ~ x,
      data = model_df,
      enp.target = complexity_value,
      degree = 1,
      surface = "direct"
    )
  }, error = function(e) {
    NA
  }, warning = function(w) {
    NA
  })

  m

}
