#' Turns the output of \code{\link{psi}} into a matrix.
#'
#' @description Parses a list produced by \code{\link{psi}} to generate a matrix of psi values among every pair of sequences available in the data. This matrix allows an easy plotting of the dissimilarity pattern, either as a heatmap, or as a network.
#'
#' @usage psiToMatrix(psi.values = NULL)
#'
#' @param psi.values list produced by \code{\link{psi}}.
#'
#' @author Blas Benito <blasbenito@gmail.com>
#' @export
psiToMatrix <- function(psi.values){

  #computing number of elements
  if(inherits(psi.values, "list") == TRUE){
    n.elements <- length(psi.values)
  } else {
    temp <- list()
    temp[[1]] <- psi.values
    psi.values <- temp
    names(psi.values) <- "A|B"
    n.elements <- 1
  }

  #generate dataframe to store psi values
  nas <- rep(NA, n.elements)
  psi.dataframe <- data.frame(A = nas, B = nas, psi = nas)

  #iterating through list
  for(i in 1:n.elements){

    #getting psi
    psi.dataframe[i, "psi"] <- psi.values[[i]]

    #parsing and getting sequence names
    psi.dataframe[i, c("A", "B")] <- unlist(strsplit(names(psi.values)[i], split='|', fixed=TRUE))

  }

  #dataframe to matrix

  #row and colnames
  row.col.names <- unique(c(psi.dataframe$A, psi.dataframe$B))

  #empty matrix
  psi.matrix <- matrix(NA, nrow=length(row.col.names), ncol=length(row.col.names))
  colnames(psi.matrix) <- rownames(psi.matrix) <- row.col.names

  #filling matrix
  for(i in 1:nrow(psi.dataframe)){

    #getting matrix coordinates by name
    A <- psi.dataframe[i, "A"]
    B <- psi.dataframe[i, "B"]

    #filling matrix
    psi.matrix[A, B] <- psi.matrix[B, A] <- psi.dataframe[i, "psi"]
  }

  #diagonal to 0
  psi.matrix[is.na(psi.matrix)] <- 0

  return(psi.matrix)

}
