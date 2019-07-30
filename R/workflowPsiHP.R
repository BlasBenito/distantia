workflowPsiHP <- function(sequences = NULL,
                        grouping.column = NULL,
                        time.column = NULL,
                        exclude.columns = NULL,
                        parallel.execution = TRUE){


  #PREPARING sequences
  ####################
  #removing time column
  if(!is.null(time.column)){
    if(time.column %in% colnames(sequences)){
      sequences[, time.column] <- NULL
    }
  }

  #removing exclude columns
  if(!is.null(exclude.columns)){
    sequences <- sequences[,!(colnames(sequences) %in% exclude.columns)]
  }

  #to data.table
  sequences <- data.table::data.table(
    sequences,
    stringsAsFactors = FALSE
    )
  data.table::setkey(sequences)

  #select numeric columns
  numeric.cols <- colnames(sequences)[which(
    as.vector(
      sequences[,lapply(.SD, class)]) %in% c("numeric", "integer")
    )]
  numeric.cols <- numeric.cols[numeric.cols != grouping.column]

  #multiply by 1000
  sequences[,(numeric.cols):= lapply(.SD, FUN = function(x) x * 1000), .SDcols = numeric.cols]

  #to integer
  sequences[,(numeric.cols):= lapply(.SD, FUN = as.integer), .SDcols = numeric.cols]

  #generate combinations of groups for subsetting
  # combinations <- utils::combn(unique(sequences[[grouping.column]]), m=2)

  #indices to data.table
  gc <- data.table::as.data.table(unique(sequences[[grouping.column]]))

  # add interval columns for overlaps
  gc[, `:=`(id1 = 1L, id2 = .I)]
  data.table::setkey(gc, id1, id2)

  #generating combinations
  combinations <- data.table::foverlaps(gc, gc, type="within", which=TRUE)[xid != yid]

  #number of combinations
  n.iterations <- nrow(combinations)

  #parallel execution = TRUE
  if(parallel.execution == TRUE){
    `%dopar%` <- foreach::`%dopar%`
    n.cores <- parallel::detectCores() - 1
    if(n.iterations < n.cores){n.cores <- n.iterations}
    my.cluster <- parallel::makeCluster(n.cores, type="FORK")
    doParallel::registerDoParallel(my.cluster)

    #exporting cluster variables
    parallel::clusterExport(cl=my.cluster,
                            varlist=c('combinations',
                                      'sequences',
                                      'distance',
                                      'numeric.cols',
                                      'grouping.column'),
                            envir=environment()
    )
  } else {
    #replaces dopar (parallel) by do (serial)
    `%dopar%` <- foreach::`%do%`
  }

  #parallelized loop
  ##################
  ##################
  distance.matrices <- foreach::foreach(i=1:n.iterations) %dopar% {

    #getting combination
    combination <- as.numeric(combinations[i, ])


    #computing euclidean distance matrix
    ####################################
    distance.matrix <- fields::rdist(
      x1 = as.matrix(sequences[get(grouping.column) == combination[1], ..numeric.cols]),
      x2 = as.matrix(sequences[get(grouping.column) == combination[2], ..numeric.cols])
      )


    #computing least cost matrix
    ############################
    #dimensions
    least.cost.rows <- nrow(distance.matrix)
    least.cost.columns <- ncol(distance.matrix)

    #matrix to store least cost
    least.cost.matrix <- matrix(NA, nrow = least.cost.rows, ncol = least.cost.columns)
    least.cost.matrix[1,1] <- distance.matrix[1,1]

    #initiating first columns and rows
    least.cost.matrix[1, ] <- cumsum(distance.matrix[1, ])
    least.cost.matrix[, 1] <- cumsum(distance.matrix[, 1])

    #dynamic programming algorithm
    for (column in 1:(least.cost.columns-1)){
      for (row in 1:(least.cost.rows-1)){

        next.row <- row+1
        next.column <- column+1

        least.cost.matrix[next.row, next.column]  <-  min(least.cost.matrix[row, next.column], least.cost.matrix[next.row, column], least.cost.matrix[row, column]) + distance.matrix[next.row, next.column]

      }
    }


    #computing least cost path
    ###########################
    #dataframe to store the path
    path <- data.frame(A = least.cost.rows,
                       B = least.cost.columns,
                       distance = distance.matrix[least.cost.rows, least.cost.columns],
                       cumulative.distance = least.cost.matrix[least.cost.rows, least.cost.columns])

    #defining coordinates of the focal cell
    focal.row <- path$A
    focal.column <- path$B

    #going through the matrix
    repeat{

      #defining values o focal row
      focal.cumulative.cost <- least.cost.matrix[focal.row, focal.column]
      focal.cost <- distance.matrix[focal.row, focal.column]

      #SCANNING NEIGHBORS
      neighbors <- data.frame(A = c(focal.row-1, focal.row-1, focal.row),
                              B=c(focal.column, focal.column-1, focal.column-1))

      #removing neighbors with coordinates lower than 1 (out of bounds)
      neighbors[neighbors<1] <- NA
      neighbors <- stats::na.omit(neighbors)
      if(nrow(neighbors) == 0){break}

      #computing cost and cumulative cost values for the neighbors
      if(nrow(neighbors) > 1){

        neighbors$distance <- diag(distance.matrix[neighbors$A, neighbors$B])
        neighbors$cumulative.distance <- diag(x = least.cost.matrix[neighbors$A, neighbors$B])

      }else{

        neighbors$distance <- distance.matrix[neighbors$A, neighbors$B]
        neighbors$cumulative.distance <- least.cost.matrix[neighbors$A, neighbors$B]

      }

      #getting the neighbor with a minimum least.cost.matrix
      neighbors <- neighbors[which.min(neighbors$cumulative.distance), c("A", "B")]

      #temporal dataframe to rbind with path
      path.temp <- data.frame(
        A = neighbors$A,
        B = neighbors$B,
        distance = distance.matrix[neighbors$A, neighbors$B],
        cumulative.distance = least.cost.matrix[neighbors$A, neighbors$B]
      )

      #putting them together
      path<-rbind(path, path.temp)

      #new focal cell
      focal.row <- path[nrow(path), "A"]
      focal.column <- path[nrow(path), "B"]

    }#end of repeat

    #renaming path
    colnames(path)[1] <- combination[1]
    colnames(path)[2] <- combination[2]

    #REMOVING BLOCKS leastCostPathNoBlocks

    #GETTING LEAST COST leastCost

    #AUTOSUM autoSum

    #PSI psi


  }#end of parallelized loop

}
