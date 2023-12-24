#' Prepare Two Sequences for Dissimilarity Analysis
#'
#' Prepares two sequences 'a' and 'b' for dissimilarity analysis. Please make sure that 'a' and 'b' have matching column names, as the output will only contain their common columns.
#'
#' @param a (required, data frame, matrix, or numeric vector) a time series.
#' @param b (required, data frame, matrix, or numeric vector) a time series.
#' @param method (optional, character vector) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `methods`. Default: "euclidean".
#' @param paired_samples (optional, logical vector) If TRUE, time-series are compared row wise and no least-cost path is computed. Default: FALSE.
#' @param pseudo_zero (optional, numeric) value to replace zero values if distance metrics "psi" and "cosine" are used. Default: 0.0001.
#'
#' @return A list containing the prepared sequences'a' and 'b'.
#'
#' @details This function checks and preprocesses the input data 'a' and 'b' for compatibility and consistency in preparation for dissimilarity analysis.
#'
#' @examples
#'
#' ab <- prepare_ab(
#'  a = na.omit(sequenceA),
#'  b = na.omit(sequenceB),
#'  method = "euclidean",
#'  paired_samples = FALSE
#'  )
#'
#'  a <- ab$a
#'  b <- ab$b
#'
#' @autoglobal
#' @export
prepare_ab <- function(
    a = NULL,
    b = NULL,
    method = "euclidean",
    paired_samples = FALSE,
    pseudo_zero = 0.0001
    ){

  #selecting method
  method <- match.arg(
    arg = method,
    choices = c(
      methods$name,
      methods$abbreviation
    ),
    several.ok = TRUE
  )

  if(!any(class(a) %in% c("data.frame", "matrix", "vector"))){
    stop("Argument 'a' must be a data frame or matrix.")
  }

  if(!any(class(b) %in% c("data.frame", "matrix", "vector"))){
    stop("Argument 'b' must be a data frame or matrix.")
  }

  #checking for NA
  if(sum(is.na(a)) > 0){
    stop("Argument 'a' has NA values. Please remove or imputate NA values before the dissimilarity analysis.")
  }

  if(sum(is.na(b)) > 0){
    stop("Argument 'b' has NA values. Please remove or imputate NA values before the dissimilarity analysis.")
  }

  #if vector, one column data frame
  if(is.vector(a)){
    a <- data.frame(
      column_1 = a
    )
  }

  if(is.vector(b)){
    b <- data.frame(
      column_1 = b
    )
  }

  #check colnames
  if(is.null(colnames(a))){

    if(ncol(a) != ncol(b)){
      warning("Sequence 'a' does not have column names and differs in the number of columns compared to 'b'. This might lead to inconsistent column matching and unreliable results during the dissimilarity analysis.")
    }

    colnames(a) <- seq(
      from = 1,
      to = ncol(a)
    ) |>
      as.character()

  }

  #check colnames
  if(is.null(colnames(b))){

    if(ncol(a) != ncol(b)){
      warning("Sequence 'b' does not have column names and differs in the number of columns compared to 'a'. This might lead to inconsistent column matching and unreliable results during the dissimilarity analysis.")
    }

    colnames(b) <- seq(
      from = 1,
      to = ncol(b)
    ) |>
      as.character()

  }


  #preprocessing data
  if(ncol(a) != ncol(b)){
    common.cols <- intersect(
      x = colnames(a),
      y = colnames(b)
    )
    a <- a[, common.cols]
    b <- b[, common.cols]
  }

  if(!is.matrix(a)){
    a <- as.matrix(a)
  }

  if(!is.matrix(b)){
    b <- as.matrix(b)
  }

  if(paired_samples == TRUE && (nrow(a) != nrow(b))){
    stop("Arguments 'a' and 'b' must have the same number of rows when 'paired_samples = TRUE'.")
  }


  #methods that don't accept two zeros in same position
  if(
    any(
      c(
        "chi",
        "cos",
        "cosine"
      ) %in% method
    )
  ){

    a[a == 0] <- pseudo_zero
    b[b == 0] <- pseudo_zero

  }

  list(
    a = a,
    b = b
  )

}
