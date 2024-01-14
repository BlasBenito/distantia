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
    distance = distance
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
  a <- x[[x.names[1]]]

  #remove it from x.names
  x.names <- x.names[-1]

  # combine sequences ----
  while(length(x.names) > 0){

    #prepare sequences to merge them
    ab <- prepare_ab(
      a = a,
      b = x[[x.names[1]]],
      distance = distance
    )

    #generate least cost path to combine sequences
    path <- combination_path(
      x = ab,
      distance = distance
    )

    #add provenance columns
    ab[[1]] <- as.data.frame(ab[[1]])
    ab[[2]] <- as.data.frame(ab[[2]])
    ab[[1]]$name <- names(ab)[1]
    ab[[2]]$name <- names(ab)[2]
    ab[[1]]$row <- 1:nrow(ab[[1]])
    ab[[2]]$row <- 1:nrow(ab[[2]])

    #remove b from x.names
    x.names <- x.names[-1]

    #output data frame
    ab.combined <- ab[[1]][0, ]

    #iterating over path
    for(i in seq_len(nrow(path))){

      a.na <- is.na(path$a[i])
      b.na <- is.na(path$b[i])

      #never happens?
      if(a.na && b.na){
        next
      }

      if(a.na){
        new.row <- ab[[2]][path$b[i], ]
      }

      if(b.na){
        new.row <- ab[[1]][path$a[i], ]
      }

      if(!a.na && !b.na){
        candidate.rows <- c(path$a[i], path$b[i])
        j <- which.max(candidate.rows)
        k <- which.min(candidate.rows)
        new.row <- rbind(
          ab[[j]][path[i, j], ],
          ab[[k]][path[i, k], ]
        ) |>
          na.omit()
      }

      ab.combined <- rbind(
        ab.combined,
        new.row
      )

    } #end of combination loop

    rownames(ab.combined) <- NULL

    a <- ab.provenance <- ab.combined

  }

  ab.combined

}
