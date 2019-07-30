load("/home/blas/Dropbox/RESEARCH/PROJECTS/MAIN_PROJECTS/IGNEX/GITHUB/sequence_slotting_paper/suppplementary_material/data/functional_classification.RData")
rm(lai.raster, pixel.coordinates)

library(distantia)

#getting the right columns
modis <- data.modis[, c("pixel", "lai", "fpar", "gross.p")]
rm(data.modis)

#preparing the sequence
modis <- prepareSequences(
  sequences = modis,
  grouping.column = "pixel",
  transformation = "scale"
)

#test
modis.psi <- workflowPsiHP(
  sequences = modis,
  grouping.column = "pixel",
  time.column = NULL,
  exclude.columns = NULL,
  method = "euclidean",
  diagonal = TRUE,
  format = "dataframe",
  paired.samples = FALSE,
  ignore.blocks = FALSE,
  parallel.execution = TRUE
)
