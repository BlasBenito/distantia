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



# Detrending ----

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

#' Data Transformation: Detrending and Differencing
#'
#' @description
#' Performs differencing to remove trends from a zoo time series, isolating short-term fluctuations by subtracting values at specified lags. The function preserves the original index and metadata, with an option to center the output around the mean of the original series. Suitable for preprocessing time series data to focus on random fluctuations unrelated to overall trends.
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

# Aggregation ----

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


# Rowwise Transformations ----

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




# Rescaling ----

#' Data Transformation: Global Centering and Scaling
#'
#' @description
#' Scaling and/or centering by variable using the mean and standard deviation computed across all time series. Global scaling helps dynamic time warping take variable offsets between time series into account.
#'
#' @param x (required, zoo object) Zoo time series object to transform.
#' @param center (optional, logical or numeric vector) Triggers centering if TRUE. Default: TRUE
#' @param scale (optional, logical or numeric vector) Triggers scaling if TRUE. Default: TRUE
#' @param .global (optional, logical) Used to trigger global scaling within [tsl_transform()].
#' @param ... (optional, additional arguments) Ignored in this function.
#'
#' @return zoo object
#' @export
#' @autoglobal
#' @examples
#' x <- zoo_simulate()
#'
#' y <- f_scale_global(
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
    .global,
    ...
){

  scale(
    x = x,
    center = center,
    scale = scale
  )

}

#' Data Transformation: Local Centering and Scaling
#'
#' @description
#' Scaling and/or centering by variable and time series. Local scaling helps dynamic time warping focus entirely on shape comparisons.
#'
#' @inherit f_scale_global
#' @export
#' @autoglobal
#' @family tsl_transformation
f_scale_local <- function(
    x = NULL,
    center = TRUE,
    scale = TRUE,
    ...
){

  scale(
    x = x,
    center = center,
    scale = scale
  )

}

#' @title Data Transformation: Local Rescaling of to a New Range
#' @inherit f_rescale_global
#' @export
#' @autoglobal
#' @family tsl_transformation
f_rescale_local <- function(
    x = NULL,
    new_min = 0,
    new_max = 1,
    old_min = NULL,
    old_max = NULL,
    ...
){

  y <- as.matrix(x)

  if(!is.null(old_min) && length(old_min) < ncol(y)){
    stop(
      "distantia::f_rescale_global(): argument 'old_min' must be NULL or a vector of length ", ncol(y), ".", call. = FALSE
    )
  }

  if(!is.null(old_max) && length(old_max) < ncol(y)){
    stop(
      "distantia::f_rescale_global(): argument 'old_max' must be NULL or a vector of length ", ncol(y), ".", call. = FALSE
    )
  }

  if(length(new_min) < ncol(y)){
    new_min <- rep(x = new_min, times = ncol(y))
  }

  if(length(new_max) < ncol(y)){
    new_max <- rep(x = new_max, times = ncol(y))
  }

  for(i in seq_len(ncol(y))){

    y[, i] <- utils_rescale_vector(
      x =  y[, i],
      new_min = new_min[i],
      new_max = new_max[i],
      old_min = old_min[i],
      old_max = old_max[i]
    )

  }

  y <- zoo::zoo(
    x = y,
    order.by = zoo::index(x)
  )

  zoo_name_set(
    x = y,
    name = attributes(x)$name
  )

}


#' @title Data Transformation: Global Rescaling of to a New Range
#' @param x (required, zoo object) Time Series. Default: `NULL`
#' @param new_min (optional, numeric) New minimum value. Default: `0`
#' @param new_max (optional_numeric) New maximum value. Default: `1`
#' @param old_min (optional, numeric) Old minimum value. Default: `NULL`
#' @param old_max (optional_numeric) Old maximum value. Default: `NULL`
#' @param .global (optional, logical) Used to trigger global scaling within [tsl_transform()].
#' @param ... (optional, additional arguments) Ignored in this function.
#' @return zoo object
#' @export
#' @autoglobal
#' @examples
#' x <- zoo_simulate(cols = 2)
#'
#' y <- f_rescale_global(
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
f_rescale_global <- function(
    x = NULL,
    new_min = 0,
    new_max = 1,
    old_min = NULL,
    old_max = NULL,
    .global,
    ...
){

  y <- as.matrix(x)

  if(!is.null(old_min) && length(old_min) < ncol(y)){
    stop(
      "distantia::f_rescale_global(): argument 'old_min' must be NULL or a vector of length ", ncol(y), ".", call. = FALSE
    )
  }

  if(!is.null(old_max) && length(old_max) < ncol(y)){
    stop(
      "distantia::f_rescale_global(): argument 'old_max' must be NULL or a vector of length ", ncol(y), ".", call. = FALSE
    )
  }

  if(length(new_min) < ncol(y)){
    new_min <- rep(x = new_min, times = ncol(y))
  }

  if(length(new_max) < ncol(y)){
    new_max <- rep(x = new_max, times = ncol(y))
  }

  for(i in seq_len(ncol(y))){

    y[, i] <- utils_rescale_vector(
      x =  y[, i],
      new_min = new_min[i],
      new_max = new_max[i],
      old_min = old_min[i],
      old_max = old_max[i]
    )

  }

  y <- zoo::zoo(
    x = y,
    order.by = zoo::index(x)
  )

  zoo_name_set(
    x = y,
    name = attributes(x)$name
  )

}


