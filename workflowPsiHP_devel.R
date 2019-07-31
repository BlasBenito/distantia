
library(distantia)
library(raster)
load("/home/blas/Dropbox/RESEARCH/PROJECTS/MAIN_PROJECTS/IGNEX/GITHUB/sequence_slotting_paper/suppplementary_material/data/functional_classification.RData")
rm(lai.raster, pixel.coordinates)


#getting the right columns
modis <- data.modis[, c("pixel", "lai", "fpar", "gross.p")]
rm(data.modis)

#preparing the sequence
modis <- prepareSequences(
  sequences = modis,
  grouping.column = "pixel",
  transformation = "scale"
)

modis <- modis[modis$pixel %in% 1:2, ]

#new version
modis.psi.new <- workflowPsiHP(
  sequences = modis,
  grouping.column = "pixel"
)


#old version
modis.psi.old <- workflowPsi(
  sequences = modis,
  grouping.column = "pixel",
  time.column = NULL,
  exclude.columns = NULL,
  parallel.execution = TRUE,
  diagonal = TRUE,
  ignore.blocks = TRUE,
  method = "euclidean"
)

