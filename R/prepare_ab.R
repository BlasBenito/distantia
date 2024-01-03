#' Prepare Two Sequences for Dissimilarity Analysis
#'
#' Prepares two sequences 'a' and 'b' for dissimilarity analysis. Please make sure that 'a' and 'b' have matching column names, as the output will only contain their common columns.
#'
#' @param a (required, data frame, matrix, or numeric vector) a time series.
#' @param b (required, data frame, matrix, or numeric vector) a time series.
#' @param distance (optional, character vector) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#' @param paired_samples (optional, logical vector) If TRUE, time-series are compared row wise and no least-cost path is computed. Default: FALSE.
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
#'  distance = "euclidean",
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
    distance = "euclidean",
    paired_samples = FALSE
    ){

  #check validation flags
  a.validated <- ifelse(
    test = "validated" %in% names(attributes(a)),
    yes = attributes(a)$validated,
    no = FALSE
  )

  b.validated <- ifelse(
    test = "validated" %in% names(attributes(b)),
    yes = attributes(b)$validated,
    no = FALSE
  )

  #validating
  if(any(c(a.validated, b.validated)) == FALSE){

    if(!any(class(a) %in% c("data.frame", "matrix", "vector"))){
      stop("Argument 'a' must be a data frame, matrix, or vector.")
    }

    if(!any(class(b) %in% c("data.frame", "matrix", "vector"))){
      stop("Argument 'b' must be a data frame, matrix, or vector")
    }

    #checking for NA
    a.na <- sum(is.na(a))
    if(a.na > 0){
      stop(
        "Argument 'a' has ",
        a.na,
        " NA values. Please remove or imputate NA values before the dissimilarity analysis."
      )
    }

    b.na <- sum(is.na(b))
    if(b.na > 0){
      stop("Argument 'b' has ",
           b.na,
           " NA values. Please remove or imputate NA values before the dissimilarity analysis."
      )
    }

    # keep only numeric columns
    if(inherits(x = a, what = "data.frame")){
      a <- a[, sapply(a, is.numeric)]
    }

    if(inherits(x = b, what = "data.frame")){
      b <- b[, sapply(b, is.numeric)]
    }

    #convert to matrix
    if(!is.matrix(a)){
      a <- as.matrix(a)
    }

    if(!is.matrix(b)){
      b <- as.matrix(b)
    }

    #check colnames
    if(
      (is.null(colnames(a)) | is.null(colnames(b))) &&
      ncol(a) != ncol(b)
    ){

      stop("Arguments 'a' and 'b' must either have column names or the same number of columns.")

      if(is.null(attributes(a)$name)){
        attr(a, "name") <- "a"
      }

      if(is.null(attributes(b)$name)){
        attr(b, "name") <- "b"
      }

    }


    if(paired_samples == TRUE && (nrow(a) != nrow(b))){
      stop("Arguments 'a' and 'b' must have the same number of rows when 'paired_samples = TRUE'.")
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

      if(sum(a[a == 0]) > 0){
        stop("Argument 'a' has zeros incompatible with the 'chi' and 'cosine' distances. Please replace these zeros with pseudo-zeros, or choose a different distance metric.")
      }

      if(sum(b[b == 0]) > 0){
        stop("Argument 'b' has zeros incompatible with the 'chi' and 'cosine' distances. Please replace these zeros with pseudo-zeros, or choose a different distance metric.")
      }

    }


  }

  #subsetting to common columns
  if(ncol(a) != ncol(b)){
    common.cols <- intersect(
      x = colnames(a),
      y = colnames(b)
    )
    a <- a[, common.cols]
    b <- b[, common.cols]
  }

  out <- list(
    a = a,
    b = b
  )

  names(out) <- c(
    attributes(a)$name,
    attributes(b)$name
  )

  out

}
