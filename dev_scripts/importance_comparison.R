library(distantia)
library(dplyr)

#OLD METHOD
#################################
#getting example data
data(sequencesMIS)

#getting three groups only to simplify
sequencesMIS <- sequencesMIS |>
  dplyr::filter(
    MIS %in% c("MIS-4", "MIS-5")
  )

#preparing sequences
sequences <- prepareSequences(
  sequences = sequencesMIS,
  grouping.column = "MIS",
  merge.mode = "complete"
)

# psi.importance <- workflowImportance(
#   sequences = sequencesMIS,
#   grouping.column = "MIS",
#   method = "euclidean",
#   diagonal = TRUE,
#   ignore.blocks = TRUE
# )
#
# > psi.importance
# $psi
# A     B All variables Without Carpinus Without Tilia
# 1 MIS-4 MIS-5      3.891664         3.893886      3.903592
# Without Alnus Without Pinus Without Betula Without Quercus
# 1      3.905642      5.534695       3.912197       0.9693391
#
# $psi.drop
# A     B Carpinus Tilia Alnus  Pinus Betula Quercus
# 1 MIS-4 MIS-5    -0.06 -0.31 -0.36 -42.22  -0.53   75.09

##NEW METHOD
a <- sequences |>
  dplyr::filter(
    MIS == "MIS-4"
  ) |>
  dplyr::select(-MIS) |>
  as.matrix()

b <- sequences |>
  dplyr::filter(
    MIS == "MIS-5"
  ) |>
  dplyr::select(-MIS) |>
  as.matrix()

ab_importance <- importance_full_cpp(
  a,
  b,
  method = "euclidean",
  diagonal = TRUE,
  weighted = FALSE,
  trim_blocks = TRUE
)

ab_importance
