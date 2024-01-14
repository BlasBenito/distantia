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

  distance <- check_args_distance(
    distance = distance
  )

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

  target_classes <- c(
    "data.frame",
    "matrix",
    "numeric",
    "vector"
  )

  #validate a
  if(a.validated == FALSE){

    if(all(inherits(x = a, what = target_classes) == FALSE)){
      stop("Argument 'a' must be a data frame, matrix, or numeric vector.")
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

    # keep only numeric columns
    if(inherits(x = a, what = "data.frame")){
      a <- a[, sapply(a, is.numeric)]
    }


  }

  #validate b
  if(b.validated == FALSE){

    if(all(inherits(x = b, what = target_classes) == FALSE)){
      stop("Argument 'b' must be a data frame, matrix, or numeric vector.")
    }

    b.na <- sum(is.na(b))
    if(b.na > 0){
      stop("Argument 'b' has ",
           b.na,
           " NA values. Please remove or imputate NA values before the dissimilarity analysis."
      )
    }

    if(inherits(x = b, what = "data.frame")){
      b <- b[, sapply(b, is.numeric)]
    }


  }

    #check colnames
    if(
      (is.null(colnames(a)) | is.null(colnames(b))) &&
      ncol(a) != ncol(b)
    ){

      stop("Arguments 'a' and 'b' must either have column names or the same number of columns.")

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

  #storing attributes
  a.time <- attributes(a)$time
  a.sequence_name <- attributes(a)$sequence_name

  b.time <- attributes(b)$time
  b.sequence_name <- attributes(b)$sequence_name

  #subsetting to common columns
  if(ncol(a) != ncol(b)){
    common.cols <- intersect(
      x = colnames(a),
      y = colnames(b)
    )
    a <- a[, common.cols, drop = FALSE]
    b <- b[, common.cols, drop = FALSE]
  }

  #convert to matrix
  if(!is.matrix(a)){
    a <- as.matrix(a)
  }

  if(!is.matrix(b)){
    b <- as.matrix(b)
  }

  #restoring attributes
  attr(x = a, which = "time") <- a.time
  attr(x = a, which = "sequence_name") <- a.sequence_name

  attr(x = b, which = "time") <- b.time
  attr(x = b, which = "sequence_name") <- b.sequence_name

  if(is.null(attributes(a)$sequence_name)){
    attr(a, "name") <- "a"
  }

  if(is.null(attributes(b)$sequence_name)){
    attr(b, "name") <- "b"
  }

  attr(a, "validated") <- TRUE
  attr(b, "validated") <- TRUE

  out <- list(
    a = a,
    b = b
  )

  names(out) <- c(
    ifelse(
      test = is.null(attributes(a)$sequence_name),
      yes = "a",
      no = attributes(a)$sequence_name
    ),
    ifelse(
      test = is.null(attributes(b)$sequence_name),
      yes = "b",
      no = attributes(b)$sequence_name
    )
  )

  out

}
