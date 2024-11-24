#' Lists Available Transformation Functions
#'
#' @return character vector
#' @export
#' @autoglobal
#' @examples
#' f_list()
#' @family tsl_transformation
f_list <- function(){

  f_funs <-  ls(
    name = "package:distantia",
    pattern = "^f_"
  )

  f_funs[f_funs != "f_list"]

}


#' Data Transformation: Moving Window Smoothing of Zoo Time Series
#'
#' @description
#' Simplified wrapper to [zoo::rollapply()] to apply rolling window smoothing to zoo objects.
#'
#'
#' @param x (required, zoo object) Zoo time series object to transform. Default: NULL
#' @param smoothing_window (required, odd integer) Width of the window to compute the rolling statistics of the time series. Should be an odd number. Even numbers are coerced to odd by adding one. Default: 3
#' @param smoothing_f (required, function) name without quotes and parenthesis of a standard function to smooth a time series. Typical examples are `mean` (default), `max`, `mean`, `median`, and `sd`. Custom functions able to handle zoo objects or matrices are also allowed. Default: `mean`.
#' @param ... (optional, additional arguments) additional arguments to `smoothing_f`. Used as argument `...` in [zoo::rollapply()].
#'
#' @return zoo object
#' @export
#' @autoglobal
#' @examples
#' x <- zoo_simulate(cols = 2)
#'
#' y <- f_smooth_window(
#'   x = x,
#'   smoothing_window = 5,
#'   smoothing_f = mean
#' )
#'
#' if(interactive()){
#'   zoo_plot(x)
#'   zoo_plot(y)
#' }
#' @family tsl_transformation
f_smooth_window <- function(
    x = NULL,
    smoothing_window = 3,
    smoothing_f = mean,
    ...
){

  if(is.function(smoothing_f) == FALSE){

    stop(
      "distantia::f_smooth_window(): argument 'smoothing_fun' must be a function name.",
      call. = FALSE
    )

  }

  #set window to even
  smoothing_window <- as.integer(smoothing_window)
  if((smoothing_window %% 2) == 0){
    smoothing_window <- smoothing_window + 1
  }

  y <- zoo::rollapply(
    data = x,
    width = smoothing_window,
    fill = rep(x = "extend", times = smoothing_window),
    FUN = smoothing_f,
    ... = ...
  )

  zoo_name_set(
    x = y,
    name = attributes(x)$name
  )

}

#' @title Data Transformation: Rescaling Values of Zoo Time Series to a New Range
#' @param x (required, zoo object) Time Series. Default: `NULL`
#' @param new_min (optional, numeric) New minimum value. Default: `0`
#' @param new_max (optional_numeric) New maximum value. Default: `1`
#' @param old_min (optional, numeric) Old minimum value. Default: `NULL`
#' @param old_max (optional_numeric) Old maximum value. Default: `NULL`
#' @return zoo object
#' @export
#' @autoglobal
#' @examples
#' x <- zoo_simulate(cols = 2)
#'
#' y <- f_rescale(
#'   x = x,
#'   new_min = 0,
#'   new_max = 100
#' )
#'
#' if(interactive()){
#'   zoo_plot(x)
#'   zoo_plot(y)
#' }
#' @family tsl_transformation
f_rescale <- function(
    x = NULL,
    new_min = 0,
    new_max = 1,
    old_min = NULL,
    old_max = NULL
){

  y <- apply(
    X = as.matrix(x),
    MARGIN = 2,
    FUN = utils_rescale_vector,
    new_min = new_min,
    new_max = new_max,
    old_min = old_min,
    old_max = old_max
  )

  y <- zoo::zoo(
    x = y,
    order.by = zoo::index(x)
  )

  zoo_name_set(
    x = y,
    name = attributes(x)$name
  )

}


#' Data Transformation: Principal Components of Zoo Time Series
#'
#' @description
#' Uses [stats::prcomp()] to compute the Principal Component Analysis of a time series and return the principal components instead of the original columns. Output columns are named "PC1", "PC2" and so on.
#'
#'
#' @param x (required, zoo object) Zoo time series object to transform.
#' @param ... (optional, additional arguments) Ignored in this function.
#'
#' @return zoo object
#' @export
#' @autoglobal
#' @examples
#' x <- zoo_simulate(cols = 2)
#'
#' y <- f_pca(
#'   x = x
#' )
#'
#' if(interactive()){
#'   zoo_plot(x)
#'   zoo_plot(y)
#' }
#' @family tsl_transformation
f_pca <- function(
    x = NULL,
    ...
) {

  y <- stats::prcomp(
    x = x,
    center = FALSE,
    scale. = FALSE
  )$x

  y <- zoo::zoo(
    x = y,
    order.by = zoo::index(x)
  )

  zoo_name_set(
    x = y,
    name = attributes(x)$name
  )

}

#' Data Transformation: Linear Trend of Zoo Time Series
#'
#' @description
#' Fits a linear model on each column of a zoo object using time as a predictor, and predicts the outcome.
#'
#'
#' @param x (required, zoo object) Zoo time series object to transform.
#' @param center (required, logical) If TRUE, the output is centered at zero. If FALSE, it is centered at the data mean. Default: TRUE
#' @param ... (optional, additional arguments) Ignored in this function.
#'
#' @return zoo object
#' @export
#' @autoglobal
#' @examples
#' x <- zoo_simulate(cols = 2)
#'
#' y <- f_trend_linear(
#'   x = x
#' )
#'
#' if(interactive()){
#'   zoo_plot(x)
#'   zoo_plot(y)
#' }
#' @family tsl_transformation
f_trend_linear <- function(
    x = NULL,
    center = TRUE,
    ...
) {

  x_data <- zoo::coredata(x, drop = FALSE)

  m <- stats::lm(
    formula = x_data ~ zoo::index(x)
  )

  #predict linear trend
  y <- stats::predict(m)

  if(center == TRUE){
    y <- y - mean(x_data)
  }

  y <- as.matrix(y)
  dimnames(y)[[2]] <- dimnames(x)[[2]]

  # recreate zoo
  y <- zoo::zoo(
    x = y,
    order.by = zoo::index(x)
  )

  zoo_name_set(
    x = y,
    name = attributes(x)$name
  )

}


#' Data Transformation: Linear Detrending of Zoo Time Series
#'
#' @description
#' Fits a linear model on each column of a zoo object using time as a predictor, predicts the outcome, and subtracts it from the original data to return a detrended time series. This method might not be suitable if the input data is not seasonal and has a clear trend, so please be mindful of the limitations of this function when applied blindly.
#'
#'
#' @param x (required, zoo object) Zoo time series object to transform.
#' @param center (required, logical) If TRUE, the output is centered at zero. If FALSE, it is centered at the data mean. Default: TRUE
#' @param ... (optional, additional arguments) Ignored in this function.
#'
#' @return zoo object
#' @export
#' @autoglobal
#' @examples
#' x <- zoo_simulate(cols = 2)
#'
#' y <- f_detrend_linear(
#'   x = x
#' )
#'
#' if(interactive()){
#'   zoo_plot(x)
#'   zoo_plot(y)
#' }
#' @family tsl_transformation
f_detrend_linear <- function(
    x = NULL,
    center = TRUE,
    ...
) {

  x_data <- zoo::coredata(x, drop = FALSE)

  m <- stats::lm(
    formula = x_data ~ zoo::index(x)
  )

  #predict linear trend
  x_trend <- stats::predict(m)

  #subtract trend
  y <- x_data - x_trend

  if(center == FALSE){
    y <- y + mean(x_data)
  }

  y <- as.matrix(y)
  dimnames(y)[[2]] <- dimnames(x)[[2]]

  # recreate zoo
  y <- zoo::zoo(
    x = y,
    order.by = zoo::index(x)
    )

  zoo_name_set(
    x = y,
    name = attributes(x)$name
  )

}

#' Data Transformation: Differencing Detrending of Zoo Time Series
#'
#' @description
#' Differencing detrending via [diff()]. Returns randomm fluctuations from sample to sample not related to the overall trend of the time series.
#'
#' @param x (required, zoo object) Zoo time series object to transform.
#' @param lag (optional, integer)
#' @param center (required, logical) If TRUE, the output is centered at zero. If FALSE, it is centered at the data mean. Default: TRUE
#' @param ... (optional, additional arguments) Ignored in this function.
#'
#' @return zoo object
#' @export
#' @autoglobal
#' @examples
#' x <- zoo_simulate(cols = 2)
#'
#' y_lag1 <- f_detrend_difference(
#'   x = x,
#'   lag = 1
#' )
#'
#' y_lag5 <- f_detrend_difference(
#'   x = x,
#'   lag = 5
#' )
#'
#' if(interactive()){
#'   zoo_plot(x)
#'   zoo_plot(y_lag1)
#'   zoo_plot(y_lag5)
#' }
#' @family tsl_transformation
f_detrend_difference <- function(
    x = NULL,
    lag = 1,
    center = TRUE,
    ...
) {

  x_data <- zoo::coredata(x, drop = FALSE)

  y <- diff(
    x = as.matrix(x_data),
    lag = as.integer(lag[1])
  )

  first.row <- matrix(
    data = 0,
    nrow = 1,
    ncol = ncol(x_data),
    dimnames = list(
      "1",
      colnames(x_data)
    )
  )

  y <- rbind(
    first.row,
    y
  )

  if(center == FALSE){
    y <- y + mean(x_data)
  }

  y <- as.matrix(y)
  dimnames(y)[[2]] <- dimnames(x)[[2]]

  y <- zoo::zoo(
    x = as.matrix(y),
    order.by = zoo::index(x)
  )

  zoo_name_set(
    x = y,
    name = attributes(x)$name
  )

}



#' Data Transformation: Convert Values to Proportions by Row
#'
#' @param x (required, zoo object) Zoo time series object to transform.
#' @param ... (optional, additional arguments) Ignored in this function.
#'
#' @return zoo object
#' @export
#' @autoglobal
#' @examples
#' x <- zoo_simulate(cols = 2)
#'
#' y <- f_proportion(
#'   x = x
#' )
#'
#' if(interactive()){
#'   zoo_plot(x)
#'   zoo_plot(y)
#' }
#' @family tsl_transformation
f_proportion <- function(
    x = NULL,
    ...
){

  y <- sweep(
    x = x,
    MARGIN = 1,
    STATS = rowSums(x),
    FUN = "/"
  )

  y_data <- zoo::coredata(y)

  y_data[is.nan(y_data)] <- 0

  zoo::coredata(y) <- y_data

  zoo_name_set(
    x = y,
    name = attributes(x)$name
  )

}

#' Data Transformation: Convert Values to Percentages by Row
#'
#' @param x (required, zoo object) Zoo time series object to transform.
#' @param ... (optional, additional arguments) Ignored in this function.
#'
#' @return zoo object
#' @export
#' @autoglobal
#' @examples
#' x <- zoo_simulate(cols = 2)
#'
#' y <- f_percentage(
#'   x = x
#' )
#'
#' if(interactive()){
#'   zoo_plot(x)
#'   zoo_plot(y)
#' }
#' @family tsl_transformation
f_percentage <- function(
    x = NULL,
    ...
){

  f_proportion(x)*100

}

#' Data Transformation: Hellinger Transformation by Rows
#'
#' @param x (required, zoo object) Zoo time series object to transform.
#' @param pseudozero (required, numeric) Small number above zero to replace zeroes with.
#' @param ... (optional, additional arguments) Ignored in this function.
#' @return zoo object
#' @export
#' @autoglobal
#' @examples
#' x <- zoo_simulate(
#'   cols = 5,
#'   data_range = c(0, 500)
#'   )
#'
#' y <- f_hellinger(
#'   x = x
#' )
#'
#' if(interactive()){
#'   zoo_plot(x)
#'   zoo_plot(y)
#' }
#' @family tsl_transformation
f_hellinger <- function(
    x = NULL,
    pseudozero = 0.0001,
    ...
){

  x.matrix <- zoo::coredata(x)

  x.matrix[x.matrix == 0] <- pseudozero

  x.matrix <- zoo::zoo(
    x = x.matrix,
    order.by = zoo::index(x)
  )

  y <- sqrt(
    sweep(
      x = x.matrix,
      MARGIN = 1,
      STATS = rowSums(x),
      FUN = "/"
    )
  )

  y_data <- zoo::coredata(y)

  y_data[is.nan(y_data)] <- 0

  zoo::coredata(y) <- y_data

  zoo_name_set(
    x = y,
    name = attributes(x)$name
  )

}

#' Data Transformation: Data Centering by Column
#'
#' @description
#' Wraps [base::scale()] for global centering with [tsl_transform()].
#'
#'
#' @param x (required, zoo object) Zoo time series object to transform.
#' @param center (optional, logical or numeric vector) Triggers centering if TRUE. Default: TRUE
#' @param scale (optional, logical or numeric vector) Triggers scaling if TRUE. Default: FALSE
#' @return zoo object
#' @export
#' @autoglobal
#' @examples
#' x <- zoo_simulate()
#'
#' y <- f_center(
#'   x = x
#' )
#'
#' if(interactive()){
#'   zoo_plot(x)
#'   zoo_plot(y)
#' }
#' @family tsl_transformation
f_center <- function(
    x = NULL,
    center = TRUE,
    scale = FALSE
){

  scale(
    x = x,
    center = center,
    scale = scale
  )

}

#' Data Transformation: Data Centering and Scaling by Column Using Global Mean and Standard Deviation
#'
#' @description
#' Wraps [base::scale()] for global centering and scaling with [tsl_transform()].
#'
#' @param x (required, zoo object) Zoo time series object to transform.
#' @param center (optional, logical or numeric vector) Triggers centering if TRUE. Default: TRUE
#' @param scale (optional, logical or numeric vector) Triggers scaling if TRUE. Default: TRUE
#' @param .global (optional, logical) Used to trigger global scaling within [tsl_transform()].
#'
#' @return zoo object
#' @export
#' @autoglobal
#' @examples
#' x <- zoo_simulate()
#'
#' y <- f_scale(
#'   x = x
#' )
#'
#' if(interactive()){
#'   zoo_plot(x)
#'   zoo_plot(y)
#' }
#' @family tsl_transformation
f_scale_global <- function(
    x = NULL,
    center = TRUE,
    scale = TRUE,
    .global
){

  scale(
    x = x,
    center = center,
    scale = scale
  )

}

#' Data Transformation: Data Centering and Scaling by Column
#'
#' @description
#' Wraps [base::scale()] for centering and scaling with [tsl_transform()].
#'
#' @param x (required, zoo object) Zoo time series object to transform.
#' @param center (optional, logical or numeric vector) Triggers centering if TRUE. Default: TRUE
#' @param scale (optional, logical or numeric vector) Triggers scaling if TRUE. Default: TRUE
#'
#' @return zoo object
#' @export
#' @autoglobal
#' @examples
#' x <- zoo_simulate()
#'
#' y <- f_scale(
#'   x = x
#' )
#'
#' if(interactive()){
#'   zoo_plot(x)
#'   zoo_plot(y)
#' }
#' @family tsl_transformation
f_scale <- function(
    x = NULL,
    center = TRUE,
    scale = TRUE
){

  scale(
    x = x,
    center = center,
    scale = scale
  )

}


#' Data Transformation: Slope of Linear Regression with Time
#'
#' @description
#' Designed for usage in [tsl_aggregate()]. Uses linear regression to compute and return the slope of a numeric vector. Returns 0 if the length of the input vector is 1 or the linear regression fails.
#'
#' @param x (required, numeric vector) input vector. Default: NULL
#' @param ... (optional, additional arguments) Ignored in this function.
#' @return numeric value
#' @export
#' @autoglobal
#'
#' @examples
#' # Numeric vector of any length
#' f_slope(x = cumsum(runif(10)))
#'
#' # Numeric vector with length = 1
#' f_slope(x = 10)
#'
#' # Numeric vector with length = 0
#' f_slope(x = numeric(0))
#' @family tsl_transformation
f_slope <- function(
    x = NULL,
    ...
    ) {

  if(!is.numeric(x)) {
    stop("distantia::f_slope(): argument 'x' must be a numeric vector.", call. = FALSE)
  }

  if(length(x) <= 1){

    slope <- 0

  } else {

    slope <- tryCatch(
      {
        summary(
          stats::lm(
            formula = x ~ seq_along(x)
            )
          )$coefficients[2, 1]
      },
      error = function(e){
        return(NA)
      }
    ) |>
      suppressWarnings()

  }

  if(is.na(slope)){
    slope <- 0
  }

  slope

}
