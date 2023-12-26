prepare_sequences <- function(
    sequences = NULL,
    id_column = NULL,
    time_column = NULL,
    transformation = "none", #add as a transformation function instead of a name
    paired_samples = FALSE,
    pseudo_zero = NULL
){

  transformation <- match.arg(
    arg = transformation,
    choices = c(
      "none",
      "percentage",
      "proportion",
      "hellinger",
      "scale"
    ),
    several.ok = FALSE
  )

  if(is.null(sequences)){
    stop("Argument 'sequences' must not be NULL")
  }

  #DATA FRAME TO LIST BY id_column
  if(inherits(x = sequences, what = "data.frame")){

    if(!(id_column %in% colnames(sequences))){
      stop("Argument 'id_column' must be a column name of 'sequences'.")
    }

    sequences <- split(
      x = sequences[, colnames(sequences) != id_column],
      f = sequences[[id_column]]
    )

  }

  #sequences is not a list
  if(inherits(x = sequences, what = "list") == FALSE){
    stop("Argument 'sequences' must be a list.")
  }

  #sequences is too short
  if(length(sequences) < 2){
    stop("Argument 'sequences' must be a list with a least two elements.")
  }

  if(any(is.null(names(sequences)))){
    stop("All elements in the list 'sequences' must be named.")
  }

  #check classes in sequences
  sequences.classes <- lapply(
    X = sequences,
    FUN = class
  ) |>
    unlist()

  sequences.classes <- sequences.classes[!(sequences.classes %in% c("data.frame", "matrix", "numeric"))]

  if(length(sequences.classes) > 0){
    warning("The elements of the list 'sequences' must be of the class 'data.frame', 'matrix', or 'numeric' (vector).")
  }

  #TIME

  #order by time
  sequences.with.time <- lapply(
    X = sequences,
    FUN = function(x) time_column %in% colnames(x)
  ) |>
    unlist() |>
    sum()

  if(sequences.with.time == length(sequences)){

    #arrange by time
    sequences <- lapply(
      X = sequences,
      FUN = function(x){
        x[order(x[[time_column]]), ]
      }
    )

    #add attribute to ignore time column
    sequences <- lapply(
      X = sequences,
      FUN = function(x){
        attr(x, "ignore_columns") <- time_column
        return(x)
      }
    )

  }

  #handle zeros

  #handle NA

  #transform
  if(is.null(time_column)){
    time_column <- "fake_time_column"
    sequences <- lapply(
      X = sequences,
      FUN = function(x){
        x[[time_column]] <- 0
        return(x)
      }
    )
  }

  if(transformation %in% c("proportion", "percentage")){
    sequences <- lapply(
      X = sequences,
      FUN = function(x){
        x.time <- x[[time_column]]
        x[[time_column]] <- NULL
        x <- sweep(x, 1, rowSums(x), FUN = "/")
        x[[time_column]] <- x.time
        return(x)
      }
    )
  }

  if (transformation == "percentage"){
    sequences <- lapply(
      X = sequences,
      FUN = function(x){
        x.time <- x[[time_column]]
        x[[time_column]] <- NULL
        x <- x*100
        x[[time_column]] <- x.time
        return(x)
      }
    )
  }

  if (transformation == "hellinger"){
    sequences <- lapply(
      X = sequences,
      FUN = function(x){
        x.time <- x[[time_column]]
        x[[time_column]] <- NULL
        x <- sqrt(sweep(x, 1, rowSums(x), FUN = "/"))
        x <- as.data.frame(x)
        x[[time_column]] <- x.time
        return(x)
      }
    )
  }

  if (transformation == "scale"){
    sequences <- lapply(
      X = sequences,
      FUN = function(x){
        x.time <- x[[time_column]]
        x[[time_column]] <- NULL
        x <- scale(
          x = x,
          center = TRUE,
          scale = TRUE
          )
        x <- as.data.frame(x)
        x[[time_column]] <- x.time
        return(x)
      }
    )
  }

  #remove fake column
  sequences <- lapply(
    X = sequences,
    FUN = function(x){
      x[, colnames(x) != "fake_time_column"]
    }
  )

  sequences

}
