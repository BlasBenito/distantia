#install the package
library(devtools)
devtools::install()

library(distantia)
library(tictoc)

#progress
ls("package:distantia")

#DONE
# [5] "distance"
# [6] "distanceMatrix"

#TODO
# [1] "autoSum"
# [2] "climate"
# [3] "climateLong"
# [4] "climateShort"
# [7] "distancePairedSamples"
# [8] "formatPsi"
# [9] "handleNA"
# [10] "leastCost"
# [11] "leastCostMatrix"
# [12] "leastCostPath"
# [13] "leastCostPathNoBlocks"
# [14] "plotMatrix"
# [15] "pollenGP"
# [16] "prepareSequences"
# [17] "psi"
# [18] "sequenceA"
# [19] "sequenceB"
# [20] "sequencesMIS"
# [21] "workflowImportance"
# [22] "workflowImportanceHP"
# [23] "workflowNullPsi"
# [24] "workflowNullPsiHP"
# [25] "workflowPartialMatch"
# [26] "workflowPsi"
# [27] "workflowPsiHP"
# [28] "workflowSlotting"
# [29] "workflowTransfer"

#distance
########################################
########################################
#'
#' distance(
#'   x = runif(100),
#'   y = runif(100),
#'   method = "manhattan"
#' )
#'
#' distance_euclidean(
#'   x = runif(100),
#'   y = runif(100)
#' )
#'
#' distance_chi(
#'   x = runif(100),
#'   y = runif(100)
#' )
#'
#' distance_hellinger(
#'   x = runif(100),
#'   y = runif(100)
#' )
#'
#' distance_manhattan(
#'   x = runif(100),
#'   y = runif(100)
#' )
#'


#distanceMatrix
########################################
########################################
#' data(sequenceA)
#' data(sequenceB)
#'
#' #preparing  datasets
#' AB.sequences <- prepareSequences(
#'  sequence.A = sequenceA,
#'  sequence.A.name = "A",
#'  sequence.B = sequenceB,
#'  sequence.B.name = "B",
#'  merge.mode = "complete",
#'  if.empty.cases = "zero",
#'  transformation = "hellinger"
#'  )
#'
#' #computing distance matrix
#' AB.distance.matrix <- distanceMatrix(
#'  sequences = AB.sequences,
#'  grouping.column = "id",
#'  method = "manhattan",
#'  parallel.execution = FALSE
#'  )
#'
#' #plot
#' if(interactive()){
#'  plotMatrix(distance.matrix = AB.distance.matrix)
#' }


#distance_matrix
########################################
########################################

#' data(
#'   sequenceA,
#'   sequenceB
#' )
#'
#' distance.matrix <- distance_matrix(
#'   a = sequenceA,
#'   b = sequenceB,
#'   method = "manhattan"
#' )
#'
#' if(interactive()){
#'  plotMatrix(distance.matrix = distance.matrix)
#' }
