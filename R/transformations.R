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
#'    x = rnorm(100),
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
#' @param center (optional, logical or numeric vector) if center is TRUE then centering is done by subtracting the column means of x from their corresponding columns.
#' @param scale (optional, logical or numeric vector) if scale is TRUE, and center is TRUE, then the scaling is done by dividing each column by their standard deviation. If center is FALSE, the each column is divided by their root mean square.
#'
#' @return Transformed zoo object.
#' @export
#' @autoglobal
f_pca <- function(
    x = NULL,
    center = TRUE,
    scale = FALSE,
    ...
) {

  y <- stats::prcomp(
    x = x,
    center = center,
    scale. = scale
  )$x

  y <- zoo::zoo(
    x = y,
    order.by = zoo::index(x)
  )

  y

}

#' Linear Detrending of a Time Series
#'
#' @description
#' The function applies a GAM to each column (time series) of the input matrix x separately, modeling the relationship between the values and the corresponding time index using a smooth spline function (s()). The predicted values from the GAMs represent the trend component of each time series. After obtaining the trend components for each time series, the function subtracts these trends from the original time series data to obtain the detrended series.
#'
#'
#' @param x (required, zoo object) Zoo time series object to transform.
#' @param select (optional, logical) Argument of [mgcv::gam()]. If TRUE then gam can add an extra penalty to each term so that it can be penalized to zero.
#' @param k (optional, integer) Argument of [mgcv::s()]. he dimension of the basis used to represent the smooth term. The default depends on the number of variables that the smooth is a function of. See [mgcv::choose.k()] for further information.
#'
#' @return Transformed zoo object.
#' @export
#' @autoglobal
f_detrend_gam <- function(
    x = NULL,
    select = FALSE,
    k = -1,
    ...
) {

  if(!requireNamespace(package = "ranger", quietly = TRUE)){
    stop("Please install the package 'mgcv' before running f_detrend_gam().")
  }

  x.index <- zoo::index(x)

  x.trend <- apply(
    X = x,
    MARGIN = 2,
    FUN = function(i){

      m.i <- mgcv::gam(
        formula =
          zoo::coredata(i) ~
          s(zoo::index(i), k = k),
        na.action = na.omit,
        select = select
      )

      stats::predict(
        object = m.i,
        type = "response"
        )

    }
  )

  x - x.trend

}

#' Linear Detrending of a Time Series
#'
#' @description
#' Fits a linear model on each column of a zoo object using time as a predictor, predicts the outcome, and subtracts it from the original data to return a detrended time series. This method might not be suitable if the input data is not seasonal and has a clear trend, so please be mindful of the limitations of this function when applied blindly.
#'
#'
#' @param x (required, zoo object) Zoo time series object to transform.
#'
#' @return Transformed zoo object.
#' @export
#' @autoglobal
f_detrend_linear <- function(
    x = NULL,
    ...
) {

  m <- stats::lm(
    formula = zoo::coredata(x) ~ zoo::index(x)
  )

  x.trend <- stats::predict(m)

  x - x.trend

}

#' Differencing Detrending of Time Series
#'
#' @description
#' Differencing detrending via [diff()]. Returns randomm fluctuations from sample to sample not related to the overall trend of the time series.
#'
#' @param x (required, zoo object) Zoo time series object to transform.
#' @param lag (optional, integer)
#'
#' @return Transformed zoo object.
#' @export
#' @autoglobal
f_detrend_difference <- function(
    x = NULL,
    lag = 1,
    ...
    ) {

  y <- diff(
    x = as.matrix(x),
    lag = as.integer(lag[1])
    )

  first.row <- matrix(
    data = 0,
    nrow = 1,
    ncol = ncol(x),
    dimnames = list(
      "1",
      colnames(x)
    )
  )

  y <- rbind(
    first.row,
    y
  )

  y <- zoo::zoo(
    x = y,
    order.by = zoo::index(x)
  )

  y

}

#' Moving Window Smoothing
#'
#' @param x (required, zoo object) Zoo time series object to transform.
#' @param w (required, window width) width of the window to compute the rolling statistics of the time series.
#' @param fun (required, function) name without quotes and parenthesis of a standard function to smooth a time series. Typical examples are `mean` (default), `max`, `mean`, `median`, and `sd`. Custom functions able to handle zoo objects or matrices are also allowed. Default: `mean`.
#'
#' @return Transformed zoo object.
#' @export
#' @autoglobal
f_smooth <- function(
    x = NULL,
    w = 3,
    fun = mean,
    ...
){

  if(is.function(fun) == FALSE){

    stop(
      "Argument 'fun' must be a function name."
      )

  }

  x <- zoo::rollapply(
    data = x,
    width = w,
    fill = c(
      "extend",
      "extend",
      "extend"
    ),
    FUN = fun,
    ... = ...
  )

  x

}


#' Transformation to Proportions
#'
#' @param x (required, zoo object) Zoo time series object to transform.
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
#'
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
#'
#' @return Transformed zoo object.
#' @export
#' @autoglobal
f_center <- function(
    x = NULL,
    center = TRUE,
    scale = FALSE,
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
