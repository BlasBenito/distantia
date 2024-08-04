#' Lists Transformation Functions
#'
#' @return character vector with function names
#' @export
#' @autoglobal
f_list <- function(){

  f_funs <-  ls(
    name = "package:distantia",
    pattern = "^f_"
  )

  f_funs[f_funs != "f_list"]

}

#' @title Rescales Numeric Vector to a New Range
#' @param x (required, numeric vector) Numeric vector. Default: `NULL`
#' @param new_min (optional, numeric) New minimum value. Default: `0`
#' @param new_max (optional_numeric) New maximum value. Default: `1`
#' @param old_min (optional, numeric) Old minimum value. Default: `NULL`
#' @param old_max (optional_numeric) Old maximum value. Default: `NULL`
#' @return Numeric vector
#' @examples
#'
#'  out <- rescale_vector(
#'    x = stats::rnorm(100),
#'    new_min = 0,
#'    new_max = 100,
#'    integer = TRUE
#'    )
#'    out
#'
#' @export
#' @autoglobal
rescale_vector <- function(
    x = NULL,
    new_min = 0,
    new_max = 1,
    old_min = NULL,
    old_max = NULL
){

  if(!is.vector(x) || !is.numeric(x)){
    stop("x must be a numeric vector.")
  }

  if(is.null(old_min)){
    old_min <- min(x, na.rm = TRUE)
  }

  if(is.null(old_max)){
    old_max <- max(x, na.rm = TRUE)
  }

  ((x - old_min) / (old_max - old_min)) * (new_max - new_min) + new_min


}

#' @title Rescales Zoo Object to a New Range
#' @param x (required, zoo object) Numeric vector. Default: `NULL`
#' @param new_min (optional, numeric) New minimum value. Default: `0`
#' @param new_max (optional_numeric) New maximum value. Default: `1`
#' @param old_min (optional, numeric) Old minimum value. Default: `NULL`
#' @param old_max (optional_numeric) Old maximum value. Default: `NULL`
#' @return Zoo object
#' @export
#' @autoglobal
f_rescale <- function(
    x = NULL,
    new_min = 0,
    new_max = 1,
    old_min = NULL,
    old_max = NULL
){

  x.index <- zoo::index(x)

  x <- as.matrix(x)

  x <- apply(
    X = x,
    MARGIN = 2,
    FUN = rescale_vector,
    new_min = new_min,
    new_max = new_max,
    old_min = old_min,
    old_max = old_max
  )

  x <- zoo::zoo(
    x = x,
    order.by = x.index
  )

  x

}


#' Principal Components of a Time Series
#'
#' @description
#' Uses [stats::prcomp()] to compute the Principal Component Analysis of a time series and return the principal components instead of the original columns. Output columns are named "PC1", "PC2" and so on.
#'
#'
#' @param x (required, zoo object) Zoo time series object to transform.
#' @param ... (optional, additional arguments) Ignored in this function.
#'
#' @return Transformed zoo object.
#' @export
#' @autoglobal
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

  y

}

#' Linear Trend of a Time Series
#'
#' @description
#' Fits a linear model on each column of a zoo object using time as a predictor, and predicts the outcome.
#'
#'
#' @param x (required, zoo object) Zoo time series object to transform.
#' @param center (required, logical) If TRUE, the output is centered at zero. If FALSE, it is centered at the data mean. Default: TRUE
#' @param ... (optional, additional arguments) Ignored in this function.
#'
#' @return Transformed zoo object.
#' @export
#' @autoglobal
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
  x_trend <- stats::predict(m)

  if(center == TRUE){
    x_trend <- x_trend - mean(x_data)
  }

  x_trend <- as.matrix(x_trend)
  dimnames(x_trend)[[2]] <- dimnames(x)[[2]]

  # recreate zoo
  zoo::zoo(
    x = x_trend,
    order.by = zoo::index(x)
  )

}


#' Linear Detrending of a Time Series
#'
#' @description
#' Fits a linear model on each column of a zoo object using time as a predictor, predicts the outcome, and subtracts it from the original data to return a detrended time series. This method might not be suitable if the input data is not seasonal and has a clear trend, so please be mindful of the limitations of this function when applied blindly.
#'
#'
#' @param x (required, zoo object) Zoo time series object to transform.
#' @param center (required, logical) If TRUE, the output is centered at zero. If FALSE, it is centered at the data mean. Default: TRUE
#' @param ... (optional, additional arguments) Ignored in this function.
#'
#' @return Transformed zoo object.
#' @export
#' @autoglobal
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
  x_detrended <- x_data - x_trend

  if(center == FALSE){
    x_detrended <- x_detrended + mean(x_data)
  }

  x_detrended <- as.matrix(x_detrended)
  dimnames(x_detrended)[[2]] <- dimnames(x)[[2]]

  # recreate zoo
  zoo::zoo(
    x = x_detrended,
    order.by = zoo::index(x)
    )

}

#' Differencing Detrending of Time Series
#'
#' @description
#' Differencing detrending via [diff()]. Returns randomm fluctuations from sample to sample not related to the overall trend of the time series.
#'
#' @param x (required, zoo object) Zoo time series object to transform.
#' @param lag (optional, integer)
#' @param center (required, logical) If TRUE, the output is centered at zero. If FALSE, it is centered at the data mean. Default: TRUE
#' @param ... (optional, additional arguments) Ignored in this function.
#'
#' @return Transformed zoo object.
#' @export
#' @autoglobal
f_detrend_difference <- function(
    x = NULL,
    lag = 1,
    center = TRUE,
    ...
) {

  x_data <- zoo::coredata(x, drop = FALSE)

  x_detrended <- diff(
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

  x_detrended <- rbind(
    first.row,
    x_detrended
  )

  if(center == FALSE){
    x_detrended <- x_detrended + mean(x_data)
  }

  x_detrended <- as.matrix(x_detrended)
  dimnames(x_detrended)[[2]] <- dimnames(x)[[2]]

  zoo::zoo(
    x = as.matrix(x_detrended),
    order.by = zoo::index(x)
  )

}



#' Transformation to Proportions
#'
#' @param x (required, zoo object) Zoo time series object to transform.
#' @param ... (optional, additional arguments) Ignored in this function.
#'
#' @return Transformed zoo object.
#' @export
#' @autoglobal
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

  y
}

#' Transformation to Percentage
#'
#' @param x (required, zoo object) Zoo time series object to transform.
#' @param ... (optional, additional arguments) Ignored in this function.
#'
#' @return Transformed zoo object.
#' @export
#' @autoglobal
f_percentage <- function(
    x = NULL,
    ...
){
  f_proportion(x)*100
}

#' Hellinger Transformation
#'
#' @param x (required, zoo object) Zoo time series object to transform.
#' @param pseudozero (required, numeric) Small number above zero to replace zeroes with.
#' @param ... (optional, additional arguments) Ignored in this function.
#' @return Transformed zoo object.
#' @export
#' @autoglobal
f_hellinger <- function(
    x = NULL,
    pseudozero = 0.0001,
    ...
){

  x.index <- zoo::index(x)

  x <- as.matrix(x)

  x[x == 0] <- pseudozero

  x <- zoo::zoo(
    x = x,
    order.by = x.index
  )

  x <- sqrt(
    sweep(
      x = x,
      MARGIN = 1,
      STATS = rowSums(x),
      FUN = "/"
    )
  )

  x

}

#' Global Centering
#'
#' @description
#' Centers using the global average of all zoo objects within a time series list. Please use [base::scale()] to scale each time series independently.
#'
#'
#' @param x (required, zoo object) Zoo time series object to transform.
#' @param center (optional, logical or numeric vector) if center is TRUE then centering is done by subtracting the column means of x from their corresponding columns.
#' @param ... (optional, additional arguments) Ignored in this function.
#' @return Transformed zoo object.
#' @export
#' @autoglobal
f_center <- function(
    x = NULL,
    center = TRUE,
    ...
){

  scale(
    x = x,
    center = center,
    scale = FALSE
  )

}

#' Global Centering and scaling
#'
#' @description
#' Centers and scales using the global average  and standard deviation of all zoo objects within a time series list. Please use [base::scale()] to center and scale each time series independently.
#'
#' @param x (required, zoo object) Zoo time series object to transform.
#' @param center (optional, logical or numeric vector) if center is TRUE then centering is done by subtracting the column means of x from their corresponding columns.
#' @param scale (optional, logical or numeric vector) if scale is TRUE, and center is TRUE, then the scaling is done by dividing each column by their standard deviation. If center is FALSE, the each column is divided by their root mean square.
#' @param ... (optional, additional arguments) Ignored in this function.
#'
#' @return Transformed zoo object.
#' @export
#' @autoglobal
f_scale <- function(
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


#' Handles Centering and Scaling within tsl_transform()
#'
#' @param tsl (required, list of zoo objects) List of time series. Default: NULL
#' @param f (required, transformation function) name of a function taking a matrix as input.
#' @param ... (optional, arguments of `f`) Optional arguments for the transformation function.
#'
#' @return Named list with center and scale parameters
#' @export
#' @autoglobal
scaling_parameters <- function(
    tsl = NULL,
    f = NULL,
    ...
){

  args <- list(...)

  #scaling
  if(
    all(c("center", "scale", "...") %in% names(formals(f)))
  ){


    #removing exclusive columns
    exclusive.columns <- tsl_colnames(
      tsl = tsl,
      names = "exclusive"
    ) |>
      unlist() |>
      unique() |>
      suppressMessages()

    if(length(exclusive.columns) > 0){

      message("Removing exclusive columns before scaling.")

      tsl <- tsl_remove_exclusive_cols(
        tsl = tsl
      )

    }

    #giving priority to user input
    if("center" %in% names(args)){
      center <- args$center
    } else {
      center <- formals(f)$center
    }

    if("scale" %in% names(args)){
      scale <- args$scale
    } else {
      scale <- formals(f)$scale
    }

    #joining data for mean and sd computation
    tsl.matrix <- lapply(
      X = tsl,
      FUN = as.matrix
    )

    tsl.matrix <- do.call(
      what = "rbind",
      args = tsl.matrix
    )

    if(center == TRUE){
      center.mean <- apply(
        X = tsl.matrix,
        MARGIN = 2,
        FUN = mean
      )
    } else {
      center.mean <- FALSE
    }

    if(scale == TRUE){
      scale.sd <- apply(
        X = tsl.matrix,
        MARGIN = 2,
        FUN = sd
      )
    } else {
      scale.sd <- FALSE
    }

    return(  list(
      center = center.mean,
      scale = scale.sd
    ))

  }

  NULL

}


#' Linear Slope of Time Series
#'
#' @description
#' Calculates the slope of a numeric vector using linear regression. If the length of the input vector is 1, it returns 0. If linear regression fails, it returns NA.
#'
#' Useful for [tsl_transform()] or [tsl_aggregate()].
#'
#'
#' @param x (required, numeric vector) input vector. Default: NULL
#' @param ... (optional, additional arguments) Ignored in this function.
#' @return Slope of the numeric vector
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
#'
f_slope <- function(
    x = NULL,
    ...
    ) {

  if(!is.numeric(x)) {
    stop("Input must be a numeric vector.")
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
