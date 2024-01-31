#' Combination of Sequences via Least Cost Path
#'
#' @description Combines two sequences by arranging their cases as defined in their orthogonal least cost path. When more than two sequences are provided in `x`, all sequences are first ordered according to their psi scores. Then, the first two sequences (the more similar ones) are combined first, and the remaining ones are added to the composite sequence one by one.
#'
#' @param x (required, list of matrices) list of input matrices generated with [prepare_sequences()].
#' @param distance (optional, character vector) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#'
#' @return Data frame with composite sequence and columns identifying the origin of each new row.
#' @export
#' @autoglobal
combine <- function(
    x = NULL,
    distance = "euclidean"
){

  # check input arguments ----
  x <- check_args_x(
    x = x
  )

  distance <- check_args_distance(
    distance = distance[1]
  )

  # sort sequences by similarity ----
  x <- arrange_by_similarity(
    x = x,
    distance = distance
  )

  #

  #get names
  x.names <- names(x)


  # combine sequences sequentially ----

  # create output sequence
  x <- x[[x.names[1]]]

  #remove it from x.names
  x.names <- x.names[-1]

  # combine sequences ----
  while(length(x.names) > 0){

    #prepare sequences to merge them
    xy <- prepare_xy(
      x = x,
      y = x[[x.names[1]]],
      distance = distance
    )

    #generate least cost path to combine sequences
    path <- combination_path(
      x = xy,
      distance = distance
    )

    #add provenance columns
    xy[[1]] <- as.data.frame(xy[[1]])
    xy[[2]] <- as.data.frame(xy[[2]])
    xy[[1]]$name <- names(xy)[1]
    xy[[2]]$name <- names(xy)[2]
    xy[[1]]$row <- 1:nrow(xy[[1]])
    xy[[2]]$row <- 1:nrow(xy[[2]])

    #remove y from x.names
    x.names <- x.names[-1]

    #output data frame
    xy.combined <- xy[[1]][0, ]

    #iterating over path
    for(i in seq_len(nrow(path))){

      x.na <- is.na(path$x[i])
      y.na <- is.na(path$y[i])

      #never happens?
      if(x.na && y.na){
        next
      }

      if(x.na){
        new.row <- xy[[2]][path$y[i], ]
      }

      if(y.na){
        new.row <- xy[[1]][path$x[i], ]
      }

      if(!x.na && !y.na){
        candidate.rows <- c(path$x[i], path$y[i])
        j <- which.max(candidate.rows)
        k <- which.min(candidate.rows)
        new.row <- rbind(
          xy[[j]][path[i, j], ],
          xy[[k]][path[i, k], ]
        ) |>
          na.omit()
      }

      xy.combined <- rbind(
        xy.combined,
        new.row
      )

    } #end of combination loop

    rownames(xy.combined) <- NULL

    x <- xy.provenance <- xy.combined

  }

  xy.combined

}
