#' Turns the output of \code{\link{psi}} into a dataframe.
#'
#' @description Parses a list produced by \code{\link{psi}} to generate a dataframe with psi values for every pair of sequences available in the data. This dataframe allows an easy plotting of the dissimilarity pattern.
#'
#' @usage psiToDataframe(psi.values = NULL)
#'
#' @param psi.values list produced by \code{\link{psi}}.
#'
#' @author Blas Benito <blasbenito@gmail.com>
#' @export
psiToDataframe <- function(psi.values){

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

  return(psi.dataframe)

}
