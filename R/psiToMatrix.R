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

  #psi to dataframe
  psi.dataframe <- psiToDataframe(psi.values = psi.values)

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
