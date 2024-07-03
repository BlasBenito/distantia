#' Optimization of Univariate GAM Models
#'
#' @description
#'
#' Internal function used in [zoo_resample()]. It finds the optimal `k` parameter of a univariate GAM formula `y ~ s(x, k = ?)` fitted with [mgcv::gam()] that minimizes the root mean squared error (rmse) between observations and predictions, and returns a model fitted with such `k`.
#'
#' @param x (required, numeric vector) predictor, a time vector coerced to numeric. Default: NULL
#' @param y (required, numeric vector) response, a column of a zoo object. Default: NULL
#' @param max_complexity (required, logical). If TRUE, RMSE optimization is ignored, and the model of maximum complexity is returned. Default: FALSE
#'
#' @return GAM model.
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
#' #optimize gam model
#' m <- utils_optimize_gam(
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
#' )
#'
#' #plot prediction
#' points(
#'   x = zoo::index(xy),
#'   y = stats::predict(
#'     object = m,
#'     type = "response"
#'     ),
#'   col = "red"
#' )
#'
utils_optimize_gam <- function(
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

  complexity_space = seq(
    from = ceiling(nrow(model_df)/10),
    to = nrow(model_df) - 1,
    by = 1
  )

  #max complexity switch
  if(max_complexity == TRUE){

    complexity_optimal_value <- max(complexity_space)

  } else {

    `%iterator%` <- foreach::`%do%`

    rmse <- foreach::foreach(
      complexity_value = complexity_space,
      .combine = "c",
      .errorhandling = "pass"
    ) %iterator% {

      m_formula <- stats::as.formula(
        object = paste0(
          "y ~ s(x, k = ",
          complexity_value,
          ", fx = TRUE)"
        )
      )

      m <- tryCatch({
        mgcv::gam(
          formula = m_formula,
          data = model_df
        )
      }, error = function(e) {
        NA
      }, warning = function(w) {
        NA
      })

      if(
        inherits(
          x = m,
          what = "gam"
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

    #select k minimizing rmse
    complexity_optimal_value <- complexity_space[which.min(rmse)]

  }

  #new model
  m_formula <- stats::as.formula(
    object = paste0(
      "y ~ s(x, k = ",
      complexity_optimal_value,
      ", fx = TRUE)"
    )
  )

  m <- tryCatch({
    mgcv::gam(
      formula = m_formula,
      data = model_df
    )
  }, error = function(e) {
    NA
  }, warning = function(w) {
    NA
  })

  m

}
