



autoSum <- function(sequence.A, sequence.B, method = "manhattan"){
  #COMPUTING AUTOSUMS
  ############################################################################################
  distances.sequence.A <- vector()
  distances.sequence.B <- vector()

  #computing manhattan distance
  if (method %in% c("manhattan", "Manhattan", "MANHATTAN", "man", "Man", "MAN")){
    for (i in 1:(nrow.sequence.A-1)){
      distances.sequence.A[i] <- .ManhattanDistance(x = sequence.A[i, ], y = sequence.A[i+1, ])
    }

    for (j in 1:(nrow.sequence.B-1)){
      distances.sequence.B[j] <- .ManhattanDistance(x = sequence.B[j, ], y = sequence.B[j+1, ])
    }
  }


  #computing hellinger distance
  if (method %in% c("hellinger", "Hellinger", "HELLINGER", "Hell", "hell", "HELL")){
    for (i in 1:nrow.sequence.A-1){
      distances.sequence.A[i] <- .HellingerDistance(x = sequence.A[i, ], y = sequence.A[i+1, ])
    }

    for (j in 1:nrow.sequence.B-1){
      distances.sequence.B[j] <- .HellingerDistance(x = sequence.B[j, ], y = sequence.B[j+1, ])
    }
  }

  #computing euclidean distance
  if (method %in% c("euclidean", "Euclidean", "EUCLIDEAN", "euc", "Euc", "EUC")){
    for (i in 1:nrow.sequence.A-1){
      distances.sequence.A[i] <- .EuclideanDistance(x = sequence.A[i, ], y = sequence.A[i+1, ])
    }

    for (j in 1:nrow.sequence.B-1){
      distances.sequence.B[j] <- .EuclideanDistance(x = sequence.B[j, ], y = sequence.B[j+1, ])
    }
  }

  #computing chi distance
  if (method %in% c("chi", "Chi", "CHI", "chi.squared", "Chi.squared", "CHI.SQUARED")){
    for (i in 1:nrow.sequence.A-1){
      distances.sequence.A[i] <- .ChiDistance(x = sequence.A[i, ], y = sequence.A[i+1, ])
    }

    for (j in 1:nrow.sequence.B-1){
      distances.sequence.B[j] <- .ChiDistance(x = sequence.B[j, ], y = sequence.B[j+1, ])
    }
  }

  #SUMMING DISTANCES
  sum.distances.sequence.A <- sum(distances.sequence.A)
  sum.distances.sequence.B <- sum(distances.sequence.B)

}
