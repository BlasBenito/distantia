#' Rolling Mean Smoothing
#'
#' @param x (required, zoo object).
#' @param w (required, window width) width of the window to compute the rolling mean of the time series.
#' @param statistic (required, function) name without quoites of a standard function to compute statistics. Typical examples are `mean`, `max`, `mean`, `median`, and `sd`.
#'
#' @return Data frame or matrix
#' @export
#' @autoglobal
f_stat <- function(
    x = NULL,
    w = 3,
    statistic = mean,
    ...
){

  if(is.function(statistic) == FALSE){

    stop(
      "Argument 'stat' must be a function name with no quotes"
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
    FUN = statistic,
    ... = ...
  )

  x

}

#' Rolling Mean Smoothing
#'
#' @param x (required, zoo object).
#' @param w (required, window width) width of the window to compute the rolling mean of the time series.
#'
#' @return Data frame or matrix
#' @export
#' @autoglobal
f_smooth <- function(
    x = NULL,
    w = 3,
    ...
){

  x <- zoo::rollmean(
    x = x,
    k = w,
    fill = c(
      "extend",
      "extend",
      "extend"
    ),
    ... = ...
  )

  x

}



#' Transformation to Proportions
#'
#' @param x Data frame or matrix.
#'
#' @return Data frame or matrix
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
#' @param x Data frame or matrix.
#'
#' @return Data frame or matrix
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
#' @param x Data frame or matrix.
#' @param pseudozero (required, numeric) Small number above zero to replace zeroes with.
#'
#' @return Data frame or matrix
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
#' @param x Data frame or matrix.
#'
#' @return Data frame or matrix
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
#' @param x Data frame or matrix.
#'
#' @return Data frame or matrix
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

  if(is.function(f) == FALSE){

    stop(
      "Argument 'f' must be a function name with no quotes. Valid options are: ",
      paste(
        ls(
          name = "package:distantia",
          pattern = "^f_"
        ),
        collapse = ", "
      ),
      "."
    )

  }

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
        tsl = tsl,
        tsl_test = FALSE
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
