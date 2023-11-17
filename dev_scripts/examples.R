#install the package
library(devtools)
devtools::install()

library(distantia)
library(tictoc)

#progress
ls("package:distantia")
# [1] "autoSum"
# [2] "climate"
# [3] "climateLong"
# [4] "climateShort"
# [5] "distance"
# [6] "distanceMatrix"
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

#autoSum
########################################
tic()

#loading data
data(sequenceA)
data(sequenceB)

#preparing datasets
AB.sequences <- prepareSequences(
 sequence.A = sequenceA,
 sequence.A.name = "A",
 sequence.B = sequenceB,
 sequence.B.name = "B",
 merge.mode = "complete",
 if.empty.cases = "zero",
 transformation = "hellinger"
 )

#computing distance matrix
AB.distance.matrix <- distanceMatrix(
 sequences = AB.sequences,
 grouping.column = "id",
 method = "manhattan",
 parallel.execution = FALSE
 )

#computing least cost matrix
AB.least.cost.matrix <- leastCostMatrix(
 distance.matrix = AB.distance.matrix,
 diagonal = FALSE,
 parallel.execution = FALSE
 )

AB.least.cost.path <- leastCostPath(
 distance.matrix = AB.distance.matrix,
 least.cost.matrix = AB.least.cost.matrix,
 parallel.execution = FALSE
 )

#autosum
AB.autosum <- autoSum(
 sequences = AB.sequences,
 least.cost.path = AB.least.cost.path,
 grouping.column = "id",
 parallel.execution = FALSE
 )
AB.autosum

toc()
