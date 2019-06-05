#' Formats the output of \code{\link{psi}}.
#'
#' @description Parses a list produced by \code{\link{psi}} to generate either a dataframe or a matrix. Can also format a psi matrix into a dataframe and viceversa.
#'
#' @usage formatPsi(
#'   psi.values = NULL,
#'   to = "dataframe")
#'
#' @param psi.values list produced by \code{\link{psi}}.
#' @param to character, either "dataframe" or "matrix".
#'
#' @details The function detects the type of input, and checks that it is different from the value of \code{to}. If that is the case, it throws a warning, and returns the input object. It uses the helper function .psiToDataframe, only intended for internal use.
#'
#' @author Blas Benito <blasbenito@gmail.com>
#' @export
formatPsi <- function(psi.values = NULL,
                      to = "dataframe"){

  #string options
  to.dataframe.options <- c("dataframe", "Dataframe", "DATAFRAME", "data.frame", "Data.frame", "DATA.FRAME", "df")
  to.matrix.options <- c("matrix", "Matrix", "MATRIX", "m", "M")
  to.list.options <- c("list", "List", "LIST", "l", "L")

  #IF THE INPUT IS A LIST
  ##########################################
  if(inherits(psi.values, "list") == TRUE){

    #check to
    if(to %in% to.list.options){
      warning("The input is a list, and your desired output is a list. I did nothing.")
      return(psi.values)
    }

    #IF THE OUTPUT IS A DATAFRAME
    #----------------------------
    if(to %in% to.dataframe.options){
      psi.dataframe <- .psiToDataframe(psi.values = psi.values)
      return(psi.dataframe)
    } #end of list to dataframe


    #IF THE OUTPUT IS A MATRIX
    #----------------------------
    if(to %in% to.matrix.options){

      #to dataframe anyway
      psi.dataframe <- .psiToDataframe(psi.values = psi.values)

      #row/column names
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

    } #end of list to matrix

  } #end of input is list


  #IF THE INPUT IS A MATRIX
  ##########################################
  if(inherits(psi.values, "matrix") == TRUE){

    #check to
    if(to %in% to.matrix.options){
      warning("The input is a maatrix, and your desired output is a matrix I did nothing.")
      return(psi.values)
    }

    #IF THE INPUT IS A DATAFRAME
    #--------------------------------
    if(to %in% to.dataframe.options){

      #removing the lower triangle
      psi.values.dist <- stats::as.dist(psi.values)

      #getting dimensions and names
      dimensions <- attr(psi.values.dist, "Size")
      sequence.names <- if (is.null(attr(psi.values.dist, "Labels"))) sequence(dimensions) else attr(psi.values.dist, "Labels")

      #to dataframe
      psi.dataframe <- data.frame(
        A = rep(sequence.names[-length(sequence.names)], (length(sequence.names)-1):1),
        B = sequence.names[unlist(lapply(sequence(dimensions)[-1], function(x) x:dimensions))],
        psi = as.vector(psi.values.dist),
        stringsAsFactors = FALSE)

      return(psi.dataframe)
    }

  } # end of input is a matrix


  #IF THE INPUT IS A DATAFRAME
  ###########################################
  if(inherits(psi.values, "data.frame") == TRUE){

    #check to
    if(to %in% to.dataframe.options){
      warning("The input is a dataframe, and your desired output is a dataframe I did nothing.")
      return(psi.values)
    }

    #row/column names
    row.col.names <- unique(c(psi.values$A, psi.values$B))

    #empty matrix
    psi.matrix <- matrix(NA, nrow=length(row.col.names), ncol=length(row.col.names))
    colnames(psi.matrix) <- rownames(psi.matrix) <- row.col.names

    #filling matrix
    for(i in 1:nrow(psi.values)){

      #getting matrix coordinates by name
      A <- psi.values[i, "A"]
      B <- psi.values[i, "B"]

      #filling matrix
      psi.matrix[A, B] <- psi.matrix[B, A] <- psi.values[i, "psi"]
    }

    #diagonal to 0
    psi.matrix[is.na(psi.matrix)] <- 0

    return(psi.matrix)


  }



} #end of function



#'@export
.psiToDataframe <- function(psi.values = NULL){

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
  psi.dataframe <- data.frame(A = nas, B = nas, psi = nas, stringsAsFactors = FALSE)

  #iterating through list
  for(i in 1:n.elements){

    #getting psi
    psi.dataframe[i, "psi"] <- psi.values[[i]]

    #parsing and getting sequence names
    psi.dataframe[i, c("A", "B")] <- unlist(strsplit(names(psi.values)[i], split='|', fixed=TRUE))

  }

  return(psi.dataframe)

}
