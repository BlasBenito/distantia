#' Extracts the least cost path from a least cost matrix.
#'
#' @description Extracts the least cost path from a least cost matrix.
#'
#' @usage leastCostPath(least.cost.matrix = NULL)
#'
#' #' @param distance.matrix numeric matrix or list of numeric matrices, a distance matrix produced by \code{\link{distanceMatrix}}.
#' @param least.cost.matrix numeric matrix or list of numeric matrices produced by \code{\link{leastCostMatrix}}.
#' @param diagonal boolean, if \code{TRUE}, diagonals are included in the computation of the least cost path. Defaults to \code{FALSE}, as the original algorithm did not include diagonals in the computation of the least cost path.
#' @return A list of dataframes if \code{least.cost.matrix} is a list, or a dataframe if \code{least.cost.matrix} is a matrix. The dataframe/s have the following columns:
#' \itemize{
#' \item \emph{A} row/sample of one of the sequences.
#' \item \emph{B} row/sample of one the other sequence.
#' \item \emph{distance} distance between both samples, extracted from \code{distance.matrix}.
#' \item \emph{cumulative.distance} cumulative distance at the samples \code{A} and \code{B}.
#' }
#' @examples
#'
#' @export
plotMatrix <- function(distance.matrix = NULL,
                       least.cost.path = NULL,
                       plot.columns = NULL,
                       plot.rows = NULL,
                       margins = c(1,2,4,1),
                       legend = TRUE,
                       filename = NULL,
                       figure.width = NULL,
                       figure.height = NULL,
                       figure.pointsize = NULL
                       ){


  #if input is matrix, get it into list
  if(inherits(distance.matrix, "matrix") == TRUE | is.matrix(distance.matrix) == TRUE){
    temp <- list()
    temp[[1]] <- distance.matrix
    distance.matrix <- temp
    names(distance.matrix) <- ""
  }

  #if input is matrix, get it into list
  if(!is.null(least.cost.path)){
    if(inherits(least.cost.path, "data.frame") == TRUE | is.data.frame(least.cost.path) == TRUE){
      temp <- list()
      temp[[1]] <- least.cost.path
      least.cost.path <- temp
      names(least.cost.path) <- ""
    }

    if(inherits(least.cost.path, "list") == TRUE){
      m.elements <- length(least.cost.path)
    }

    if(n.elements != m.elements){
      stop("Arguments 'distance.matrix' and 'least.cost.matrix' don't have the same number of slots.")
    }

    if(n.elements > 1){
      if(sum(names(distance.matrix) %in% names(least.cost.path)) != n.elements){
        stop("Elements in arguments 'distance.matrix' and 'least.cost.path' don't have the same names.")
      }
    }
  }

  #number of elements in distance.matrix
  if(inherits(distance.matrix, "list") == TRUE){
    n.elements <- length(distance.matrix)
  }

  #trying to guess plot.columns and plot.rows if they are null
  if(is.null(plot.columns) & is.null(plot.rows)){
    plot.rows.columns <- grDevices::n2mfrow(n.elements)
  } else {
    plot.rows.columns <- c(plot.rows, plot.columns)
  }

  #defaults for figure width and heights
  if(is.null(figure.height)){figure.height <- plot.rows.columns[1]*3}
  if(is.null(figure.width)){figure.height <- plot.rows.columns[2]*5}
  if(is.null(figure.pointsize)){figure.pointsize <- 15}

  #opening pdf if filename is not null
  if(!is.null(filename)){
    grDevices::pdf(file = paste(filename, ".pdf", sep=""), width = figure.width, height=figure.height, pointsize = figure.pointsize)
  }

  #plot dimensions
  par(mfrow = plot.rows.columns, mar = margins)

  #iterating through elements in distance.matrix
  for(i in 1:n.elements){

    #getting distance matrix
    distance.matrix.i <- distance.matrix[[i]]

    #matrix name
    matrix.name <- names(distance.matrix)[i]

    #parse names
    sequence.names = unlist(strsplit(matrix.name, split='|', fixed=TRUE))
    if(length(sequence.names) == 0){
      ylab.name <- "A"
      xlab.name <- "B"
      title <- "A vs. B"
    } else {
      ylab.name <- sequence.names[1]
      xlab.name <- sequence.names[2]
      title <- paste(sequence.names, collapse = " vs. ")
    }

    #getting path
    if(!is.null(least.cost.path)){
      path.i <- least.cost.path[[i]]
    }


    #plot
    if(legend == FALSE){
    image(x = 1:nrow(distance.matrix.i),
                     y = 1:ncol(distance.matrix.i),
                     z = distance.matrix.i,
                     xlab = ylab.name,
                     ylab = xlab.name,
                     main = title,
                     col = colorRampPalette(rev(RColorBrewer::brewer.pal(9, "RdBu")))(100))
    }

    if(legend == TRUE){
      fields::image.plot(x = 1:nrow(distance.matrix.i),
            y = 1:ncol(distance.matrix.i),
            z = distance.matrix.i,
            xlab = ylab.name,
            ylab = xlab.name,
            main = title,
            col = colorRampPalette(rev(RColorBrewer::brewer.pal(9, "RdBu")))(100))
    }

    #add path
    if(!is.null(least.cost.path)){
       lines(path.i$A, path.i$B, lwd=2)
    }

  }#end of iterations

  if(!is.null(filename)){
    grDevices::dev.off()
  }

}
