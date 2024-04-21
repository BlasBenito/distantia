#' Prepare Two Sequences for Dissimilarity Analysis
#'
#' Prepares two sequences 'x' and 'y' for dissimilarity analysis. Please make sure that 'x' and 'y' have matching column names, as the output will only contain their common columns.
#'
#' @param x (required, data frame, matrix, or numeric vector) a sequence. Default: NULL
#' @param y (required, data frame, matrix, or numeric vector) a sequence. Default: NULL
#' @param distance (optional, character vector) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#' @param paired_samples (optional, logical vector) If TRUE, time-series are compared row wise and no least-cost path is computed. Default: FALSE.
#'
#' @return A list containing the prepared sequences'x' and 'y'.
#'
#' @details This function checks and preprocesses the input data 'x' and 'y' for compatibility and consistency in preparation for dissimilarity analysis.
#'
#' @examples
#'
#' xy <- prepare_xy(
#'  x = na.omit(sequenceA),
#'  y = na.omit(sequenceB),
#'  distance = "euclidean",
#'  paired_samples = FALSE
#'  )
#'
#'  x <- xy$x
#'  y <- xy$y
#'
#' @autoglobal
#' @export
prepare_xy <- function(
    x = NULL,
    y = NULL,
    distance = "euclidean",
    paired_samples = FALSE
    ){

  x <- utils_check_zoo_args(
    x = x,
    arg_name = "x"
  )

  y <- utils_check_zoo_args(
    x = y,
    arg_name = "y"
  )

  distance <- utils_check_distance_args(
    distance = distance
  )

  target_classes <- c(
    "data.frame",
    "matrix",
    "numeric",
    "vector",
    "zoo"
  )

  #validate x
    if(all(inherits(x = x, what = target_classes) == FALSE)){
      stop("Argument 'x' must be a data frame, matrix, or numeric vector.")
    }

    #checking for NA
    x.na <- sum(is.na(x))
    if(x.na > 0){
      stop(
        "Argument 'x' has ",
        x.na,
        " NA values. Please remove or imputate NA values before the dissimilarity analysis."
      )
    }

    # keep only numeric columns
    if(inherits(x = x, what = "data.frame")){
      x <- x[, sapply(x, is.numeric)]
    }

  #validate y
    if(all(inherits(x = y, what = target_classes) == FALSE)){
      stop("Argument 'y' must be a data frame, matrix, or numeric vector.")
    }

    y.na <- sum(is.na(y))
    if(y.na > 0){
      stop("Argument 'y' has ",
           y.na,
           " NA values. Please remove or imputate NA values before the dissimilarity analysis."
      )
    }

    if(inherits(x = y, what = "data.frame")){
      y <- y[, sapply(y, is.numeric)]
    }

    #check colnames
    if(
      (is.null(colnames(x)) | is.null(colnames(y))) &&
      ncol(x) != ncol(y)
    ){

      stop("Arguments 'x' and 'y' must either have column names or the same number of columns.")

    }


    if(paired_samples == TRUE && (nrow(x) != nrow(y))){
      stop("Arguments 'x' and 'y' must have the same number of rows when 'paired_samples = TRUE'.")
    }

    #distances that don't accept two zeros in same position
    if(
      any(
        c(
          "chi",
          "cos",
          "cosine"
        ) %in% distance
      )
    ){

      if(sum(x[x == 0]) > 0){
        stop("Argument 'x' has zeros incompatible with the 'chi' and 'cosine' distances. Please replace these zeros with pseudo-zeros, or choose a different distance metric.")
      }

      if(sum(y[y == 0]) > 0){
        stop("Argument 'y' has zeros incompatible with the 'chi' and 'cosine' distances. Please replace these zeros with pseudo-zeros, or choose a different distance metric.")
      }

    }

  #storing attributes
  x.time <- attributes(x)$index
  x.name <- attributes(x)$name

  y.time <- attributes(y)$index
  y.name <- attributes(y)$name

  #subsetting to common columns
  if(ncol(x) != ncol(y)){
    common.cols <- intersect(
      x = colnames(x),
      y = colnames(y)
    )
    x <- x[, common.cols, drop = FALSE]
    y <- y[, common.cols, drop = FALSE]
  }

  #convert to matrix
  if(!is.matrix(x)){
    x <- as.matrix(x)
  }

  if(!is.matrix(y)){
    y <- as.matrix(y)
  }

  #restoring attributes
  attr(x = x, which = "time") <- x.time
  attr(x = x, which = "name") <- x.name

  attr(x = y, which = "time") <- y.time
  attr(x = y, which = "name") <- y.name

  if(is.null(attributes(x)$name)){
    attr(x, "name") <- "x"
  }

  if(is.null(attributes(y)$name)){
    attr(y, "name") <- "y"
  }

  attr(x, "validated") <- TRUE
  attr(y, "validated") <- TRUE

  out <- list(
    x = x,
    y = y
  )

  names(out) <- c(
    ifelse(
      test = is.null(attributes(x)$name),
      yes = "x",
      no = attributes(x)$name
    ),
    ifelse(
      test = is.null(attributes(y)$name),
      yes = "y",
      no = attributes(y)$name
    )
  )

  out

}
